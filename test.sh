#!/bin/bash


tamanio=$(ls -s prueba.zip | awk '{print $1}') && if (($tamanio > "3000000")); then echo "Demasiados Gigabytes... | Descomprimir en DemasiadosGB"; unzip prueba.zip -d DemasiadosGB; else echo "Tamaño correcto de GB | Descomprimir en Backup"; unzip prueba.zip -d Backup; fi