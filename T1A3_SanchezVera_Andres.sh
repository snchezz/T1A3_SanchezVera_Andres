#!/bin/bash

# Andrés Sánchez

# Exit code 0: Todo ha funcionado correctamente.
# Exit code 1: El formato introducido no es el correcto.
# Exit code 2: Usuario (DNI) ya en el sistema
# Exit code 3: Intentos maximos permitidos
# Exit code 4: Archivo usuarios.csv vacio
# Exit code 5: GITHUB Se ha introducido un origen que o no es un enlace o no sigue la estructura permitida.
# Exit code 6: GITHUB Se ha introducido un parametro no permitido.

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
            sleep 2s
            echo ""
            clear
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
 3) BORRAR ARCHIVOS .GIT PARA CREAR UN REPOSITORIO
 4) VOLVER ATRAS
 5) SALIR"

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
                sleep 1s
                clear
                menu
            else
                # Si no se ha introducido un enlace o no es de la estructura pedida, se notificara al usuario
                echo "El enlace debe seguir esta estructura: https://github.com/usuario/repositorio.git"
                exit 5
            fi
            ;;
        "2")
            # Actualizar repositorio
            echo "Actualizar repositorio"
            git add .
            echo ""
            echo "¿Que version es? Por ejemplo V1"
            read version
            git commit -m "$version"
            git push -u origin master
            echo ""
            echo "Repositorio actualizado correctamente"
            sleep 2s
            clear
            menu
            ;;
        "3")
            clear
            echo "Para el sistema y usa este comando:"
            echo "rm -rf .git"
            echo ""
            read -n 1 -r -s -p $'Pulsa cualquier tecla para que aparezca el menu de git...\n'
            clear
            ;;
        "4")
            # Volver al menu
            clear
            menu
            ;;
        "5")
            echo "Saliendo del sistema..."
            exit 0
            ;;
        *)
            echo "Elige una opción válida. Si quieres volver atras, pulsa 5"
            ;;
        esac
    }

    while true; do
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
            # Solo el usuario root puede hacer repositorio en GitHub
            if [[ $rootTrue -eq 1 ]]; then
                while true; do
                    github
                done
            else
                echo "Accion no permitida para este usuario, solo puedes crear copias de seguridad en local"
            fi
            ;;
        3)
            echo ""
            clear
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

