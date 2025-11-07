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
        'BEGIN {FS=OFS=","} $1 == id {$col = valor} 1' "$4" > tmp.csv && mv tmp.csv "$4"
}

borrar_linea () {
    sed -i "/$1/d" "$2"
}

# Funciones de gestión de libros
registrar_libro() {
    añadir_linea "$1,$2,$3" "libros.csv"
    echo "Libro registrado: "$2 $3 $4
}

buscar_libro() {
    echo "Resultados de la búsqueda para '$1':"
    printf "\n"
    # Crear un archivo temporal para formatear la salida
    printf "=========,==========,==========\n" >> salida-temp.txt
    printf "ISBN,Título,Autor\n" >> salida-temp.txt
    printf "=========,==========,==========\n" >> salida-temp.txt
    buscar_linea "$1" "libros.csv" >> salida-temp.txt
    column -t -s, salida-temp.txt
    # Se elimina el archivo temporal
    rm salida-temp.txt
}

modificar_libro() {
    case $2 in
        titulo)
            campo=2
            ;;
        autor)
            campo=3
            ;;
        *)
            echo "Campo no reconocido. Use 'titulo' o 'autor'."
            return
            ;;
    esac

    echo "Modificando el libro"
    echo "Registro actual: "
    buscar_linea "$1" "libros.csv"
    modificar_linea "$1" "$campo" "$3" "libros.csv"
    echo "Registro modificado: "
    buscar_linea "$1" "libros.csv"
}

eliminar_libro() {
    echo "Se borrará el libro:"
    l=$(buscar_linea "$1" "libros.csv")
    echo "$l"
    borrar_linea "$l" "libros.csv"
    echo "Libro eliminado"
}



# Funciones de gestión de usuarios


# Funciones de gestión de préstamos


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
        *)
            echo "Operación no reconocida. Uso: $0 {add|list|search|delete} [args]"
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
                registrar_libro "$isbn" "$titulo" "$autor"
                ;;
            2) 
                read -p "Término de búsqueda (ISBN, título o autor): " termino
                buscar_libro "$termino"
                ;;
            3)
                read -p "ISBN del libro a modificar: " isbn_mod
                read -p "Campo a modificar (titulo/autor): " campo
                read -p "Nuevo valor: " nuevo_valor
                modificar_libro "$isbn_mod" "$campo" "$nuevo_valor"
                ;;
            4)
                read -p "ISBN del libro a eliminar: " isbn_elim
                eliminar_libro "$isbn_elim"
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