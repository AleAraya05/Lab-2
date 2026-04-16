#!/bin/bash


# Recepcion de argumentos

argumentos=$#

if [ "$argumentos" -lt 2 ]; then
	echo "Uso: $0 <'comando'> <intervalo (segundos)>"
	exit 1
else
	echo "Datos: <comando> <intervalo> recibidos."
fi

comando=$1
intervalo=$2

# Ejecucion del proceso

$comando &
pid=$!

# Registro periodico

log="monitor_$pid.log"

trap "echo 'Monitoreo detenido.'; kill $pid; exit" SIGINT
#Manejo de finalizacion
#Vi que al parecer habia que ponerlo antes del while para que funcione.

SECONDS=0

while ps -p $pid > /dev/null
do
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	datos=$(ps -p $pid -o %cpu,%mem,rss --no-headers)

	echo "$SECONDS $timestamp $datos" >> $log
	sleep $intervalo
done

# Graficacion

echo "Generando grafica..."

#Vi que EOF se usa para indicarle al shell cuando terminar un bloque de texto
#que se le esta pasando.

gnuplot << EOF

set terminal png
set output "monitor_$pid.png"
set title "Proceso: $comando ; PID: $pid"
set xlabel "Tiempo transcurrido (s)"
set ylabel "%CPU"
set ytics nomirror #para que no se repita del lado derecho
set y2tics #para permitir el uso separado del eje derecho
set y2label "RSS (KB)" #escritura en el eje derecho

plot "$log" using 1:4 with lines title "%CPU", \
 "$log" using 1:6 axes x1y2 with lines title "RSS (KB)"
EOF

xdg-open "monitor_$pid.png" &

