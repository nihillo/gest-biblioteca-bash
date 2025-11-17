#!/bin/bash
source ./config.sh
source ./util.sh

# Funciones de gestión de préstamos
registrar_prestamo() {
    # Validaciones 
    # Validar formato del ISBN
    v_isbn=$(validar_isbn "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Verificar que el libro exista
    existe=$(buscar_linea "$1" "$F_LIBROS")
    if ! [ -n "$existe" ]; then
        echo "Error: No existe un libro con ISBN '$1'."
        return
    fi

    # Validar documento de identificación
    v_doc=$(validar_documento "$2")
    if [ -n "$v_doc" ]; then
        echo $v_doc
        return
    fi

    # Verificar que el usuario exista
    existe=$(buscar_linea "$2" "$F_USUARIOS")
    if [ -z "$existe" ]; then
        echo "Error: No existe un usuario con el NIF/NIE '$2'."
        return
    fi

    # Validar formato de la fecha
    v_fecha=$(validar_fecha "$3")
    if [ -n "$v_fecha" ]; then
        echo $v_fecha
        return
    fi

    # Verificar que el libro no esté ya prestado (devolución NULL)
    prestado=$(buscar_linea "$1" "$F_PRESTAMOS")
    echo 
    if echo "$prestado" | cut -d"$SEPARADOR" -f4 | grep -q "NULL"; then
        echo "Error: El libro con ISBN '$1' ya está prestado y no ha sido devuelto."
        return
    fi

    añadir_linea "$1""$SEPARADOR""$2""$SEPARADOR""$3""$SEPARADOR""NULL" "$F_PRESTAMOS"
    echo "Préstamo registrado: "$1 $2 $3
    return
}

registrar_devolucion() {
    # Validaciones
    # Validar formato del ISBN
    v_isbn=$(validar_isbn "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Validar formato de la fecha
    v_fecha=$(validar_fecha "$2")
    if [ -n "$v_fecha" ]; then
        echo $v_fecha
        return
    fi

    # Verificar que haya un préstamo activo para el libro (devolución NULL)
    prestamo_activo=$(buscar_linea "$1" "$F_PRESTAMOS")
    if [ -z "$prestamo_activo" ] || [[ $(echo "$prestamo_activo" | cut -d"$SEPARADOR" -f4) != "NULL" ]]; then
        echo "Error: No hay un préstamo activo para el libro con ISBN '$1'."
        return
    fi

    # Actualizar la línea del préstamo con la fecha de devolución
    echo "Actualizando devolución del libro con ISBN '$1'..."
    echo "Registro actual: $prestamo_activo"
    modificar_linea "$1" 4 "$2" "$F_PRESTAMOS" "$SEPARADOR"
    echo "Devolución registrada para el libro con ISBN '$1' en la fecha '$2'."
    echo "Registro actualizado: $(buscar_linea "$1" "$F_PRESTAMOS")"
}

listar_prestamos() {
    # Listar todos los libros actualmente en préstamo
    echo "Libros actualmente en préstamo:"
    printf "\n"
    # Crear un archivo temporal para formatear la salida
    printf "ISBN"$SEPARADOR"Título"$SEPARADOR"NIF/NIE usuario"$SEPARADOR"Nombre usuario"$SEPARADOR"Fecha Préstamo\n" >> salida-temp.txt
    printf "===="$SEPARADOR"======"$SEPARADOR"==============="$SEPARADOR"=============="$SEPARADOR"==============\n" >> salida-temp.txt
    while IFS=$SEPARADOR read -r isbn nif fecha_prestamo fecha_devolucion; do
        if [ "$fecha_devolucion" == "NULL" ]; then
            titulo=$(buscar_linea "$isbn" "$F_LIBROS" | cut -d"$SEPARADOR" -f2)
            nombre_usuario=$(buscar_linea "$nif" "$F_USUARIOS" | cut -d"$SEPARADOR" -f2)
            printf "%s%s%s%s%s%s%s%s%s\n" "$isbn" "$SEPARADOR" "$titulo" "$SEPARADOR" "$nif" "$SEPARADOR" "$nombre_usuario" "$SEPARADOR" "$fecha_prestamo" >> salida-temp.txt
        fi
    done < "$F_PRESTAMOS"

    # Salida formateada en columnas
    column -t -s{$SEPARADOR} salida-temp.txt

    # Se elimina el archivo temporal
    rm salida-temp.txt
}

listar_prestamos_usuario() {
    # Validaciones
    # Validar documento de identificación
    v_doc=$(validar_documento "$1")
    if [ -n "$v_doc" ]; then
        echo $v_doc
        return
    fi

    # Verificar que el usuario exista
    existe=$(buscar_linea "$1" "$F_USUARIOS")
    if [ -z "$existe" ]; then
        echo "Error: No existe un usuario con el NIF/NIE '$1'."
        return
    fi

    echo "Libros actualmente en préstamo para el usuario:"
    echo "NIF/NIE: '$1'"
    echo "Nombre: $(buscar_linea "$1" "$F_USUARIOS" | cut -d"$SEPARADOR" -f2)"
    printf "\n"

    # Iniciar flag para, en caso de no tener préstamos, indicarlo
    tiene_prestamos=false
    
    # Crear un archivo temporal para formatear la salida
    printf "ISBN"$SEPARADOR"Título"$SEPARADOR"Fecha Préstamo\n" >> salida-temp.txt
    printf "===="$SEPARADOR"======"$SEPARADOR"==============\n" >> salida-temp.txt
    while IFS=$SEPARADOR read -r isbn nif fecha_prestamo fecha_devolucion; do
        if [ "$nif" == "$1" ] && [ "$fecha_devolucion" == "NULL" ]; then
            tiene_prestamos=true
            titulo=$(buscar_linea "$isbn" "$F_LIBROS" | cut -d"$SEPARADOR" -f2)
            printf "%s%s%s%s%s\n" "$isbn" "$SEPARADOR" "$titulo" "$SEPARADOR" "$fecha_prestamo" >> salida-temp.txt
        fi
    done < "$F_PRESTAMOS"

    # Salida formateada en columnas
    if [ "$tiene_prestamos" = false ]; then
        echo "El usuario no tiene libros en préstamo."
        rm salida-temp.txt
        return
    else 
        column -t -s{$SEPARADOR} salida-temp.txt
    fi

    # Se elimina el archivo temporal
    rm salida-temp.txt
}

consultar_prestamo_libro() {
    # Validaciones
    # Validar formato del ISBN
    v_isbn=$(validar_isbn "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Verificar que el libro exista
    existe=$(buscar_linea "$1" "$F_LIBROS")
    if ! [ -n "$existe" ]; then
        echo "Error: No existe un libro con ISBN '$1'."
        return
    fi

    echo "Estado de préstamo del libro con ISBN '$1':"

     # Iniciar flag para, en caso de no tener préstamos, indicarlo
    tiene_prestamos=false
    
    while IFS=$SEPARADOR read -r isbn nif fecha_prestamo fecha_devolucion; do
        if [ "$isbn" == "$1" ] && [ "$fecha_devolucion" == "NULL" ]; then
            tiene_prestamos=true
            titulo=$(buscar_linea "$isbn" "$F_LIBROS" | cut -d"$SEPARADOR" -f2)
            nombre_usuario=$(buscar_linea "$nif" "$F_USUARIOS" | cut -d"$SEPARADOR" -f2)
            echo "El libro con ISBN '$isbn' y título '$titulo' está actualmente prestado al usuario:"
            echo "NIF/NIE: $nif"
            echo "Nombre: $nombre_usuario"
        fi
    done < "$F_PRESTAMOS"

    # Salida formateada en columnas
    if [ "$tiene_prestamos" = false ]; then
        echo "El libro no está actualmente prestado."
    fi

}

estadisticas_prestamos() {
    echo "Libros más prestados históricamente:"
    # Consultar los 10 procesos con más memoria como “simulación” de libros más prestados históricamente.
    # Mostrar de forma tabulada las columnas PID, COMMAND, %MEM, %CPU
    ps aux --sort=-%mem | head -n 11 | awk 'NR==1 {print $2, $11, $4, $3} NR>1 {print $2, $11, $4, $3}' | column -t
}    