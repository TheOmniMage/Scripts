#!/bin/bash

#Function to recursively search a directory for specified extensions.

function rsearch() {
        #Funtion to search recursively through current directory.
        files=`find . -type f -name \*.*`
        printf "%s" "$files" > "rsearch_results.txt"
        echo "Finished searching recursively. The output was saved to `pwd` as file rsearch_results.txt"
}

function ersearch() {
        #Function to search recursively while excluding up to five extensions.
        files=`find . -type f -name \*.* | grep -v "$args"`
        printf "%s" "$files" > "rsearch_results.txt"
        echo "Finished searching recursively while excluding those extensions. The output was saved to `pwd` as file rsearch_results.txt"
}

function tsearch() {
        #Function to search through previously obtained rsearch_results.txt file for specific terms.
        while read line; do grep -Hn -i "$args" "$line" 1>> rsearch_termsearch_results_$args.txt; done < "`pwd`/rsearch_results.txt" 
#       echo $result
#       printf "%s" "$result" > "rsearch_termsearch_results.txt"
        echo "Results of searching for string $args saved to rsearch_termsearch_results_$args.txt"
}



function Help() {
        #Display Help
        echo "Script to recursively search a directory for specified extensions, as well as search for specific terms inside previously obtained filenames."
        echo
        echo "Syntax: $0 [-h|r|pw]"
        echo "Options:"
        echo "-h        Print this help message"
        echo "-r        Search recursively, arguments after -r are excluded extensions feed into a 'grep -v' statement."
        echo "-e        Search recursively excluding up to five specified extensions."
        echo "-t        Search for specific term contained within previous results."
}

################MAIN PROGRAM##############
args=( )

while getopts ":hret" option; do
                case $option in
                h) #Display Help
                        Help
                        exit;;
                r) #Search recursively
                        rsearch
                        exit;;
                e) #Search recursively while excluding these extensions from the search
                        if [ -z "$3" ]
                        then
                                args+=("$2") 
                        elif [ -z "$4" ];
                        then
                                args+=("$2\|$3")
                        elif [ -z "$5" ];
                        then
                                args+=("$2\|$3\|$4")
                        elif [ -z "$6" ];
                        then
                                args+=("$2\|$3\|$4\|$5")
                        else
                                echo "Please supply up to five extensions as '.xyz' or use the -r switch."
                        fi
                        ersearch
                        exit;;
                t) #Search through previously obtained results within rsearch_results.txt file for specified term.
                        if [ -z "$3" ]
                        then
                                args+=("$2")
                        elif [ -z "$4" ];
                        then
                                echo "Please supply only one term to search for."
                        fi
                        tsearch
                        exit;;
                \?) #bad option
                        echo "Error: Invalid options."
                        exit;;
        esac
done
