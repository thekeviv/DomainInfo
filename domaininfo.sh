#!/bin/bash

# The script gathers info about a domain name supplied to it and prints it in an 
# easily consumable manner.
# Author - Vivek Sharma
# Written for the Lab Assignment of SENG460 at the University of Victoria taken in Spring 2021

# Regex taken from https://stackoverflow.com/questions/5284147/validating-ipv4-addresses-with-regexp
ipregex="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
# Regex taken from https://levelup.gitconnected.com/extremely-useful-regular-expression-examples-for-real-world-applications-567e844a0822
emailregex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
# Regex taken from https://stackoverflow.com/questions/3183444/check-for-valid-link-url but modified to make the protocol optional
urlregex="[(https?|ftp|file)://]*[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"



function process_arg {
    # Step 1 - Run the awk command and store the response in the whoisoutput variable.
    # -H argument specifies to not include the legal stuff
    whoisoutput=$(whois -H $1)
    orgname="OrgName"
    # The whois output has the following variable values stored, the awk commands below find
    # the first and then exits and stores it in the domain name variable. ': ' is used as the 
    # delimiter value
    domainname=$(echo "$whoisoutput" | awk '/Domain Name:/ { print $2; exit; }' FS=:)
    registrantorgname=$(echo "$whoisoutput" | awk '/Registrant Organization:/ || /OrgName/ { print $2; exit; }' FS=': ')
    registrantcountry=$(echo "$whoisoutput" | awk '/Registrant Country:/ || /Country/ { print $2; exit; }' FS=': ')
    creationdate=$(echo "$whoisoutput" | awk '/Creation Date:/ || /RegDate/ { print $2; exit; }' FS=': ')
    updatedate=$(echo "$whoisoutput" | awk '/Updated Date:/ || /Updated/ { print $2; exit; }' FS=': ')
    abusecontactemail=$(echo "$whoisoutput" | awk '/Abuse Contact Email:/ || /OrgAbuseEmail/ { print $2; exit; }' FS=': ')
    abusecontactphone=$(echo "$whoisoutput" | awk '/Abuse Contact Phone:/ || /OrgAbusePhone/ { print $2; exit; }' FS=': ')
    echo $domainname
    echo $registrantorgname
    echo $registrantcountry
    echo $creationdate
    echo $updatedate
    echo $abusecontactemail
    echo $abusecontactphone



}



if [ $# -gt 1 -o $# -lt 1 ]
then 
    echo "Error: Only one argument allowed. The expected input for the command is domaininfo {domain name}"
else
    # Step 1.a - Check if the input is an IPv4 address
    if [[ $1 =~ $ipregex ]]; 
    then 
        process_arg "$1"
    # Step 1.b - Check if the input is an Email
    elif [[ $1 =~ $emailregex ]];
    then
        # The command below extracts the domain name with the tld from the email.
        # 1. It simply removes anything before and including @

        email=$(echo $1 | sed 's/^.*@//')
        process_arg "$email"
    # Step 1.c - Check if the input is a URL
    elif [[ $1 =~ $urlregex ]];
    then
        # The command below extracts the domain name with the tld from the url.
        # 1. It starts by removing https or http from the begining of the argument (If they exist)
        # 2. It then removes "://" from the argument (If they exist)
        # 3. It then removes "://" from the argument (If they exist)
        url=$(echo $1 | sed 's/^https//' | sed 's/^http//' | sed 's/^:\/\///' | sed 's/^www.//')
        process_arg "$url"
    else
        echo "Error: Couldn't parse the supplied value to a URL/Email or an IP Address. Make sure the supplied value doesn't have a typo."
    fi
fi
