#!/bin/bash

# Andrés Sánchez

# Exit code 0: Todo ha funcionado correctamente.
# Exit code 1: El formato introducido no es el correcto.
# Exit code 2: Usuario (DNI) ya en el sistema

# Cuando se inice el sistema, se añadera el dia, mes, año, hora, minuto para saber los cambios que se produjeron en ese momento que se ejecuto
echo "------------$(date +%d%m%Y:%H:%M)------------" >>  log.log
echo "------------$(date +%d%m%Y:%H:%M)------------" >>  usuarios.csv

function copia() {
    # Se crea la copia de seguridad de la carpeta donde se encuentra el script.
    # La opción -r es para que sea recursivo
    zip -r copia_usuarios_$(date +%d%m%Y)_$(date +%H:%M:%S).zip .
    echo "Copia de seguridad copia_usuarios_$(date +%d%m%Y)_$(date +%H:%M:%S) realizada correctamente el $(date +%d%m%Y) a las $(date +%H:%M)" >>log.log

    # Se hace una busqueda para que solo hayan 2 copias de seguridad (compara el número de copias .zip que hay)
    busqueda=$(find . -name "copia_usuarios*zip" | wc -l)
    if [[ $busqueda > "2" ]]; then
        # Se borra el mas antiguo, buscandolo con sort
        antugio=$(find . -name "*zip" | sort | head -n 1)
        echo "Copia de seguridad $antugio borrada correctamente el $(date +%d%m%Y) a las $(date +%H:%M)" >>log.log
        rm $antugio
        echo "Se ha realizado la copia de seguridad correctamente."

        echo ""
    fi
    # GITHUB?
}

