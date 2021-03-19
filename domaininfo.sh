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

# The function takes a name and a value obtained using the whois linux command and 
# pretty prints it using awk

function print_whois_value {
    awk -v name="$1" -v value="$2" 'BEGIN {printf "%-25s %1s %s\n", name":", "|", value}'
}

# The function takes dns records and pretty prints them using awk

function print_records {
    # If there's more than one characters in the record, then print it
    if [[ $(echo "$1" | sed  's/^[n ]*//g;s/[n ]*$//g' | wc -c)  -gt 1 ]];
    then
        echo
        echo "The following $2 Records for the domain/IP Address were found:"
        echo
        echo "$1" | awk '{ print $1; }'   
        echo
    fi
}

function process_arg {
    # Step 1 - Run the whois, dig and host commands and store their responses in variables
    # -H argument specifies to not include the legal stuff
    
    whoisoutput=$(whois -H $1)
    hostoutput=$(host $1)
    digmxoutput=$(dig mx $1)
    digaoutput=$(dig a $1)
    digtxtoutput=$(dig txt $1)
    
    # The whois output has the following variable values stored, the awk commands below find
    # the first and then exits and stores it in the domain name variable. ': ' is used as the 
    # delimiter value. For output consistency, any spaces are removed with sed.
    # Regex to remove trailing and ending spaces taken from 
    # https://www.golinuxhub.com/2017/06/sed-remove-all-leading-and-ending-blank/

    # if the supplied arg is an IP address, then find it's host name. Otherwise, find the IP address for the 
    # hostname
    
    if [[ $2 =~ "IP" ]]; 
    then
        echo "domaininfo - Querying domain info for IP Address: $1" 
        echo
        domainname=$(echo "$hostoutput" | awk '{ print $5; exit; }')
        ipaddress=$1
    else
        echo "domaininfo - Querying domain info for domain: $1"
        echo
        domainname=$(echo "$whoisoutput" | awk '/Domain Name:/ { print $2; exit; }' FS=': ')
        ipaddress=$(echo "$hostoutput" | awk '{ print $4; exit; }')
    fi
    
    # Step 2 - Use the awk command to extract the required data from whois, host and dig outputs
    
    registrantname=$(echo "$whoisoutput" | awk '/Registrant Name:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g') 
    registrantorgname=$(echo "$whoisoutput" | awk '/Registrant Organization:/ || /OrgName:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g') 
    registrantcountry=$(echo "$whoisoutput" | awk '/Registrant Country:/ || /Country/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    registrarname=$(echo "$whoisoutput" | awk '/Registrar:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    registrarurl=$(echo "$whoisoutput" | awk '/Registrar URL:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    registrarwhoisserver=$(echo "$whoisoutput" | awk '/Registrar WHOIS Server:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    adminorg=$(echo "$whoisoutput" | awk '/Admin Organization:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    adminname=$(echo "$whoisoutput" | awk '/Admin Name:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    adminemail=$(echo "$whoisoutput" | awk '/Admin Email:/ { print $2; exit; }' FS=': ')
    techname=$(echo "$whoisoutput" | awk '/Tech Organization:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    techemail=$(echo "$whoisoutput" | awk '/Tech Email:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    creationdate=$(echo "$whoisoutput" | awk '/Creation Date:/ || /RegDate/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    updatedate=$(echo "$whoisoutput" | awk '/Updated Date:/ || /Updated/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    abusecontactemail=$(echo "$whoisoutput" | awk '/Abuse Contact Email:/ || /OrgAbuseEmail/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    abusecontactphone=$(echo "$whoisoutput" | awk '/Abuse Contact Phone:/ || /OrgAbusePhone/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    dnsserver1address=$(echo "$whoisoutput" | awk '/Name Server:/ { print $2; exit; }' FS=': ' | sed  's/^[t ]*//g;s/[t ]*$//g')
    
    mxrecords=$(echo "$digmxoutput" | awk '/IN.*MX/ && length($7)>1 { print $7; }' FS='[\t ]')
    arecords=$(echo "$digaoutput" | awk '/IN.*A/ && length($6)>1 { print $6; }' FS='[\t ]')
    txtrecords=$(echo "$digtxtoutput" | awk '/IN.*TXT/ && length($6)>1 { print $6; }' FS='[\t ]' | sed  's/^["]*//g;s/["]*$//g') 

    # Step 3 - Use awk to pretty-print the output. There's less info available if the user 
    # supplies the ip address and so the following condition makes sure not to print 
    # empty lines for the unavailable data

    if [[ $2 = "IP" ]]; 
    then
        print_whois_value "Domain Name" $domainname
        print_whois_value "IP Address" $ipaddress
        print_whois_value "Created On" $creationdate
        print_whois_value "Last Updated On" $updatedate
        print_whois_value "Registrant Organization" "$registrantorgname"
        print_whois_value "Registrant Country" $registrantcountry
        print_whois_value "Abuse Contact Email" $abusecontactemail
        print_whois_value "Abuse Contact Phone" $abusecontactphone
    else
        print_whois_value "Domain Name" $domainname
        print_whois_value "IP Address" $ipaddress
        print_whois_value "Created On" $creationdate
        print_whois_value "Last Updated On" $updatedate
        print_whois_value "Registrant Organization" "$registrantorgname"
        print_whois_value "Registrant Country" $registrantcountry
        print_whois_value "Registrant Name" "$registrarname"
        print_whois_value "Registrar URL" $registrarurl
        print_whois_value "Registrar WHOIS Server" $registrarwhoisserver
        print_whois_value "Admin Name" "$adminname"
        print_whois_value "Admin Organization" "$adminorg"
        print_whois_value "Admin Email" "$adminemail"
        print_whois_value "Tech Name" $techname
        print_whois_value "Tech Email" $techemail
        print_whois_value "Abuse Contact Email" $abusecontactemail
        print_whois_value "Abuse Contact Phone" $abusecontactphone
        print_whois_value "DNS Server 1 Address" $dnsserver1address

    fi

    # Step 4 - Print A Records, TXT Records and MX Records if any found

    print_records "$arecords" "A"
    print_records "$txtrecords" "TXT"
    print_records "$mxrecords" "MX"
}



if [ $# -gt 1 -o $# -lt 1 ]
then 
    echo "Error: Only one argument allowed and is required. The expected input for the command is domaininfo {domain name}"
else
    # Step 1.a - Check if the input is an IPv4 address
    if [[ $1 =~ $ipregex ]]; 
    then 
        process_arg "$1" "IP"
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