function alta() {
    echo ""
    # Se lee el nombre sin que se vea en consola
    echo -n "Nombre: "
    read nombre
    # Se comprueba que el nombre tenga al mínimo 3 caracteres
    if [[ ${#nombre} -lt 3 ]]; then
        echo "El nombre debe tener como mínimo 3 caracteres"
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
    echo -n "Primer Apellido: "
    read ape1
    # Se comprueba que el apellido1 tenga al mínimo 3 caracteres
    if [[ ${#ape1} -lt 3 ]]; then
        echo "El primer apellido debe tener como mínimo 3 caracteres"
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
    echo -n "Segundo Apellido: "
    read ape2
    # Se comprueba que el apellido2 tenga al mínimo 3 caracteres
    if [[ ${#ape2} -lt 3 ]]; then
        echo "El segundo apellido debe tener como mínimo 3 caracteres"
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
    # Se comprueba que el DNI siga un patron
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
    # Funcion para comprobar que el DNi tenga un formato correcto
    if ! [[ $dni =~ ^[0-9]{8}+[A-Za-z]{1} ]]; then
        echo "El DNI debe cumplir un formato, 12345678X."
        echo "Intentelo de nuevo. ¡Gracias!"
        exit 1
    fi
}

function generauser() {
    # Funcion para generar el usuario, usando tr y cut
    nombrecortado=$(echo "$nombre" | tr '[:upper:]' '[:lower:]' | cut -b 1)
    ape1cortado=$(echo "$ape1" | tr '[:upper:]' '[:lower:]' | cut -b 1-3)
    ape2cortado=$(echo "$ape2" | tr '[:upper:]' '[:lower:]' | cut -b 1-3)
    dnicortado=$(echo "$dni" | cut -b 6-8)
    usergen=$nombrecortado$ape1cortado$ape2cortado$dnicortado

    echo "Tu usuario generado es: $usergen"
    # Añadimos el usuarios al archivo usuarios.csv
    echo "$nombre:$ape1:$ape2:$dni:$usergen" >>usuarios.csv
    # Añadimos el usuarios al archivo log.log
    echo "INSERTADO $nombre:$ape1:$ape2:$dni:$usergen el $(date +%d%m%Y) a las $(date +%H:%M)" >>log.log
    echo ""
}

function existe() {
    # Contamos el número de veces que esta el DNI introducido en el sistema
    existeUser=$(grep -w "$dni" usuarios.csv | wc -l)
}

function baja() {
    # Comprobamos si el archivo usuarios.csv esta vacio, si lo esta no podrá darse de baja a los usuarios que no existen
    archivoVacio
    if [ $archivoUsuarioVacio -eq 1 ]; then
        echo "El archivo usuarios.csv, esta vacio, por lo tanto no se podrá dar de baja a ningun usuario"
        exit 4
    fi

    echo "Porfavor, indica tu DNI para darte de baja en el sistema:"
    read dni
    comprobarDNI
    existe

    # Si el usuario existe se borrara el DNI
    if [[ $existeUser -eq 1 ]]; then
        echo "El usuario con DNI $dni se ha eliminado del sistema correctamente."

        # Recuperamos el usuario antes de borrarlo para meterlo en el log
        userBorrado=$(grep -w "$dni" usuarios.csv)
        echo "BORRADO $userBorrado el $(date +%d%m%Y) a las $(date +%H:%M)" >>log.log

        # Eliminamos el user mostrando todo el documento inverso del que hemos buscado con -v
        eliminarUserDNI=$(grep -v $dni usuarios.csv)
        echo "$eliminarUserDNI" >usuarios.csv
        echo ""
    else
        # Si el DNI no esta registrado se notificara
        echo "El DNI $dni no esta registrado en el sistema"
        echo ""
    fi
}

function mostrar_log() {
    echo ""
    echo "Mostrando el log del sistema..."
    # Se muestra el log del sistema
    cat log.log
    echo ""
    read -n 1 -r -s -p $'Pulsa cualquier tecla para que aparezca el menu...\n'
    clear
}

function mostrar_usuarios() {
    # Se comprueba el archivo usuarios.csv
    archivoVacio
    if [ $archivoUsuarioVacio -eq 1 ]; then
        # Si esta vacio se notificara
        echo ""
        echo "El archivo usuarios.csv, esta vacio, por lo tanto no se podrá mostrar ningun usuario"
        exit 4
    else
        while true; do
            echo "Elige como quieres mostrar los usuarios"
            echo "1.- POR ORDEN DE ALTA"
            echo "2.- POR ORDEN DEL DNI"
            echo "3.- POR ORDEN ALFABETICO (USUARIO)"
            echo "4.- POR ORDEN ALFABETICO (ALUMNO)"
            echo "5.- VOLVER ATRAS"
            read opcusers

            case $opcusers in
            # Con el comando awk y sort haremos las distintos filtros de orden
            1)
                clear
                echo "LISTA DE USUARIOS POR ORDEN DE ALTA"
                cat usuarios.csv | awk -F ":" '{print $5":"$1":"$2":"$3":"$4}'
                echo ""
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                clear
                mostrar_usuarios
                ;;
            2)
                clear
                echo "LISTA DE USUARIOS POR ORDEN DNI"
                cat usuarios.csv | awk -F ":" '{print $4":"$1":"$2":"$3":"$5}' | sort
                echo ""
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                clear
                mostrar_usuarios
                ;;
            3)
                clear
                echo "LISTA DE USUARIOS POR ORDEN ALFABETICO DEL NOMBRE DE USUARIO"
                cat usuarios.csv | awk -F ":" '{print $5":"$1":"$2":"$3":"$4}' | sort
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                clear
                mostrar_usuarios
                ;;
            4)
                clear
                echo "LISTA DE USUARIOS POR ORDEN ALFABETICO DEL NOMBRE DEL ALUMNO"
                cat usuarios.csv | awk -F ":" '{print $1":"$2":"$3":"$4":"5}' | sort
                read -n 1 -r -s -p $'Pulsa cualquier letra para que aparezca el menu...\n'
                echo ""
                clear
                mostrar_usuarios
                ;;
            5)
                echo ""
                clear
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
    # Creamos el menu principal
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
            clear
            copia
            ;;
        2)
            # Si el usuario no es root, no podrá acceder a esta función
            if [[ $rootTrue -eq 1 ]]; then
                alta
            else
                clear
                echo "Accion no permitida para este usuario"
                echo ""
            fi
            ;;
        3)
            # Si el usuario no es root, no podrá acceder a esta función
            if [[ $rootTrue -eq 1 ]]; then
                baja
            else
                clear
                echo "Accion no permitida para este usuario"
                echo ""
            fi

            ;;
        4)
            clear
            mostrar_usuarios
            ;;
        5)
            clear
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
    # Funcion login
    echo "    - - - - - - - IPASEN+ BY ANDRÉS SANCHEZ- - - - - - -    "
    echo "GitHub: https://github.com/snchezz"
    sleep 1s

    # Se comprueba si el archivo esta vacio
    archivoVacio
    if [[ $archivoUsuarioVacio -eq 1 ]]; then
        echo "El archivo usuarios.csv, esta vacio, por lo tanto no se podrá iniciar sesion ningun usuario"
        exit 4
    fi

    # 3 intentos de inicio de sesion
    for i in {1..4}; do
        if [[ "$i" == '4' ]]; then
            echo "Has superado los intentos máximos de inicio de sesión"
            exit 3
        fi
        echo -n "Introduzca nombre de usuario: "
        read -s username
        # Busqueda del usuario con awk para elegir la columna y el comando grep -w para que sea exacto
        existeUsername=$(awk -F ":" '{print $5}' usuarios.csv | grep -w "$username" | wc -l)
        nombreUsername=$(awk -F ":" '{print $5}' usuarios.csv | grep -w "$username")

        # Si existe iniciara sesión
        if [[ $existeUsername -eq 1 ]]; then
            clear
            echo "¡Bienvenido $nombreUsername!"
            echo "Ha iniciado sesion $nombreUsername el dia $(date +%d-%m-%Y) a las $(date +%H:%M)" >>log.log
            menu
        else
            # Si no existe se notificara
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
