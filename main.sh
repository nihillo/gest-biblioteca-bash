#!/bin/bash

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
            ./libros.sh "rl" "$2" "$3" "$4"
            ;;
        bl) # buscar libro
            ./libros.sh "bl" "$2"
            ;;
        ml) # modificar libro
            ./libros.sh "ml" "$2" "$3" "$4"
            ;;
        el) # eliminar libro
            ./libros.sh "el" "$2"
            ;;
        ru) # registrar usuario
            ./usuarios.sh "ru" "$2" "$3"
            ;;
        bu) # buscar usuario
            ./usuarios.sh "bu" "$2"
            ;;
        mu) # modificar usuario
            ./usuarios.sh "mu" "$2" "$3" "$4"
            ;;
        eu) # eliminar usuario
            ./usuarios.sh "eu" "$2"
            ;;
        rp) # registrar préstamo
            ./prestamos.sh "rp" "$2" "$3" "$4"
            ;;
        dp) # registrar devolución de préstamo
            ./prestamos.sh "dp" "$2" "$3"
            ;;
        lp) # listar todos los libros actualmente en préstamo
            ./prestamos.sh "lp"
            ;;
        up) # listar libros prestados a un usuario
            ./prestamos.sh "up" "$2"
            ;;
        cp) # consulta de préstamo de un libro (estado de préstamo, y a quién)
            ./prestamos.sh "tp" "$2"
            ;;
        sp) # estadísticas de préstamos
            ./prestamos.sh "sp"
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
        echo "s   - Salir"
        echo "===================="
        read -p "Seleccione una opción: " opcion

        case $opcion in
            rl)
                read -p "ISBN: " isbn
                read -p "Título del libro: " titulo
                read -p "Autor del libro: " autor
                echo $autor
                ./libros.sh "rl" "$isbn" "$titulo" "$autor"
                ;;
            bl) 
                read -p "Término de búsqueda (ISBN, título o autor): " termino_lib
                ./libros.sh "bl" "$termino_lib"
                ;;
            ml)
                read -p "ISBN del libro a modificar: " isbn_mod
                read -p "Campo a modificar (titulo/autor): " campo
                read -p "Nuevo valor: " nuevo_valor
                ./libros.sh "ml" "$isbn_mod" "$campo" "$nuevo_valor"
                ;;
            el)
                read -p "ISBN del libro a eliminar: " isbn_elim
                ./libros.sh "el" "$isbn_elim"
                ;;
            ru)
                read -p "NIF o NIE: " doc
                read -p "Nombre de usuario: " nombre
                ./usuarios.sh "ru" "$doc" "$nombre"
                ;;
            bu)
                read -p "Término de búsqueda (NIF/NIE o nombre): " termino_usr
                ./usuarios.sh "bu" "$termino_usr"
                ;;
            mu)
                read -p "NIF o NIE del usuario a modificar: " doc_mod
                read -p "Campo a modificar (nombre/nif/nie): " campo_usr
                read -p "Nuevo valor: " nuevo_valor_usr
                ./usuarios.sh "mu" "$doc_mod" "$campo_usr" "$nuevo_valor_usr"
                ;;
            eu)
                read -p "NIF o NIE del usuario a eliminar: " doc_elim
                ./usuarios.sh "eu" "$doc_elim"
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