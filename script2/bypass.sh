#! /bin/bash

servers_file=$1

if [[ ! -f "$servers_file" ]]
then
    echo "Error: file $servers_file does not exist."
    exit 1
fi

mapfile -t servers < "$servers_file"

declare -A usernames

for server in "${servers[@]}"
do
    read -p "Enter a username to connect to the server $server: " username
    usernames["$server"]="$username"
done

while true
do
    read -p "Enter the command to run on all servers:" command

    for server in "${servers[@]}"
    do
        echo "Connecting to the server $server"
        
        username=${usernames["$server"]}
        
        echo "Executing a command: $command"
        
        if ssh "$username@$server" "$command"
        then
            echo "The command $command has been successfully executed on the $server"
        else
            echo "An error connecting to the server $server or executing the command $command failed"
        fi
    done

    read -p "Do you want to leave? (y/n):" exit_choice
    if [[ "$exit_choice" == "y" ]]
    then
        echo "Work is ended."
        exit 0
    fi
done