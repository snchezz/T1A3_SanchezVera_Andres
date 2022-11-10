#!/bin/bash

# Andrés Sánchez

# Exit code 0: Todo ha funcionado correctamente.
# Exit code 1: El formato introducido no es el correcto.
# Exit code 2: Usuario (DNI) ya en el sistema
# Exit code 3: Intentos maximos permitidos
# Exit code 4: Archivo usuarios.csv vacio

function archivoVacio() {
    if [ -s usuarios.csv ]; then
        # Cuando el archivo tiene datos , se le pondra la variable 0
        archivoUsuarioVacio=0
    else
        # Cuando el archivo este VACIO, se le pondra la variable 1
        archivoUsuarioVacio=1
    fi
}

function copia() {
    function copialocal() {
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
    }

    function github() {
        echo "AVISO: PARA EL CORRECTO FUNCIONAMIENTO DEL PROGRAMA,
DEBES TENER CONFIGURADO GIT EN TU ORDENADOR"
        echo ""
        echo "SI NO SABES CONFIGURAR GIT, PORFAVOR,
PULSA: CTRL + CLICK IZQ EN EL SIGUIENTE ENLACE"
        echo ""
        echo "https://snchezz.github.io/tutorialgithubvscodev2/"
        sleep 2s
        echo "Elige una de estas opciones"
        echo " 1) CREAR REPOSITORIO
 2) ACTUALIZAR REPOSITORIO YA CREADO
 3) VOLVER ATRAS
 4) SALIR"

        read opc
        case $opc in
        "1")
            echo "Crear repositorio"
            echo ""
            # Creamos el repositorio
            git init
            echo "Repositorio creado"
            sleep 1s
            echo ""
            # Pedimos el enlace de origin que se muestra al iniciar un repositorio en Git Hub
            echo "Añade el origin como este: https://github.com/usuario/repositorio.git"
            read origin
            regex='(https?)://github.com/*[-[:alnum:]\+&@#/%=~_|]'
            string="$origin"
            if [[ $origin =~ $regex ]]; then
                # Si lo es, empazará la súbida de archivos
                git remote add origin $origin
                git add .
                sleep 1s
                echo ""
                # Preguntamos la versión que queremos poner en el commit
                echo "¿Que version es? Por ejemplo V1"
                read version
                git commit -m "$version"
                git push -u origin master
                echo ""
                echo "Todo ha funcionado correctamente"
            else
                # Si no se ha introducido un enlace o no es de la estructura pedida, se notificara al usuario
                echo "El enlace debe seguir esta estructura: https://github.com/usuario/repositorio.git"
                exit 1
            fi
            ;;
        "2")
            echo "Actualizar repositorio"
            git add .
            echo ""
            echo "¿Que version es? Por ejemplo V1"
            read version
            git commit -m "$version"
            git push -u origin master
            echo ""
            echo "Repositorio actualizado correctamente"
            exit 0
            ;;
        "3")
            clear
            menu
            ;;
        "4")
            echo "Saliendo del sistema..."
            exit 0
            ;;
        *)
            echo "La opción que has introducido no existe,
    porfavor, elige un número del 1 al 4"
            exit 2
            ;;
        esac

    }

    while true; do
        echo ""
        echo "Elige donde quieres guardar las copias:"
        echo "1.- EN LOCAL"
        echo "2.- EN GITHUB"
        echo "3.- VOLVER ATRAS"
        read opcuserscopy

        case $opcuserscopy in
        1)
            copialocal
            ;;
        2)
            clear
            if [[ $rootTrue -eq 1 ]]; then
                github
            else
                echo "Accion no permitida para este usuario, solo puedes crear copias de seguridad en local"
            fi
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

    if [[ $existeUser -eq 1 ]]; then
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
    archivoVacio
    if [ $archivoUsuarioVacio -eq 1 ]; then
        echo "El archivo usuarios.csv, esta vacio, por lo tanto no se podrá dar de baja a ningun usuario"
        exit 4
    fi

    echo "Porfavor, indica tu DNI para darte de baja en el sistema:"
    read dni
    comprobarDNI
    existe

    # Mirar corchertes y iguales en ifs
    if [[ $existeUser -eq 1 ]]; then
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
    archivoVacio
    if [ $archivoUsuarioVacio -eq 1 ]; then
        echo ""
        echo "El archivo usuarios.csv, esta vacio, por lo tanto no se podrá mostrar ningun usuario"
        exit 4
    else
        while true; do
            echo ""
            echo "Elige como quieres mostrar los usuarios"
            echo "1.- POR ORDEN DE ALTA"
            echo "2.- POR ORDEN DEL DNI"
            echo "3.- POR ORDEN ALFABETICO (USUARIO)"
            echo "4.- POR ORDEN ALFABETICO (ALUMNO)"
            echo "5.- VOLVER ATRAS"
            read opcusers

            case $opcusers in
            1)
                echo ""
                # PONER BONITO ESTO (INTENTO DE TABLA)
                echo "LISTA DE USUARIOS POR ORDEN DE ALTA"
                cat usuarios.csv | awk -F ":" '{print $5":"$1":"$2":"$3":"$4}'
                echo ""
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                mostrar_usuarios
                ;;
            2)
                echo ""
                echo "LISTA DE USUARIOS POR ORDEN DNI"
                cat usuarios.csv | awk -F ":" '{print $4":"$1":"$2":"$3":"$5}' | sort
                echo ""
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                mostrar_usuarios
                ;;
            3)
                echo ""
                echo "LISTA DE USUARIOS POR ORDEN ALFABETICO DEL NOMBRE DE USUARIO"
                cat usuarios.csv | awk -F ":" '{print $5":"$1":"$2":"$3":"$4}' | sort
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                mostrar_usuarios
                ;;
            4)
                echo ""
                echo "LISTA DE USUARIOS POR ORDEN ALFABETICO DEL NOMBRE DEL ALUMNO"
                cat usuarios.csv | awk -F ":" '{print $1":"$2":"$3":"$4":"5}' | sort
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                mostrar_usuarios
                ;;
            5)
                echo ""
                menu
                ;;
            *)
                # Si no se ha elegido una opción válida
                echo "Elige una opción válida. Si quieres volver atras, pulsa 5"
                sleep 1s
                echo ""
                ;;
            esac
        done
    fi
}

