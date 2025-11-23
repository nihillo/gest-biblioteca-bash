#!/bin/bash
set -euo pipefail
clear

# guardar copia de seguridad de los ficheros originales
cp libros.csv libros_backup.csv
cp usuarios.csv usuarios_backup.csv
cp prestamos.csv prestamos_backup.csv

#### LIBROS ####
echo "#### PRUEBAS DE LIBROS ####" && echo "------"
# Registrar libro
echo "LR01 - Registrar libro con ISBN no válido" && echo "> ./main.sh rl 1234 Titulo Autor" && ./main.sh rl 1234 Titulo Autor && echo "------"
echo "LR02 - Registrar libro con caracteres incorrectos en título" && echo "> ./main.sh rl 123-0261103207 \"La importancia del carácter |\" \"Autor Prueba\"" && ./main.sh rl 123-0261103207 "La importancia del carácter |" "Autor Prueba" && echo "------"
echo "LR03 - Registrar libro con título vacío" && echo "> ./main.sh rl 123-0261103207 \"\" \"Autor Prueba\"" && ./main.sh rl 123-0261103207 "" "Autor Prueba" && echo "------"
echo "LR04 - Registrar libro con caracteres incorrectos en autor" && echo "> ./main.sh rl 123-0261103207 \"Título del libro\" \"Autor | Prueba\"" && ./main.sh rl 123-0261103207 "Título del libro" "Autor | Prueba" && echo "------"
echo "LR05 - Registrar libro con autor vacío" && echo "> ./main.sh rl 123-0261103207 \"Título del libro\" \"\"" && ./main.sh rl 123-0261103207 "Título del libro" "" && echo "------"
echo "LR06 - Registrar libro ya registrado" && echo "> ./main.sh rl 978-0261103207 \"La comunidad del anillo\" \"J.R.R. Tolkien\"" && ./main.sh rl 978-0261103207 "La comunidad del anillo" "J.R.R. Tolkien" && echo "------"
echo "LR07 - Registrar libro válido" && echo "> ./main.sh rl 123-0261103207 \"Título del libro\" \"Autor Prueba\"" && ./main.sh rl 123-0261103207 "Título del libro" "Autor Prueba" && grep -i 123-0261103207 libros.csv && echo "------"

# Buscar libro
echo "LB01 - Buscar libro existente" && echo "> ./main.sh bl 123-0261103207" && ./main.sh bl 123-0261103207 && echo "------"

# Modificar libro
echo "LM01 - Modificar libro con ISBN no válido" && echo "> ./main.sh ml 1234 titulo \"Nuevo Título\"" && ./main.sh ml 1234 titulo "Nuevo Título" && echo "------"
echo "LM02 - Modificar libro inexistente" && echo "> ./main.sh ml 999-9999999999 titulo \"Nuevo Título\"" && ./main.sh ml 999-9999999999 titulo "Nuevo Título" && echo "------"
echo "LM03 - Modificar libro con caracteres incorrectos en título" && echo "> ./main.sh ml 123-0261103207 titulo \"Nuevo | Título\"" && ./main.sh ml 123-0261103207 titulo "Nuevo | Título" && echo "------"
echo "LM04 - Modificar libro con título vacío" && echo "> ./main.sh ml 123-0261103207 titulo \"\"" && ./main.sh ml 123-0261103207 titulo "" && echo "------"
echo "LM05 - Modificar libro con caracteres incorrectos en autor" && echo "> ./main.sh ml 123-0261103207 autor \"Nuevo | Autor\"" && ./main.sh ml 123-0261103207 autor "Nuevo | Autor" && echo "------"
echo "LM06 - Modificar libro con autor vacío" && echo "> ./main.sh ml 123-0261103207 autor \"\"" && ./main.sh ml 123-0261103207 autor "" && echo "------"
echo "LM07 - Modificar libro válido" && echo "> ./main.sh ml 123-0261103207 titulo \"Nuevo Título\"" && ./main.sh ml 123-0261103207 titulo "Nuevo Título" && grep -i 123-0261103207 libros.csv && echo "------"

# Eliminar libro
echo "LE01 - Eliminar libro con ISBN no válido" && echo "> ./main.sh el 1234" && ./main.sh el 1234 && echo "------"
echo "LE02 - Eliminar libro inexistente" && echo "> ./main.sh el 999-9999999999" && ./main.sh el 999-9999999999 && echo "------"
echo "LE03 - Eliminar libro existente" && echo "> ./main.sh el 123-0261103207" && ./main.sh el 123-0261103207 && grep -i 123-0261103207 libros.csv || echo "Libro eliminado correctamente" && echo "------"

