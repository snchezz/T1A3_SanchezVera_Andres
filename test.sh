#!/bin/bash

for i in {1..4}; do
    if [[ "$i" == '4' ]]; then
        echo "Ya has superado el intento"
        exit 1
    fi
    read prueba
    echo "Escribiste $prueba"
done
