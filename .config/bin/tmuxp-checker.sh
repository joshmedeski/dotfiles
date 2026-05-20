#!/usr/bin/env bash

if [ -f ".tmuxp.yaml" ]; then
	tmuxp load ".tmuxp.yaml"
else
	tmuxp load "default"
fi
