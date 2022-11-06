#!/bin/bash


# POdemos poner dni / o de los extranjeros tb
read REPLY
if [[ $REPLY =~ ^[0-9]{8}+[A-Za-z]{1} ]]; then
    echo DNI YES
else
    echo NO DNI
fi

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
