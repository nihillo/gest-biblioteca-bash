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
        echo "1. Registrar libro"
        echo "2. Buscar libro"
        echo "3. Modificar libro"
        echo "4. Eliminar libro"
        echo "5. Salir"
        echo "===================="
        read -p "Seleccione una opción: " opcion

        case $opcion in
            1)
                read -p "ISBN: " isbn
                read -p "Título del libro: " titulo
                read -p "Autor del libro: " autor
                echo $autor
                ./libros.sh "rl" "$isbn" "$titulo" "$autor"
                ;;
            2) 
                read -p "Término de búsqueda (ISBN, título o autor): " termino
                ./libros.sh "bl" "$termino"
                ;;
            3)
                read -p "ISBN del libro a modificar: " isbn_mod
                read -p "Campo a modificar (titulo/autor): " campo
                read -p "Nuevo valor: " nuevo_valor
                ./libros.sh "ml" "$isbn_mod" "$campo" "$nuevo_valor"
                ;;
            4)
                read -p "ISBN del libro a eliminar: " isbn_elim
                ./libros.sh "el" "$isbn_elim"
                ;;
            5)
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