#!/bin/bash
source ./config.sh
source ./util.sh

# Funciones de gestión de usuarios
registrar_usuario() {
    # Validaciones
    # Validar formato del NIF/NIE
    v_doc=$(validar_documento "$1")
    if [ -n "$v_doc" ]; then
        echo $v_doc
        return
    fi

    # Verificar que el usuario no exista ya
    existe=$(buscar_linea "$1" "$F_USUARIOS")
    if [ -n "$existe" ]; then
        echo "Error: Ya existe un usuario con el NIF/NIE '$1'."
        return
    fi

    # Validar texto del nombre
    v_nombre=$(validar_texto "$2" "nombre")
    if [ -n "$v_nombre" ]; then
        echo $v_nombre
        return
    fi

    añadir_linea "$1""$SEPARADOR""$2" "$F_USUARIOS"
    echo "Usuario registrado: "$1 $2
}

buscar_usuario() {
    echo "Resultados de la búsqueda para '$1':"
    printf "\n"
    # Crear un archivo temporal para formatear la salida
    printf "NIF"$SEPARADOR"Nombre\n" >> salida-temp.txt
    printf "========="$SEPARADOR"==========\n" >> salida-temp.txt
    buscar_linea "$1" "$F_USUARIOS" >> salida-temp.txt
    # Salida formateada en columnas
    column -t -s{$SEPARADOR} salida-temp.txt
    # Se elimina el archivo temporal
    rm salida-temp.txt
}

modificar_usuario() {    
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

    # Determinar el campo a modificar

    case $2 in
        nif)
            campo=1
            ;;
        nie)
            campo=1
            ;;
        nombre)
            campo=2
            ;;
        *)
            echo "Campo no reconocido. Use 'nif', 'nie' o 'nombre'."
            return
            ;;
    esac

    # Validar campo a modificar
    if [ "$campo" -eq 1 ]; then
        v_nuevo=$(validar_documento "$3")
        if [ -n "$v_nuevo" ]; then
            echo $v_nuevo
            return
        fi
    else
        v_nuevo=$(validar_texto "$3" "nombre")
        if [ -n "$v_nuevo" ]; then
            echo $v_nuevo
            return
        fi
    fi


    # Realizar la modificación
    echo "Modificando datos de usuario"
    echo "Registro actual: "
    buscar_linea "$1" "$F_USUARIOS"
    modificar_linea "$1" "$campo" "$3" "$F_USUARIOS" "$SEPARADOR"
    

    if [ "$campo" -eq 1 ]; then
        nif="$3"
    else
        nif="$1"
    fi
    echo "Registro modificado: "
    buscar_linea "$nif" "$F_USUARIOS"
}

eliminar_usuario() {
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

    echo "Se borrará el usuario:" $1
    u=$(buscar_linea "$1" "$F_USUARIOS")
    echo "$u"
    borrar_linea "$u" "$F_USUARIOS"
    echo "Usuario eliminado"
}