#!/bin/bash
# The script which creating users from text document with specific params
echo "-------------------------Script for creating users---------------------------------"
echo -e "\n"
echo "Text document which contains users should be placed in directory src"

read -p "Enter name of the file which contains users with params: " FILE_USERS
USERS_PATH="./src/$FILE_USERS"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [[ -f $USERS_PATH ]]; then
	IFS=$'\n'
	for LINE in `(cat $USERS_PATH)`
	do

		username=`echo "$LINE" | cut -d ":" -f1`
		user_group=`echo "$LINE" | cut -d ":" -f2`
		user_password=`echo "$LINE" | cut -d ":" -f3`
		ssl_password=`openssl passwd -1 "$user_password"`
		user_shell=`echo "$LINE" | cut -d ":" -f4`
		if ! grep -q $username "/etc/passwd"; then
			echo "$username not found!"
			read -p "Do you want to create a new user $username? [yes/no]" ANS_NEW
			case $ANS_NEW in
				[yY][yY][eE][sS])
					if [[ `grep $user_group /etc/group` ]]; then
						echo "Group $user_group already exists in the system"
						useradd $username -s $user_shell -m -g $user_group -p $ssl_password
					else
						echo "Group $user_group doesn't exist in the system!\n It will be create!"
						groupadd $user_group
						useradd $username -s $user_shell -m -g $user_group -p $ssl_password
					fi
					echo "User $username was created!\n"
					;;
				[Nn][nN][oO])
			esac
		elif [[ `grep $username "/etc/passwd"` ]]; then 
			exist_group= `id -gn $username`
			echo -e "I ${RED}$username${NC}: group - ${GREEN}$user_group${NC}; password - ${YELLOW}$user_password${NC}; shell - $user_shell ; was found in system!"
			read -p "Do you want to make some changes for $username? (yes/no): " ANS_CHANGES
			case $ANS_CHANGES in
				[Yy]|[Yy][Ee][Ss])
			 		if [[ $exist_group == $user_group ]]; then
						echo "$username already exists in group $user_group";
						echo "Group $user_group for $username was changed!"
					else 
						read -p "Do you want to change $exist_group on $user_group: [y/n]" ANS_GROUP
						case $ANS_GROUP in
							[Yy]|[Yy][Ee][Ss])
								usermod -g $user_group $username;;
							[Nn][nN][oO])
								echo "Group $exist_group was not changed!" ;;
							*)
								echo "Please enter correct values! [y/n]" ;;
						esac
					fi
					;;
				[Nn]|[Nn][Oo])
					echo "Changes of user $username will be skipped!";;
				*)
					echo "You need to enter only [yes/no]!!!";;
			esac 
		fi
	done
else
	echo "$FILE_USERS doesn't exist"
	echo "You need to create a new file!"
fi
