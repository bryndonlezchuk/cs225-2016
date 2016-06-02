#!/bin/bash

#Lab 13 - Regular Expressions			Jun 1, 2016
#Bryndon Lezchuk (bryndonlezchuk@gmail.com)

#Objective: Create a script with four functions using BASH's in process regular expressions to check the validity of Social Security numbers, telephone numbers, IP addresses and credit card numbers based on each particular data format.

#    Take a piece of data as an argument and echo back it's type based on the results of these functions.
#    Each function will be named check_ip, check_ssn, check_pn and check_ccn.
#    Each function will take one argument - the data in question
#    Each function will return a message and a 1 or 0 depending on the outcome of the comparison
#    Make sure the script traps control-c and exits
#    Make sure the script prints out help if no argument is given.

source ./library.sh
trap cleanup SIGINT SIGTERM

main () {
	local VAL="${ARGS[1]}"

	echo "====================================="
	verify "ip" "$VAL"
	verify "phone" "$VAL"
	verify "ccn" "$VAL"
	verify "ssn" "$VAL"
	echo "====================================="
}

verify () {
	local OPT="$1"
	local VAL="$2"
	local RESULT

	case "$OPT" in
		#IP address
		ip)		imessage 'IP Address:			'
				verifyipv4 "$VAL"
				RESULT="$?";;
#				verbout "$RESULT";;
		#Phone number
		phone)	imessage 'Phone Number:			'
				verifyphone "$VAL"
				RESULT="$?";;
		#Social security number
		ssn)	imessage 'Social Security Number:		'
				verifyssn "$VAL"
				RESULT="$?";;
		#Credit card number
		ccn)	imessage 'Credit Card Number:		'
				verifyccn "$VAL"
				RESULT="$?";;
	esac

	case "$RESULT" in
		0)	cmessage " TRUE\n" "green";;
		1)	cmessage "FALSE\n" "red";;
	esac
}

while getopts :dvi: OPT
do
	case "$OPT" in
		#Debug
		d)	set -x
			debugon;;
		#Verbose
		v)	verbon;;
		#IP
		i)	intoff
			verify "ip" "$OPTARG";;
		\?)	errormessage "Unkown option"
	esac
done
shift $(($OPTIND-1))

if [[ -z "$1" && "$INTERACTIVE" = "ON" ]]
then
	errormessage "Need an argument"
fi

setup "$@"

if  chkinteractive
then
	main
fi

cleanup



