#!/bin/bash

añadir_linea() {
    printf "$1\n" >> $2
}

buscar_linea() {
    grep -i "$1" $2
}

modificar_linea() {
    awk \
        -v id="$1" \
        -v col="$2" \
        -v valor="$3" \
        'BEGIN {FS=OFS="'$5'"} $1 == id {$col = valor} 1' "$4" > tmp.csv && mv tmp.csv "$4"
}

borrar_linea () {
    sed -i "/$1/d" "$2"
}


case $1 in
    añadir_linea)
        añadir_linea "$2" "$3"
        ;;
    buscar_linea)
        buscar_linea "$2" "$3"
        ;;
    modificar_linea)
        modificar_linea "$2" "$3" "$4" "$5" "$6"
        ;;
    borrar_linea)
        borrar_linea "$2" "$3"
        ;;
    *)
        echo "Función no reconocida"
        ;;
esac