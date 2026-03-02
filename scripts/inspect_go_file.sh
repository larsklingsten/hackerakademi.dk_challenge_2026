#!/bin/bash
FILE=/opt/caas/caas

echo "script is for go exe files only"

echo 'file $FILE'
file $FILE

# Standard search
# strings $FILE


echo 'nm $FILE | grep " T " | grep "main\."'
nm $FILE | grep " T " | grep "main\."
# 000000000061fa80 T main.compileHandler
# 0000000000620160 T main.compileHandler.deferwrap1
# 000000000061f9a0 T main.main
# 000000000046bbe0 T runtime.main.func1
# 000000000043e6a0 T runtime.main.func2

nm $FILE | grep " T "

nm $FILE| grep " T " | grep -vE "runtime|sync|reflect|syscall|vendor|internal|time|os|fmt|io|path|strconv"

echo 'strings $FILE | grep -E "http|10\.|192\.|/home/|passwd"'
strings $FILE | grep -E "http|10\.|192\.|/home/|passwd"
