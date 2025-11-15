#!/bin/bash
source ./config.sh
source ./util.sh

# Funciones de gestión de libros
registrar_libro() {

    # Validaciones
    # Validar formato del ISBN
    v_isbn=$(validar_isbn "$1")
    if [ -n "$v_isbn" ]; then
        echo $v_isbn
        return
    fi

    # Verificar que el libro no exista ya
    existe=$(buscar_linea "$1" "$F_LIBROS")
    if [ -n "$existe" ]; then
        echo "Error: Ya existe un libro con el ISBN '$1'."
        return
    fi    

    # Validar texto del título y autor
    v_titulo=$(validar_texto "$2" "título")
    if [ -n "$v_titulo" ]; then
        echo $v_titulo
        return
    fi

    v_autor=$(validar_texto "$3" "autor")
    if [ -n "$v_autor" ]; then
        echo $v_autor
        return
    fi

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
    v_texto=$(validar_texto "$3" "$2")
    if [ -n "$v_texto" ]; then
        echo $v_texto
        return
    fi

    echo "Modificando el libro"
    echo "Registro actual: "
    buscar_linea "$1" "$F_LIBROS"
    modificar_linea "$1" "$campo" "$3" "$F_LIBROS" "$SEPARADOR"
    echo "Registro modificado: "
    buscar_linea "$1" "$F_LIBROS"
}

eliminar_libro() {

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

    echo "Se borrará el libro:"
    l=$(buscar_linea "$1" "$F_LIBROS")
    echo "$l"
    borrar_linea "$l" "$F_LIBROS"
    echo "Libro eliminado"
}