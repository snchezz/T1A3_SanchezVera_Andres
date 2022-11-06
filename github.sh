#!/bin/bash

# Andrés Sánchez

# Exit code 0: Todo ha funcionado correctamente.
# Exit code 1: Se ha introducido un origen que o no es un enlace o no sigue la estructura permitida.
# Exit code 2: Se ha introducido un parametro no permitido.

# Se pone avisos para el correcto funcionamiento del programa
echo "AVISO: PARA EL CORRECTO FUNCIONAMIENTO DEL PROGRAMA,
DEBES TENER CONFIGURADO GIT EN TU ORDENADOR"
echo ""
echo "SI NO SABES CONFIGURAR GIT, PORFAVOR,
PULSA: CTRL + CLICK IZQ EN EL SIGUIENTE ENLACE"
echo ""
echo "https://docs.github.com/es/get-started/quickstart/set-up-git"

# Funcion donde se comprueba que el enlace Origin sea un enlace
function comprobarOrigin {
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
}

sleep 4s
echo "Elige una de estas opciones"
echo " 1) Crear repositorio
 2) Actualizar repositorio ya creado
 3) Borrar los archivos .git (Para subirlo en otro repositorio)
 4) Salir"

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
    comprobarOrigin
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
    echo "Para borrar los archivos git, usa este comando:"
    echo "rm -rf .git"
    exit 0
    ;;
"4")
    echo "Has salido del programa!"
    exit 0
    ;;
*)
    echo "La opción que has introducido no existe,
    porfavor, elige un número del 1 al 4"
    exit 2
    ;;
esac
