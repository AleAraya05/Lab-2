#!/bin/bash

(
	bash -c 'exit 0'
	ps aux | grep Z
	echo "Padre vivo, hijo muerto"
	sleep 30
	ps aux | grep Z
) &

ps aux | grep Z
sleep 1

#ps aux | grep Z