function alta() {
    echo ""
    echo -n "Nombre: "
    read nombre
    if [[ ${#nombre} -lt 3 ]]; then
        echo "El nombre debe tener como mínimo 3 caracteres"
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
    echo -n "Primer Apellido: "
    read ape1
    if [[ ${#ape1} -lt 3 ]]; then
        echo "El primer apellido debe tener como mínimo 3 caracteres"
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
    echo -n "Segundo Apellido: "
    read ape2
    if [[ ${#ape2} -lt 3 ]]; then
        echo "El segundo apellido debe tener como mínimo 3 caracteres"
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
    echo -n "DNI (12345678X): "
    read dni
    comprobarDNI

    #Si todos los parametros estan correctamente introducidos, siguiento las indicaciones
    # Se comprobara si el usuario existe mediante el DNI
    existe
    # Si hay 1, significara que ese DNI ya se ha utilizado, por tanto, ya estará esa persona en el sistema

    if [[ $existeUser = "1" ]]; then
        echo "Lo sentimos, este DNI ya esta registrado en el sistema."
        echo "Intentalo de nuevo o inicia sesion con tu usuario"
        exit 2
    fi

    # Si no existe, se procedera a generar el usuario
    generauser
}

function comprobarDNI() {
    if ! [[ $dni =~ ^[0-9]{8}+[A-Za-z]{1} ]]; then
        echo "El DNI debe cumplir un formato, 12345678X."
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
}

function generauser() {
    nombrecortado=$(echo "$nombre" | tr '[:upper:]' '[:lower:]' | cut -b 1)
    ape1cortado=$(echo "$ape1" | tr '[:upper:]' '[:lower:]' | cut -b 1-3)
    ape2cortado=$(echo "$ape2" | tr '[:upper:]' '[:lower:]' | cut -b 1-3)
    dnicortado=$(echo "$dni" | cut -b 6-8)
    usergen=$nombrecortado$ape1cortado$ape2cortado$dnicortado

    echo "Tu usuario generado es: $usergen"
    echo "$nombre:$ape1:$ape2:$dni:$usergen" >>usuarios.csv
    echo "INSERTADO $nombre:$ape1:$ape2:$dni:$usergen el $(date +%d%m%Y) a las $(date +%H:%M)" >>log.log
    echo ""
}

function existe() {
    # Contamos el número de veces que esta el DNI introducido en el sistema
    existeUser=$(grep -i $dni usuarios.csv | wc -l)
}

function baja() {
    echo "Porfavor, indica tu DNI para darte de baja en el sistema:"
    read dni
    comprobarDNI
    existe
    if [[ $existeUser = "1" ]]; then
        echo "El usuario con DNI $dni se ha eliminado del sistema correctamente."

        # Recuperamos el usuario antes de borrarlo para meterlo en el log
        userBorrado=$(grep -i $dni usuarios.csv)
        echo "BORRADO $userBorrado el $(date +%d%m%Y) a las $(date +%H:%M)" >>log.log

        # Eliminamos el user mostrando todo el documento inverso del que hemos buscado con -v
        eliminarUserDNI=$(grep -v $dni usuarios.csv)
        echo "$eliminarUserDNI" >usuarios.csv
        echo ""
    else
        echo "El DNI $dni no esta registrado en el sistema"
        echo ""
    fi

    # existe
}

function mostrar_log() {
    echo ""
    echo "Mostrando el log del sistema..."
    cat log.log
    echo ""
    read -n 1 -r -s -p $'Pulsa cualquier tecla para que aparezca el menu...\n'
    echo ""
}

function mostrar_usuarios() {
    while true; do
        echo ""
        echo "Elige como quieres mostrar los usuarios"
        echo "1.- POR ORDEN DE ALTA"
        echo "2.- POR ORDEN ALFABETICO"
        echo "3.- VOLVER ATRAS"
        read opcusers

        case $opcusers in
        1)
            echo ""
            # PONER BONITO ESTO (INTENTO DE TABLA)
            echo "LISTA DE USUARIOS POR ORDEN DE ALTA"
            cat usuarios.csv | sed '1d' usuarios.csv | awk -F ":" '{print $5":"$1":"$2":"$3":"$4}'
            read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
            echo ""
            menu
            ;;
        2)
            echo ""
            echo "LISTA DE USUARIOS POR ORDEN ALFABETICO"
            cat usuarios.csv | sed '1d' usuarios.csv | awk -F ":" '{print $5":"$1":"$2":"$3":"$4}' | sort
            read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
            echo ""
            ;;
        3)
            echo ""
            menu
            ;;
        *)
            # Si no se ha elegido una opción válida
            echo "Elige una opción válida. Si quieres volver atras, pulsa 3"
            sleep 1s
            echo ""
            ;;
        esac

    done
}

function menu() {
    while true; do
        echo "Elige una opción"
        echo "1.- EJECUTAR COPIA DE SEGURIDAD
2.- DAR DE ALTA USUARIO
3.- DAR DE BAJA AL USUARIO
4.- MOSTRAR USUARIOS
5.- MOSTRAR LOG DEL SISTEMA
6.- SALIR"

        # Leemos la opción que ha elegido y llamamos a la función correspondiente
        read opc
        case $opc in
        1)
            copia
            ;;
        2)
            alta
            ;;
        3)
            baja
            ;;
        4)
            mostrar_usuarios
            ;;
        5)
            mostrar_log
            ;;
        6)
            echo ""
            echo "Saliendo del sistema..."
            exit 0
            # borrar log?
            ;;
        *)
            # Si no se ha elegido una opción válida
            echo "Elige una opción válida. Si quieres salir, pulsa 6"
            sleep 1s
            echo ""
            ;;
        esac
    done
}

# Comprobar si el fichero existe
#if [ -f usuarios.csv ]; then
#    echo "El fichero existe"
#else
#    echo "Fichero usuarios.csv creado el $(date +%d-%m-%Y) a las $(date +%H:%M:%S)" >>usuarios.csv
#    echo "" >>usuarios.csv
#    echo "Nombre:1erApellido:2oApellido:DNI:NombreUser" >>usuarios.csv
#fi

# Read Password
# echo -n Usuario:
# read -s user
# echo $user

menu