function menu() {
    while true; do
        echo "Elige una opción"
        echo "1.- EJECUTAR COPIA DE SEGURIDAD
2.- DAR DE ALTA USUARIO
3.- DAR DE BAJA AL USUARIO
4.- MOSTRAR USUARIOS
5.- MOSTRAR LOG DEL SISTEMA
6.- CERRAR SESION
7.- SALIR"

        # Leemos la opción que ha elegido y llamamos a la función correspondiente
        read opc
        case $opc in
        1)
            copia
            ;;
        2)
            if [[ $rootTrue -eq 1 ]]; then
                alta
            else
                echo "Accion no permitida para este usuario"
                echo ""
            fi
            ;;
        3)
            if [[ $rootTrue -eq 1 ]]; then
                baja
            else
                echo "Accion no permitida para este usuario"
                echo ""
            fi

            ;;
        4)
            mostrar_usuarios
            ;;
        5)
            mostrar_log
            ;;
        6)
            echo "Cerrando sesion"
            sleep 1s
            clear
            login
            ;;
        7)
            echo ""
            echo "Saliendo del sistema..."
            exit 0
            ;;
        *)
            # Si no se ha elegido una opción válida
            echo "Elige una opción válida. Si quieres salir, pulsa 7"
            sleep 1s
            echo ""
            ;;
        esac
    done
}

function login() {
    echo "    - - - - - - - IPASEN+ BY ANDRÉS SANCHEZ- - - - - - -    "
    echo "GitHub: https://github.com/snchezz"
    sleep 1s

    archivoVacio
    if [[ $archivoUsuarioVacio -eq 1 ]]; then
        echo "El archivo usuarios.csv, esta vacio, por lo tanto no se podrá iniciar sesion ningun usuario"
        exit 4
    fi

    for i in {1..4}; do
        if [[ "$i" == '4' ]]; then
            echo "Has superado los intentos máximos de inicio de sesión"
            exit 3
        fi
        echo -n "Introduca nombre de usuario: "
        read -s username
        existeUsername=$(grep -c $username usuarios.csv)
        # Afinar que solo busque nombres de usuarios, ya que si pones el nombre tb lo coge
        nombreUsername=$(awk -F ":" '{print $5}' usuarios.csv | grep -o $username usuarios.csv)

        if [ $existeUsername -eq 1 ]; then
            echo ""
            echo ""
            echo "¡Bienvenido $nombreUsername!"
            echo "Ha iniciado sesion $nombreUsername el dia $(date +%d-%m-%Y) a las $(date +%H:%M)" >>log.log
            menu
        else
            echo "El usuario no esta registrado en el sistema, intentelo de nuevo"
        fi
    done
}

# Lo primero que hara el sistema es comprobar si el archivo usuarios.csv este creado, si no lo esta, lo creara
if ! [ -f usuarios.csv ]; then
    touch usuarios.csv
fi

# Para entrar como admin deberemos usar -root como parametro
if [ "$1" = "-root" ]; then
    rootTrue=1
    echo "Bienvenido admin"
    echo "Ha iniciado sesion administrador el dia $(date +%d-%m-%Y) a las $(date +%H:%M)" >>log.log
    menu
else
    echo "No se reconoce el parametro, se procedera a un inicio de sesión normal."
    sleep 3s
    clear
fi

login
