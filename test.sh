#!/bin/bash

echo -n "Introduca nombre de usuario: "
read username
existeUsername=$(grep -i $username usuarios.csv | wc -l)
if [[ $existeUsername = "1" ]]; then
    echo "Lo sentimos, este DNI ya esta registrado en el sistema."
    echo "Intentalo de nuevo o inicia sesion con tu usuario"
    exit 2 
    else 
    echo "No existe jijiji"
fi
