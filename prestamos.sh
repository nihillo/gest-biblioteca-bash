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

    # Validar formato de la fecha
    v_fecha=$(validar_fecha "$4")
    if [ -n "$v_fecha" ]; then
        echo $v_fecha
        return
    fi
}

registrar_devolucion() {
    # Implementar la lógica para registrar una devolución
    echo "Función registrar_devolucion no implementada aún."
}

listar_prestamos() {
    # Implementar la lógica para listar todos los libros en préstamo
    echo "Función listar_prestamos no implementada aún."
}

listar_prestamos_usuario() {
    # Implementar la lógica para listar libros prestados a un usuario
    echo "Función listar_prestamos_usuario no implementada aún."
}

consultar_prestamo_libro() {
    # Implementar la lógica para consultar el estado de préstamo de un libro
    echo "Función consultar_prestamo_libro no implementada aún."
}

estadisticas_prestamos() {
    # Implementar la lógica para mostrar estadísticas de préstamos
    echo "Función estadisticas_prestamos no implementada aún."
}    