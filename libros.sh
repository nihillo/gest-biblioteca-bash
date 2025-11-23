#!/bin/bash
source ./config.sh
source ./util.sh

verificar_no_existe_libro() {
    # Verificar que el libro no exista ya
    existe=$(buscar_linea "$1" "$F_LIBROS")
    if [ -n "$existe" ]; then
        echo "Error: Ya existe un libro con el ISBN '$1'."
        return
    fi
}

verificar_existe_libro() {
    # Verificar que el libro exista
    existe=$(buscar_linea "$1" "$F_LIBROS")
    if ! [ -n "$existe" ]; then
        echo "Error: No existe un libro con ISBN '$1'."
        return
    fi
}

# Funciones de gestión de libros
registrar_libro() {

    # Validaciones
    v_isbn=$(validar_isbn "$1")
    v_no_existe=$(verificar_no_existe_libro "$1")
    v_titulo=$(validar_texto "$2" "título")
    v_autor=$(validar_texto "$3" "autor")

    for v in "$v_isbn" "$v_no_existe" "$v_titulo" "$v_autor"; do
        if [ -n "$v" ]; then
            echo $v
            return
        fi
    done
    
    # Registrar el libro
    añadir_linea "$1""$SEPARADOR""$2""$SEPARADOR""$3" "$F_LIBROS"
    echo "Libro registrado: "$1 $2 $3
    return
}

buscar_libro() {

    echo "Resultados de la búsqueda para '$1':"
    printf "\n"
    # Crear un archivo temporal para formatear la salida
    printf "ISBN"$SEPARADOR"Título"$SEPARADOR"Autor\n" >> salida-temp.txt
    printf "========="$SEPARADOR"=========="$SEPARADOR"==========\n" >> salida-temp.txt
    buscar_linea "$1" "$F_LIBROS" >> salida-temp.txt
    # Salida formateada en columnas
    column -t -s{$SEPARADOR} salida-temp.txt
    # Se elimina el archivo temporal
    rm salida-temp.txt
}

modificar_libro() {
    # Validaciones
    v_isbn=$(validar_isbn "$1")
    v_existe=$(verificar_existe_libro "$1")
    v_nuevo_valor=$(validar_texto "$3" "$2")
    
    for v in "$v_isbn" "$v_existe" "$v_nuevo_valor"; do
        if [ -n "$v" ]; then
            echo $v
            return
        fi
    done

    # Determinar el campo a modificar
    case $2 in
        titulo)
            campo=2
            ;;
        autor)
            campo=3
            ;;
        isbn)
            echo "Error: No se puede modificar el ISBN."
            return
            ;;
        *)
            echo "Error: Campo '$2' no reconocido. Use 'titulo' o 'autor'."
            return
            ;;
    esac

    # Modificar el libro
    echo "Modificando el libro"
    echo "Registro actual: "
    buscar_linea "$1" "$F_LIBROS"
    modificar_linea "$1" "$campo" "$3" "$F_LIBROS" "$SEPARADOR"
    echo "Registro modificado: "
    buscar_linea "$1" "$F_LIBROS"
}

eliminar_libro() {

    # Validaciones
    v_isbn=$(validar_isbn "$1")
    v_existe=$(verificar_existe_libro "$1")

    for v in "$v_isbn" "$v_existe"; do
        if [ -n "$v" ]; then
            echo $v
            return
        fi
    done

    # Eliminar el libro
    echo "Se borrará el libro:"
    l=$(buscar_linea "$1" "$F_LIBROS")
    echo "$l"
    borrar_linea "$l" "$F_LIBROS"
    echo "Libro eliminado"
}