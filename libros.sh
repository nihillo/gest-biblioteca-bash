#!/bin/bash

FICHERO="libros.csv"
SEPARADOR="|"



# Funciones de gestión de libros
registrar_libro() {

    # Validaciones
    # Validar formato del ISBN
    v_isbn=$(./util.sh "validar_isbn" "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Verificar que el libro no exista ya
    existe=$(./util.sh "buscar_linea" "$1" "$FICHERO")
    if [ -n "$existe" ]; then
        echo "Error: Ya existe un libro con el ISBN '$1'."
        return
    fi    

    # Validar texto del título y autor
    v_titulo=$(./util.sh "validar_texto" "$2" "título")
    if [ -n "$v_titulo" ]; then
        echo $v_titulo
        return
    fi

    v_autor=$(./util.sh "validar_texto" "$3" "autor")
    if [ -n "$v_autor" ]; then
        echo $v_autor
        return
    fi

    ./util.sh "añadir_linea" "$1""$SEPARADOR""$2""$SEPARADOR""$3" "$FICHERO"
    echo "Libro registrado: "$1 $2 $3
    return
}

buscar_libro() {

    echo "Resultados de la búsqueda para '$1':"
    printf "\n"
    # Crear un archivo temporal para formatear la salida
    printf "ISBN"$SEPARADOR"Título"$SEPARADOR"Autor\n" >> salida-temp.txt
    printf "========="$SEPARADOR"=========="$SEPARADOR"==========\n" >> salida-temp.txt
    ./util.sh "buscar_linea" "$1" "$FICHERO" >> salida-temp.txt
    # Salida formateada en columnas
    column -t -s{$SEPARADOR} salida-temp.txt
    # Se elimina el archivo temporal
    rm salida-temp.txt
}

modificar_libro() {
    # Validar formato del ISBN
    v_isbn=$(./util.sh "validar_isbn" "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Verificar que el libro exista
    existe=$(./util.sh "buscar_linea" "$1" "$FICHERO")
    if ! [ -n "$existe" ]; then
        echo "Error: No existe un libro con ISBN '$1'."
        return
    fi

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

    # Validar el nuevo valor
    v_texto=$(./util.sh "validar_texto" "$3" "$2")
    if [ -n "$v_texto" ]; then
        echo $v_texto
        return
    fi

    echo "Modificando el libro"
    echo "Registro actual: "
    ./util.sh "buscar_linea" "$1" "$FICHERO"
    ./util.sh "modificar_linea" "$1" "$campo" "$3" "$FICHERO" "$SEPARADOR"
    echo "Registro modificado: "
    ./util.sh "buscar_linea" "$1" "$FICHERO"
}

eliminar_libro() {

    # Validar formato del ISBN
    v_isbn=$(./util.sh "validar_isbn" "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Verificar que el libro exista
    existe=$(./util.sh "buscar_linea" "$1" "$FICHERO")
    if ! [ -n "$existe" ]; then
        echo "Error: No existe un libro con ISBN '$1'."
        return
    fi

    echo "Se borrará el libro:"
    l=$(./util.sh "buscar_linea" "$1" "$FICHERO")
    echo "$l"
    ./util.sh "borrar_linea" "$l" "$FICHERO"
    echo "Libro eliminado"
}


# Selección de operación
case $1 in
    rl) # registrar libro
        registrar_libro "$2" "$3" "$4"
        ;;
    bl) # buscar libro
        buscar_libro "$2"
        ;;
    ml) # modificar libro
        modificar_libro "$2" "$3" "$4"
        ;;
    el) # eliminar libro
        eliminar_libro "$2"
        ;;
    *)
        echo "Operación no reconocida. Uso: $0 {add|list|search|delete} [args]"
        ;;
esac