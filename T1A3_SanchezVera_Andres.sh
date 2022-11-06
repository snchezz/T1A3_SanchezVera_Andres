#!/bin/bash

# Andrés Sánchez

# Exit code 0: Todo ha funcionado correctamente.
if [ -f usuarios.csv ]; then
    echo "El fichero existe"
else
    echo "Fichero usuarios.csv creado el $(date +%d-%m-%Y) a las $(date +%H:%M:%S)" >>usuarios.csv
    echo "" >>usuarios.csv
    echo "Nombre:1erApellido:2oApellido:DNI:NombreUser" >>usuarios.csv
fi

# Copia seguridad

if [ "copia_usuarios_06112022_15:07:54.zip" -ot "copia_usuarios_06112022_15:09:06.zip" ]; then
    echo "Copia 1 es mayor"

else
    echo "Copia 2 es mayor"
fi

busqueda=$(find . -name "*zip" | wc -l)
if [[ $buesqueda > "2"]]; then
    echo "Hay mas de 2"
fi

# Se crea la copia de seguridad de la carpeta donde se encuentra el script
#zip -r copia_usuarios_$(date +%d%m%Y)_$(date +%H:%M:%S).zip .

# Se borra el mas antiguo, buscando archivos zip
#antugio=$(find . -name "*zip" | sort | head -n 1)
#rm $antugio
