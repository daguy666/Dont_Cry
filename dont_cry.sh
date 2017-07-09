s is a script using the nmap scripting engine to
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
$NM $ARGS > $FILE_NAME

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Gathers some information about the scan and
# returns it to the command line
TAIL=`tail -n 1 $FILE_NAME`
echo $PLUS $TAIL

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Store the output of the following commands to the following variables.
GR=`grep -i "State: VULNERABLE" $FILE_NAME`
GR2=`grep -i "State: VULNERABLE" $FILE_NAME | wc -l`
# ready for this hack? This grabs the output and the 10 lines above
# then parses out the ip address.
GR3=`grep -i -B 10 "state: VULNERABLE" $FILE_NAME| grep -E $IPREG | awk -F \( '{print $2}' | sed 's/)//g'`

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Some logic to deterime if the output of GR is empty or not
# empty = not vulnerable
# not empty = vulnerable

if [[ $GR ]]; then
    echo "$PLUS Systems Vulnerable:" $GR2 "IP Address:" $GR3
    # If you want to email the results uncoment out the next line.                                                                         
    echo -e "\$PLUS $TAIL\n\n$PLUS Systems Vulnerable:" $GR2 "IP Address:" $GR3 | mail -s "WannaCry Vulnerability Report " $EMAIL_RECIPIENTS
else
    echo "$PLUS No systems vulnerable"
    # If you want emails every time this thing runs uncomment out the next line.
    #echo -e "$PLUS $TAIL\n\n$PLUS no systems vulnerable" | mail -s "WannaCry Vulnerability Report " $EMAIL_RECIPIENTS

fi

