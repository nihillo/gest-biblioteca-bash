#!/bin/bash
source ./config.sh
source ./util.sh

verificar_no_existe_usuario() {
    # Verificar que el usuario no exista ya
    existe=$(buscar_linea "$1" "$F_USUARIOS")
    if [ -n "$existe" ]; then
        echo "Error: Ya existe un usuario con el NIF/NIE '$1'."
        return
    fi
}

verificar_existe_usuario() {
    # Verificar que el usuario exista
    existe=$(buscar_linea "$1" "$F_USUARIOS")
    if ! [ -n "$existe" ]; then
        echo "Error: No existe un usuario con NIF/NIE '$1'."
        return
    fi
}

# Funciones de gestión de usuarios
registrar_usuario() {
    # Validaciones
    v_doc=$(validar_documento "$1")
    v_no_existe=$(verificar_no_existe_usuario "$1")
    v_nombre=$(validar_texto "$2" "nombre")
    
    for v in "$v_doc" "$v_no_existe" "$v_nombre"; do
        if [ -n "$v" ]; then
            echo $v
            return
        fi
    done

    # Registrar usuario
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
    # Validaciones
    v_doc=$(validar_documento "$1")    
    v_existe_usuario=$(verificar_existe_usuario "$1")

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
    else
        v_nuevo=$(validar_texto "$3" "nombre")
    fi

    for v in "$v_doc" "$v_existe_usuario" "$v_nuevo"; do
        if [ -n "$v" ]; then
            echo $v
            return
        fi
    done

    # Realizar la modificación
    echo "Modificando datos de usuario"
    echo "Registro actual: "
    buscar_linea "$1" "$F_USUARIOS"
    modificar_linea "$1" "$campo" "$3" "$F_USUARIOS" "$SEPARADOR"
    
    # Mostrar el registro modificado
    if [ "$campo" -eq 1 ]; then
        doc_busqueda="$3"
    else
        doc_busqueda="$1"
    fi
    echo "Registro modificado: "
    buscar_linea "$doc_busqueda" "$F_USUARIOS"
}

eliminar_usuario() {
    # Validaciones
    v_doc=$(validar_documento "$1")
    v_existe_usuario=$(verificar_existe_usuario "$1")

    for v in "$v_doc" "$v_existe_usuario"; do
        if [ -n "$v" ]; then
            echo $v
            return
        fi
    done

    # Eliminar usuario
    echo "Se borrará el usuario:" $1
    u=$(buscar_linea "$1" "$F_USUARIOS")
    echo "$u"
    borrar_linea "$u" "$F_USUARIOS"
    echo "Usuario eliminado"
}