#!/bin/bash

bash -c 'exit 0' &

HIJO=$!
echo "Hijo PID: $HIJO        revisando en 5 segundos..."
sleep 5

ps -o pid,ppid,stat,comm -p $HIJO
echo "Padre dormido. Para ver el zombie: ps aux | grep Z"
sleep 60

