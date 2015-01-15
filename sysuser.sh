#!/bin/bash
read -p "Enter File name:" fl
count=0;
paswd="sicsr123"
if [ -e $fl ]
then
	line=`wc -l < $fl`;
	while [ $count -lt $line ]
	do
		let count++;
		users=`head -n $count $fl | tail -1 `
		if [ $(id -u) -eq 0 ]; then
			grep "^$users" /etc/passwd > /dev/null
			if [ $? -eq 0 ]; then
				echo "$users exist";
				exit 1;
			else
				pass=$(perl -e 'print crypt($ARGV[0],"password")' $paswd)
				useradd -m -p $pass $users -s /bin/bash
				[ $? -eq 0 ] && echo "$users has been added to system" >> successcreate || echo "Failed to add $users" >> failedcreate;
			fi
		else
			echo "Only root can add";
			exit 2;
		fi	
	done
	echo "Please Check the status in successcreate and failedcreate files";
else
	echo "File doesen't exist";
	exit 3;
fi
