#!/bin/bash

# Funciones de gestión de archivos CSV
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


# Funciones de validación
validar_isbn() {
    isbn="$1"
    # Validar que el ISBN tenga 13 dígitos (formato ISBN-13)
    if ! [[ "$isbn" =~ ^[0-9]{3}\-[0-9]{10}$ ]]; then
        echo "Error: El ISBN '$isbn' no tiene un formato válido. Debe ser 'XXX-XXXXXXXXXX' donde X es un dígito."
    fi
    return
}

validar_texto() {
    texto="$1"
    campo="$2"
    # Validar que el título no esté vacío y no contenga caracteres no permitidos
    if [[ -z "$texto" || "$texto" =~ [\|] ]]; then
        echo "Error: El $campo '$texto' no es válido. No debe estar vacío y no debe contener el carácter '|'."
    fi
    return
}

validar_documento() {
    doc="$1"
    # Validar formato del NIF/NIE (simplificado)
    if ! [[ "$doc" =~ ^[0-9]{8}[A-Za-z]$ || "$doc" =~ ^[XYZ][0-9]{7}[A-Za-z]$ ]]; then
        echo "Error: El documento '$doc' no tiene un formato válido de NIF o NIE."
    fi
    return
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
    validar_isbn)
        validar_isbn "$2"
        ;;
    validar_texto)
        validar_texto "$2" "$3"
        ;;
    validar_documento)
        validar_documento "$2"
        ;;
    *)
        echo "Función '$1' no reconocida"
        ;;
esac