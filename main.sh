#!/bin/bash
./reset.sh
figlet -f slant suprimoware
if [ -z "$1" ]; then
    echo "Error: No enviaste un dominio"
    echo "Uso: ./main.sh <dominio>"
    exit 1
fi

domain=$1
echo "Escaneando $domain"

# Estructura de carpetas

timestamp=$(date +"%Y-%m-%d_%H:%M:%S")
ruta_resultados=./resultados/$domain/$timestamp
mkdir -p "$ruta_resultados"
mkdir -p $ruta_resultados/raw
mkdir -p $ruta_resultados/clean

# Analisis infraestructura

dig +short A $domain > $ruta_resultados/clean/IP
dig +short MX $domain > $ruta_resultados/clean/MX
dig +short TXT $domain > $ruta_resultados/clean/TXT
dig +short NS $domain > $ruta_resultados/clean/NS
dig +short SRV $domain > $ruta_resultados/clean/SRV
dig +short AAAA $domain > $ruta_resultados/clean/AAAA
dig +short CNAME $domain > $ruta_resultados/clean/CNAME
dig +short SOA $domain > $ruta_resultados/clean/SOA

#echo "Extrayendo rangos de IP"
#TODO: Funciona con una IP, tenemos que hacer un bucle para recorrer todas cuando tenemos mas de una
#whois -b $(cat $ruta_resultados/clean/IP) | grep 'inetnum' | awk '{print $2, $3, $4}' > $ruta_resultados/clean/rangos_ripe
echo "Realizando whois"
whois $domain > $ruta_resultados/raw/whois
echo "Realizando dig "
dig $domain > $ruta_resultados/raw/dig

curl -I https://$domain > $ruta_resultados/raw/headers
cat $ruta_resultados/raw/headers | grep -i Server | awk '{ print $2 }' > $ruta_resultados/clean/header_server

