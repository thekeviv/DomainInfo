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

if [ $# -gt 1 -o $# -lt 1 ]
then 
    echo "Error: Only one argument allowed. The expected input for the command is domaininfo {domain name}"
else
    # Step 1.a - Check if the input is an IPv4 address
    if [[ $1 =~ $ipregex ]]; 
    then 
        echo "IP Address"
    # Step 1.b - Check if the input is an Email
    elif [[ $1 =~ $emailregex ]];
    then
        # The command below extracts the domain name with the tld from the email.
        # 1. It simply removes anything before and including @
        echo $1 | sed 's/^.*@//'
    # Step 1.c - Check if the input is a URL
    elif [[ $1 =~ $urlregex ]];
    then
        # The command below extracts the domain name with the tld from the url.
        # 1. It starts by removing https or http from the begining of the argument (If they exist)
        # 2. It then removes "://" from the argument (If they exist)
        # 3. It then removes "://" from the argument (If they exist)
        echo $1 | sed 's/^https//' | sed 's/^http//' | sed 's/^:\/\///' | sed 's/^www.//'
    else
        echo "Error: Couldn't parse the supplied value to a URL/Email or an IP Address. Make sure the supplied value doesn't have a typo."
    fi
fi

function process_arg {
    if [ $2 -eq "IP" ];
    then
        echo "IP"
    else
        "echo URL"
    fi
}