echo "Estado del fichero libros.csv tras las pruebas:"
cat libros.csv
echo "-----------------------------------------------"  

#### USUARIOS ####
echo "#### PRUEBAS DE USUARIOS ####" && echo "------"
# Registrar usuario
echo "UR01 - Registrar usuario con documento no válido" && echo "> ./main.sh ru 1234 \"Nombre Apellido\"" && ./main.sh ru 1234 "Nombre Apellido" && echo "------"
echo "UR02 - Registrar usuario ya registrado" && echo "> ./main.sh ru 12345678A" && ./main.sh ru 12345678A && echo "------"
echo "UR03 - Registrar usuario con caracteres incorrectos en nombre" && echo "> ./main.sh ru 12345678A \"Nombre | Apellido\"" && ./main.sh ru 12345678A "Nombre | Apellido" && echo "------"
echo "UR04 - Registrar usuario con nombre vacío" && echo "> ./main.sh ru 12345678A \"\"" && ./main.sh ru 12345678A "" && echo "------"
echo "UR05 - Registrar usuario válido" && echo "> ./main.sh ru 12345678A \"Nombre Apellido\"" && ./main.sh ru 12345678A "Nombre Apellido" && grep -i 12345678A usuarios.csv && echo "------"

# Buscar usuario
echo "UB01 - Buscar usuario existente" && echo "> ./main.sh bu 12345678A" && ./main.sh bu 12345678A && echo "------"

# Modificar usuario
echo "UM01 - Modificar usuario con documento no válido" && echo "> ./main.sh mu 1234 nombre \"Nuevo Nombre\"" && ./main.sh mu 1234 nombre "Nuevo Nombre" && echo "------"
echo "UM02 - Modificar usuario inexistente" && echo "> ./main.sh mu 87654321B nombre \"Nuevo Nombre\"" && ./main.sh mu 87654321B nombre "Nuevo Nombre" && echo "------"
echo "UM03 - Modificar nombre de usuario con caracteres incorrectos en nombre" && echo "> ./main.sh mu 12345678A nombre \"Nuevo | Nombre\"" && ./main.sh mu 12345678A nombre "Nuevo | Nombre" && echo "------"
echo "UM04 - Modificar nombre de usuario con nombre vacío" && echo "> ./main.sh mu 12345678A nombre \"\"" && ./main.sh mu 12345678A nombre "" && echo "------"
echo "UM05 - Modificar nombre de usuario válido" && echo "> ./main.sh mu 12345678A nombre \"Nuevo Nombre\"" && ./main.sh mu 12345678A nombre "Nuevo Nombre" && grep -i 12345678A usuarios.csv && echo "------"
echo "UM06 - Modificar documento de usuario con nuevo documento no válido" && echo "> ./main.sh mu 12345678A nif 1234" && ./main.sh mu 12345678A nif 1234 && echo "------"
echo "UM07 - Modificar documento de usuario con nuevo documento válido" && echo "> ./main.sh mu 12345678A nif 87654321B" && ./main.sh mu 12345678A nif 87654321B && grep -i 87654321B usuarios.csv && echo "------"

# Eliminar usuario
echo "UE01 - Eliminar usuario con documento no válido" && echo "> ./main.sh eu 1234" && ./main.sh eu 1234 && echo "------"
echo "UE02 - Eliminar usuario inexistente" && echo "> ./main.sh eu 99999999Z" && ./main.sh eu 99999999Z && echo "------"
echo "UE03 - Eliminar usuario existente" && echo "> ./main.sh eu 87654321B" && ./main.sh eu 87654321B && grep -i 87654321B usuarios.csv || echo "Usuario eliminado correctamente" && echo "------"

echo "Estado del fichero usuarios.csv tras las pruebas:"
cat usuarios.csv
echo "-----------------------------------------------"

#### PRÉSTAMOS ####
echo "#### PRUEBAS DE PRÉSTAMOS ####" && echo "------"

