#!/bin/bash

# Andrés Sánchez

# Exit code 0: Todo ha funcionado correctamente.

# Comprobar si el fichero existe
if [ -f usuarios.csv ]; then
    echo "El fichero existe"
else
    echo "Fichero usuarios.csv creado el $(date +%d-%m-%Y) a las $(date +%H:%M:%S)" >>usuarios.csv
    echo "" >>usuarios.csv
    echo "Nombre:1erApellido:2oApellido:DNI:NombreUser" >>usuarios.csv
fi

# Se crea la copia de seguridad de la carpeta donde se encuentra el script
zip -r copia_usuarios_$(date +%d%m%Y)_$(date +%H:%M:%S).zip .

# Se hace una busqueda para que solo hayan 2 copias de seguridad
busqueda=$(find . -name "*zip" | wc -l)
if [[ $busqueda > "2" ]]; then
    # Se borra el mas antiguo, buscando archivos zip
    antugio=$(find . -name "*zip" | sort | head -n 1)
    rm $antugio
fi


