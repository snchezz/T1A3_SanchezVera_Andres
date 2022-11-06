#!/bin/bash

echo -n "Nombre: "
read nombre
echo -n "Primer Apellido: "
read ape1
echo -n "Segundo Apellido: "
read ape2
echo -n "DNI "
read dni

nombrecortado=$(echo "$nombre" | tr '[:upper:]' '[:lower:]' | cut -b 1)
ape1cortado=$(echo "$ape1" | tr '[:upper:]' '[:lower:]' | cut -b 1-3)
ape2cortado=$(echo "$ape2" | tr '[:upper:]' '[:lower:]' | cut -b 1-3)
dnicortado=$(echo "$dni" | cut -b 6-8)

usergen=$nombrecortado$ape1cortado$ape2cortado$dnicortado

echo "Tu usuario generado es: $usergen"

echo "$nombre:$ape1:$ape2:$dni:$usergen" >> usuarios.csv


# Al crear el archivo  usuarios.csv, hacer antes un echo que diga Nombre:Apellido1:Apellido2:DNI 
# y el primer dia qu es ecreo o algo asi 


# Podemos poner dni / o de los extranjeros tb
# read REPLY
# if [[ $REPLY =~ ^[0-9]{8}+[A-Za-z]{1} ]]; then
#     echo DNI YES
# else
#     echo NO DNI
# fi

# if [ "$1" = "-root" ]; then
#     echo "El usuario es root"
# else
#     echo "El usuario NO ES root"
# fi

# Read Password
# echo -n Usuario:
# read -s user

# echo
# Run Command
# echo $user
