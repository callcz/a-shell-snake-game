#!/bin/bash
## This is a snake game ,
## Written by callcz in 20220719 .
## Use the number keys to control the direction .
##
#echo $$>pid.txt
##help
if [[ $1 = help || $1 = --help || $1 = '-h' ]]
then
	head -n5 $0
	echo "  Usage : $0 [ --turn or --help ]
  --turn,-t	Turn flip up and down the keys if you want .
  --help,-h	List this help ."
exit
fi
if [[ $1 == '-t' || $1 == --turn ]]
then
	./main_gen_snake.sh $1 $$ &
elif [[ ! $1 ]]
then
	./main_gen_snake.sh null $$ &
else
	./main_gen_snake.sh $1 $$ &
fi
if [[ $2 ]]
then
	puid=$2
else
	puid=`ps -ef|grep main_gen_snake.sh|grep bash|awk '{print $2}'`
fi
if [[ ! $puid || -z $puid ]]
then
	echo "Can't find './main_gen_snake.sh' PUID"
	exit
fi
trap 'handshake=ok' 12
handshake_l(){
	handshake=null
	kill -29 $puid
	sleep 3
	if [[ $handshake != ok ]]
	then
		echo 'handshake fail'
		exit
fi
}
#handshake_l
#echo $puid >puid.txt
trap "kill -10 $puid;echo -en '\033[?25h';exit" 2
while :
do
	read -n 1 -s key
	case $key in
		2)
			kill -25 $puid
			;;
		8)
			kill -26 $puid
			;;
		4)
			kill -27 $puid
			;;
		6)
			kill -28 $puid
			;;
		1)
			kill -21 $puid
			;;
		3)
			kill -22 $puid
			;;
		7)
			kill -23 $puid
			;;
		9)
			kill -24 $puid
			;;
		r)
			check=`ps $puid|awk 'NR==2{print $1}'`
			if [[ -z $check ]]
			then
				if [[ $1 ]]
				then
		                ./main_gen_snake.sh $1 $$ &
				else
				./main_gen_snake.sh null $$ &
				fi
				if [[ $2 ]]
				then
					puid=$2
				else
					puid=`ps -ef|grep main_gen_snake.sh|grep bash|awk '{print $2}'`
				fi
				#handshake_l
			fi
			;;
		q)
			check=`ps $puid|awk 'NR==2{print $1}'`
			if [[ -n $check ]]
			then
				kill -10 $puid
				exit
			else
				exit
			fi
			;;
		t)
			handshake_l
			;;
	esac
	unset key
done

