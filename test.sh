#!/bin/bash
set -euo pipefail
clear

#### LIBROS ####
echo "#### PRUEBAS DE LIBROS ####" && echo "------"
# Registrar libro
echo "Registrar libro con ISBN no válido" && ./main.sh rl 1234 Titulo Autor && echo "------"
echo "Registrar libro ya registrado" && ./main.sh rl 978-0261103207 && echo "------"
echo "Registrar libro con caracteres incorrectos en título" && ./main.sh rl 123-0261103207 "La importancia del carácter |" "Autor Prueba" && echo "------"
echo "Registrar libro con título vacío" && ./main.sh rl 123-0261103207 "" "Autor Prueba" && echo "------"
echo "Registrar libro con caracteres incorrectos en autor" && ./main.sh rl 123-0261103207 "Título del libro" "Autor | Prueba" && echo "------"
echo "Registrar libro con autor vacío" && ./main.sh rl 123-0261103207 "Título del libro" "" && echo "------"
echo "Registrar libro válido" && ./main.sh rl 123-0261103207 "Título del libro" "Autor Prueba" && grep -i 123-0261103207 libros.csv && echo "------"

# Buscar libro
echo "Buscar libro existente" && ./main.sh bl 123-0261103207 && echo "------"

# Modificar libro
echo "Modificar libro con ISBN no válido" && ./main.sh ml 1234 titulo "Nuevo Título" && echo "------"
echo "Modificar libro inexistente" && ./main.sh ml 999-9999999999 titulo "Nuevo Título" && echo "------"
echo "Modificar libro con caracteres incorrectos en título" && ./main.sh ml 123-0261103207 titulo "Nuevo | Título" && echo "------"
echo "Modificar libro con título vacío" && ./main.sh ml 123-0261103207 titulo "" && echo "------"
echo "Modificar libro con caracteres incorrectos en autor" && ./main.sh ml 123-0261103207 autor "Nuevo | Autor" && echo "------"
echo "Modificar libro con autor vacío" && ./main.sh ml 123-0261103207 autor "" && echo "------"
echo "Modificar libro válido" && ./main.sh ml 123-0261103207 titulo "Nuevo Título" && grep -i 123-0261103207 libros.csv && echo "------"

# Eliminar libro
echo "Eliminar libro con ISBN no válido" && ./main.sh el 1234 && echo "------"
echo "Eliminar libro inexistente" && ./main.sh el 999-9999999999 && echo "------"
echo "Eliminar libro existente" && ./main.sh el 123-0261103207 && grep -i 123-0261103207 libros.csv || echo "Libro eliminado correctamente" && echo "------"

echo "Estado del fichero libros.csv tras las pruebas:"
cat libros.csv
echo "-----------------------------------------------"  

#### USUARIOS ####
echo "#### PRUEBAS DE USUARIOS ####" && echo "------"
# Registrar usuario
echo "Registrar usuario con documento no válido" && ./main.sh ru 1234 "Nombre Apellido" && echo "------"
echo "Registrar usuario ya registrado" && ./main.sh ru 12345678A && echo "------"
echo "Registrar usuario con caracteres incorrectos en nombre" && ./main.sh ru 12345678A "Nombre | Apellido" && echo "------"
echo "Registrar usuario con nombre vacío" && ./main.sh ru 12345678A "" && echo "------"
echo "Registrar usuario válido" && ./main.sh ru 12345678A "Nombre Apellido" && grep -i 12345678A usuarios.csv && echo "------"

# Buscar usuario
echo "Buscar usuario existente" && ./main.sh bu 12345678A && echo "------"

# Modificar usuario
echo "Modificar usuario con documento no válido" && ./main.sh mu 1234 nombre "Nuevo Nombre" && echo "------"
echo "Modificar usuario inexistente" && ./main.sh mu 87654321B nombre "Nuevo Nombre" && echo "------"
echo "Modificar nombre de usuario con caracteres incorrectos en nombre" && ./main.sh mu 12345678A nombre "Nuevo | Nombre" && echo "------"
echo "Modificar nombre de usuario con nombre vacío" && ./main.sh mu 12345678A nombre "" && echo "------"
echo "Modificar nombre de usuario válido" && ./main.sh mu 12345678A nombre "Nuevo Nombre" && grep -i 12345678A usuarios.csv && echo "------"
echo "Modificar documento de usuario con nuevo documento no válido" && ./main.sh mu 12345678A nif 1234 && echo "------"
echo "Modificar documento de usuario con nuevo documento válido" && ./main.sh mu 12345678A nif 87654321B && grep -i 87654321B usuarios.csv && echo "------"

# Eliminar usuario
echo "Eliminar usuario con documento no válido" && ./main.sh eu 1234 && echo "------"
echo "Eliminar usuario inexistente" && ./main.sh eu 99999999Z && echo "------"
echo "Eliminar usuario existente" && ./main.sh eu 87654321B && grep -i 87654321B usuarios.csv || echo "Usuario eliminado correctamente" && echo "------"

echo "Estado del fichero usuarios.csv tras las pruebas:"
cat usuarios.csv
echo "-----------------------------------------------"

#### PRÉSTAMOS ####
echo "#### PRUEBAS DE PRÉSTAMOS ####" && echo "------"

# Registrar préstamo
echo "Registrar préstamo con ISBN no válido" && ./main.sh rp 1234 12345678A 2025-11-10 && echo "------"
echo "Registrar préstamo con documento no válido" && ./main.sh rp 978-0261103207 1234 2025-11-10 && echo "------"
echo "Registrar préstamo con libro inexistente" && ./main.sh rp 999-9999999999 12345678A 2025-11-10 && echo "------"
echo "Registrar préstamo con usuario inexistente" && ./main.sh rp 978-0261103207 99999999Z 2025-11-10 && echo "------"
echo "Registrar préstamo con fecha de préstamo no válida" && ./main.sh rp 978-8497594257 12345678A 2024-13-01 && echo "------"
echo "Registrar préstamo válido" && ./main.sh rp 978-8497594257 23456789G 2025-11-10 && grep -i 978-8497594257 prestamos.csv && echo "------"
