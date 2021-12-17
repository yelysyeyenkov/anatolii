#!/bin/bash


#Numbers:
# -eq  equal (==)
# -ne  not equal (!=)
# -lt  less than (<)
# -gt  greater than (>)
# -le  less than or equal (<=)
# -ge  greater than or equal (>=)


#Strings:
# ==
# !=
# -n   (Not NULL)
# -z   (NULL)


#WHILE
: '
for (( i=0; i<10; i++ ))
do
	echo $i
done
: '
: '
for i in {1..10}
do
	echo $i
done
: '
: '
IFS=$'\n'
number=0
for line in  `cat file.txt`
do
	number=$(( $number + 1 ))
	echo "$number) $line"
done
: '

read -p "Enter some name:" name
case $name in
	Andrey|andrey)
			echo "Correct!";;
	[Oo0][kK][sS][aA][nN][aA])
			echo -e "Incorrect!\nYou entered Oksana.";;
	*)
			echo "Default value!";;
esac






