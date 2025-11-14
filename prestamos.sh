#!/bin/bash

FICHERO="prestamos.csv"
SEPARADOR="|"

# Funciones de gestión de préstamos
registrar_prestamo() {
    # Implementar la lógica para registrar un préstamo
    echo "Función registrar_prestamo no implementada aún."
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

# Selección de operación
case $1 in
    rp) # registrar préstamo
        registrar_prestamo "$2" "$3" "$4"
        ;;
    dp) # registrar devolución de préstamo
        registrar_devolucion "$2" "$3"
        ;;
    lp) # listar todos los libros actualmente en préstamo
        listar_prestamos
        ;;
    up) # listar libros prestados a un usuario
        listar_prestamos_usuario "$2"
        ;;
    cp) # consulta de préstamo de un libro (estado de préstamo, y a quién)
        consultar_prestamo_libro "$2"
        ;;
    sp) # estadísticas de préstamos
        estadisticas_prestamos
        ;;
    *)
        echo "Operación '$1' no reconocida en gestión de préstamos."
        ;;
esac
    