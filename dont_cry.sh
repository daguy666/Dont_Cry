#!/bin/bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MIT License
#
# Copyright (c) 2017 Joey Pistone
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This is a script using the nmap scripting engine to
# scan for systems vulnerable to petya and wannacry
# A cron might be needed to run this frequently
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Variables 
PLUS="[+]"
NM='/usr/local/bin/nmap' 
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
DIR='/path/to/wannacry/'
OUTPUT='_output.txt'
FILE_NAME=$DIR$TIMESTAMP$OUTPUT
ARGS='-sC -p 445 --script smb-vuln-ms17-010.nse -iL ip_pools.txt --reason'
IPREG='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'

# Enter email addersses here 'email0@email.com email1@email.com'
EMAIL_RECIPIENTS=''
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A quick word about the scan starting
echo "$PLUS Running Petya/WannaCry Vuln scan against list ..."

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This is where the magic happens
"$NM" "$ARGS" > "$FILE_NAME"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Gathers some information about the scan and
# returns it to the command line
TAIL=$(tail -n 1 "$FILE_NAME")
echo "$PLUS $TAIL"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Store the output of the following commands to the following variables.
GR=$(grep -i "State: VULNERABLE" "$FILE_NAME")
GR2=$(grep -i "State: VULNERABLE" "$FILE_NAME" | wc -l)
# ready for this hack? This grabs the output and the 10 lines above
# then parses out the ip address.
GR3=$(grep -i -B 10 "state: VULNERABLE" "$FILE_NAME"| grep -E "$IPREG" | awk -F \( '{print $2}' | sed 's/)//g')

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Some logic to deterime if the output of GR is empty or not
# empty = not vulnerable
# not empty = vulnerable

if [[ "$GR" ]]; then
    echo "$PLUS" "Systems Vulnerable:" "$GR2" "IP Address:" "$GR3"
    # If you don't want to email the results comment out the next line.                                                                         
    echo -e "\$PLUS $TAIL\n\n$PLUS Systems Vulnerable:" "$GR2" "IP Address:" "$GR3" | mail -s "WannaCry Vulnerability Report " $EMAIL_RECIPIENTS
else
    echo "$PLUS No systems vulnerable"
    # If you want emails every time this thing runs uncomment out the next line.
    #echo -e "$PLUS $TAIL\n\n$PLUS no systems vulnerable" | mail -s "WannaCry Vulnerability Report " $EMAIL_RECIPIENTS

fi
