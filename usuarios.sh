#!/bin/bash

FICHERO="usuarios.csv"
SEPARADOR="|"

# Funciones de gestión de usuarios
registrar_usuario() {
    ./util.sh "añadir_linea" "$1""$SEPARADOR""$2" "$FICHERO"
    echo "Usuario registrado: "$1 $2
}

buscar_usuario() {
    echo "Resultados de la búsqueda para '$1':"
    printf "\n"
    # Crear un archivo temporal para formatear la salida
    printf "NIF"$SEPARADOR"Nombre\n" >> salida-temp.txt
    printf "========="$SEPARADOR"==========\n" >> salida-temp.txt
    ./util.sh "buscar_linea" "$1" "$FICHERO" >> salida-temp.txt
    # Salida formateada en columnas
    column -t -s{$SEPARADOR} salida-temp.txt
    # Se elimina el archivo temporal
    rm salida-temp.txt
}

modificar_usuario() {
        case $2 in
        nif)
            campo=1
            ;;
        nombre)
            campo=2
            ;;
        *)
            echo "Campo no reconocido. Use 'nif' o 'nombre'."
            return
            ;;
    esac

    echo "Modificando datos de usuario"
    echo "Registro actual: "
    ./util.sh "buscar_linea" "$1" "$FICHERO"
    ./util.sh "modificar_linea" "$1" "$campo" "$3" "$FICHERO" "$SEPARADOR"
    

    if [ "$campo" -eq 1 ]; then
        nif="$3"
    else
        nif="$1"
    fi
    echo "Registro modificado: "
    ./util.sh "buscar_linea" "$nif" "$FICHERO"
}

eliminar_usuario() {
    echo "Se borrará el usuario:" $1
    u=$(./util.sh "buscar_linea" "$1" "$FICHERO")
    echo "$u"
    ./util.sh "borrar_linea" "$u" "$FICHERO"
    echo "Usuario eliminado"
}

case $1 in
    ru) # registrar usuario
        registrar_usuario "$2" "$3" "$4"
        ;;
    bu) # buscar usuario
        buscar_usuario "$2"
        ;;
    mu) # modificar usuario
        modificar_usuario "$2" "$3" "$4"
        ;;
    eu) # eliminar usuario
        eliminar_usuario "$2"
        ;;
    *)
        echo "Operación no reconocida. Uso: $0 {add|list|search|delete} [args]"
        ;;
esac