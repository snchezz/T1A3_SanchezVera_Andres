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
# zip -r copia_usuarios_$(date +%d%m%Y)_$(date +%H:%M:%S).zip .

prueba=$(test copia_usuarios_06112022_14:10:32.zip -ot copia_usuarios_06112022_14:13:48.zip)

if [ "copia_usuarios_06112022_14:10:32.zip" -ot "copia_usuarios_06112022_14:10:.zip" ]; then
    echo "Copia 1 es mayor"
else
    echo "Copia 2 es mayor"
fi
