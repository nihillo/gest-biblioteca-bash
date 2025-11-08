#!/bin/bash

FICHERO="libros.csv"
SEPARADOR="|"

# Funciones de gestión de libros
registrar_libro() {
    ./util.sh "añadir_linea" "$1""$SEPARADOR""$2""$SEPARADOR""$3" "$FICHERO"
    echo "Libro registrado: "$2 $3 $4
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
    case $2 in
        titulo)
            campo=2
            ;;
        autor)
            campo=3
            ;;
        *)
            echo "Campo no reconocido. Use 'titulo' o 'autor'."
            return
            ;;
    esac

    echo "Modificando el libro"
    echo "Registro actual: "
    ./util.sh "buscar_linea" "$1" "$FICHERO"
    ./util.sh "modificar_linea" "$1" "$campo" "$3" "$FICHERO" "$SEPARADOR"
    echo "Registro modificado: "
    ./util.sh "buscar_linea" "$1" "$FICHERO"
}

eliminar_libro() {
    echo "Se borrará el libro:"
    l=$(./util.sh "buscar_linea" "$1" "$FICHERO")
    echo "$l"
    ./util.sh "borrar_linea" "$l" "$FICHERO"
    echo "Libro eliminado"
}



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