# Registrar préstamo
echo "PR01 - Registrar préstamo con ISBN no válido" && echo "> ./main.sh rp 1234 12345678A 2025-11-10" && ./main.sh rp 1234 12345678A 2025-11-10 && echo "------"
echo "PR02 - Registrar préstamo con documento no válido" && echo "> ./main.sh rp 978-0261103207 1234 2025-11-10" && ./main.sh rp 978-0261103207 1234 2025-11-10 && echo "------"
echo "PR03 - Registrar préstamo con libro inexistente" && echo "> ./main.sh rp 999-9999999999 12345678A 2025-11-10" && ./main.sh rp 999-9999999999 12345678A 2025-11-10 && echo "------"
echo "PR04 - Registrar préstamo con usuario inexistente" && echo "> ./main.sh rp 978-0261103207 99999999Z 2025-11-10" && ./main.sh rp 978-0261103207 99999999Z 2025-11-10 && echo "------"
echo "PR05 - Registrar préstamo con fecha de préstamo no válida" && echo "> ./main.sh rp 978-8497594257 12345678A 2024-13-01" && ./main.sh rp 978-8497594257 12345678A 2024-13-01 && echo "------"
echo "PR06 - Registrar préstamo de libro actualmente prestado" && echo "> ./main.sh rp 978-8483462034 11223344L 2025-09-15" && ./main.sh rp 978-8483462034 11223344L 2025-09-15 && echo "------"
echo "PR07 - Registrar préstamo válido" && echo "> ./main.sh rp 978-8497594257 23456789G 2025-11-10" && ./main.sh rp 978-8497594257 23456789G 2025-11-10 && grep -i 978-8497594257 prestamos.csv && echo "------"
echo "PR08 - Registrar préstamo de libro prestado en el pasado pero ya devuelto" && echo "> ./main.sh rp 978-8420674209 40506070M 2025-11-16" && ./main.sh rp 978-8420674209 40506070M 2025-11-16 && grep -i 978-8420674209 prestamos.csv && echo "------"
echo "PR09 - Registrar préstamo de libro actualmente prestado y que ya ha tenido un préstamo anterior ya devuelto" && echo "> ./main.sh rp 978-0061120084 87234567H 2025-11-16" && ./main.sh rp 978-0061120084 87234567H 2025-11-16 && echo "------"

# Registrar devolución
echo "PD01 - Registrar devolución con ISBN no válido" && echo "> ./main.sh dp 1234 2025-12-01" && ./main.sh dp 1234 2025-12-01 && echo "------"
echo "PD02 - Registrar devolución con fecha no válida" && echo "> ./main.sh dp 978-8497594257 2025-13-01" && ./main.sh dp 978-8497594257 2025-13-01 && echo "------"
echo "PD03 - Registrar devolución de libro no prestado" && echo "> ./main.sh dp 978-0261103207 2025-12-01" && ./main.sh dp 978-0261103207 2025-12-01 && echo "------"
echo "PD04 - Registrar devolución de libro ya devuelto" && echo "> ./main.sh dp 978-8420674209 2025-12-01" && ./main.sh dp 978-8420674209 2025-12-01 && echo "------"
echo "PD05 - Registrar devolución válida" && echo "> ./main.sh dp 978-8483462034 2025-12-01" && ./main.sh dp 978-8483462034 2025-12-01 && grep -i 978-8483462034 prestamos.csv && echo "------"

# Listar préstamos
echo "PL01 - Listar todos los préstamos activos" && echo "> ./main.sh lp" && ./main.sh lp && echo "------"

# Listar libros que tiene un usuario en préstamo
echo "PU01 - Listar préstamos de un usuario con documento no válido" && echo "> ./main.sh up 1234" && ./main.sh up 1234 && echo "------"
echo "PU02 - Listar préstamos de un usuario inexistente" && echo "> ./main.sh up 99999999Z" && ./main.sh up 99999999Z && echo "------"
echo "PU03 - Listar préstamos de un usuario sin préstamos activos" && echo "> ./main.sh up 70809010P" && ./main.sh up 70809010P && echo "------"
echo "PU04 - Listar préstamos de un usuario con préstamos activos" && echo "> ./main.sh up 23456789G" && ./main.sh up 23456789G && echo "------"

# Consulta de estado de préstamo de un libro
echo "PC01 - Consulta de estado de préstamo con ISBN no válido" && echo "> ./main.sh cp 1234" && ./main.sh cp 1234 && echo "------"
echo "PC02 - Consulta de estado de préstamo de libro inexistente" && echo "> ./main.sh cp 999-9999999999" && ./main.sh cp 999-9999999999 && echo "------"
echo "PC03 - Consulta de estado de préstamo de libro no prestado" && echo "> ./main.sh cp 978-0261103207" && ./main.sh cp 978-0261103207 && echo "------"
echo "PC04 - Consulta de estado de préstamo de libro prestado" && echo "> ./main.sh cp 978-0061120084" && ./main.sh cp 978-0061120084 && echo "------"

# Mostrar estado final del fichero de préstamos
echo "Estado del fichero prestamos.csv tras las pruebas:"
cat prestamos.csv
echo "-----------------------------------------------"

# Estadisticas de préstamos
echo "PS01 - Estadísticas de préstamos" && echo "> ./main.sh sp" && ./main.sh sp && echo "------"

# Restaurar los ficheros originales
mv libros_backup.csv libros.csv
mv usuarios_backup.csv usuarios.csv
mv prestamos_backup.csv prestamos.csv