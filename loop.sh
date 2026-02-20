#!/bin/bash

while true; do
    claude --dangerously-skip-permissions -p "prompt.md 파일을 읽고 지시대로해"
    sleep 10
done
