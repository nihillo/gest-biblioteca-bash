#!/bin/bash
source ./libros.sh
source ./usuarios.sh
source ./prestamos.sh


mostrar_ayuda() {
    echo "Uso: $0 [comando] [args]"
    echo "Comandos:"
    echo "  rl [ISBN] [Título] [Autor]     - Registrar libro"
    echo "  bl [Término]                   - Buscar libro"
    echo "  ml [ISBN] [campo] [nuevo_valor] - Modificar libro"
    echo "  el [ISBN]                      - Eliminar libro"
}


# Lectura de entrada.
# Si se pasan argumentos, ejecutar la operación correspondiente,
# en caso contrario, iniciar el loop de menú
if [ $# -gt 0 ]; then
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
        ru) # registrar usuario
            registrar_usuario "$2" "$3"
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
        h) # ayuda
            mostrar_ayuda
            ;;
        *)
            echo "Operación no reconocida"
            mostrar_ayuda
            ;;
    esac
else
    while true; do
        clear
        echo "Gestión de Biblioteca"
        echo "===================="
        echo "COD - OPERACIÓN"
        echo "--------------------"
        echo "rl  - Registrar libro"
        echo "bl  - Buscar libro"
        echo "ml  - Modificar libro"
        echo "el  - Eliminar libro"
        echo "--------------------"
        echo "ru  - Registrar usuario"
        echo "bu  - Buscar usuario"
        echo "mu  - Modificar usuario"
        echo "eu  - Eliminar usuario"
        echo "--------------------"
        echo "rp  - Registrar préstamo"
        echo "dp  - Registrar devolución de préstamo"
        echo "lp  - Listar libros en préstamo"
        echo "up  - Listar libros prestados a un usuario"
        echo "cp  - Consulta de estado de préstamo de un libro"
        echo "sp  - Estadísticas de préstamos"
        echo "--------------------"
        echo "s   - Salir"
        echo "===================="
        read -p "Seleccione una opción: " opcion

        case $opcion in
            rl)
                read -p "ISBN: " isbn
                read -p "Título del libro: " titulo
                read -p "Autor del libro: " autor
                echo $autor
                registrar_libro "$isbn" "$titulo" "$autor"
                ;;
            bl) 
                read -p "Término de búsqueda (ISBN, título o autor): " termino_lib
                buscar_libro "$termino_lib"
                ;;
            ml)
                read -p "ISBN del libro a modificar: " isbn_mod
                read -p "Campo a modificar (titulo/autor): " campo
                read -p "Nuevo valor: " nuevo_valor
                modificar_libro "$isbn_mod" "$campo" "$nuevo_valor"
                ;;
            el)
                read -p "ISBN del libro a eliminar: " isbn_elim
                eliminar_libro "$isbn_elim"
                ;;
            ru)
                read -p "NIF o NIE: " doc
                read -p "Nombre de usuario: " nombre
                registrar_usuario "$doc" "$nombre"
                ;;
            bu)
                read -p "Término de búsqueda (NIF/NIE o nombre): " termino_usr
                buscar_usuario "$termino_usr"
                ;;
            mu)
                read -p "NIF o NIE del usuario a modificar: " doc_mod
                read -p "Campo a modificar (nombre/nif/nie): " campo_usr
                read -p "Nuevo valor: " nuevo_valor_usr
                modificar_usuario "$doc_mod" "$campo_usr" "$nuevo_valor_usr"
                ;;
            eu)
                read -p "NIF o NIE del usuario a eliminar: " doc_elim
                eliminar_usuario "$doc_elim"
                ;;
            rp)
                read -p "ISBN del libro a prestar: " isbn_prestamo
                read -p "NIF o NIE del usuario: " doc_usuario
                read -p "Fecha de préstamo (YYYY-MM-DD): " fecha_prestamo
                registrar_prestamo "$isbn_prestamo" "$doc_usuario" "$fecha_prestamo"
                ;;
            dp)
                read -p "ISBN del libro a devolver: " isbn_devolucion
                read -p "Fecha de devolución (YYYY-MM-DD): " fecha_devolucion
                registrar_devolucion "$isbn_devolucion" "$fecha_devolucion"
                ;;
            lp)
                listar_prestamos
                ;;
            up) 
                read -p "NIF o NIE del usuario: " doc_usuario_up
                listar_prestamos_usuario "$doc_usuario_up"
                ;;
            cp)
                read -p "ISBN del libro: " isbn_consulta
                consultar_prestamo_libro "$isbn_consulta"
                ;;
            sp) 
                estadisticas_prestamos
                ;;
            s)
                echo "Saliendo..."
                exit 0
                ;;
            *)
                echo "Opción no válida."
                ;;
        esac

        read -p "Presione Enter para continuar..."
    done
fi