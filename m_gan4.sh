#!/bin/bash
## old version
## This is a snake game ,
## Written by callcz in 20220719 .
## Use the number keys to control the direction .
##
##help
if [[ $1 = help || $1 = --help || $1 = '-h' ]]
then
	head -n5 $0
	echo "## Usage \"$0 turn or -t\" to turn flip up and down the keys"
	exit
fi
if [[ $1 = turn || $1 = '-t' ]]
then
	turn=1
fi
##Declare global variables
logo_head=■
logo_background=□
logo_body=●
logo_star=★
x_max=20
y_max=20
score=0
go=right
##catch key (signals not implemented)
sig_up=25
sig_down=26
sig_left=27
sig_right=28
sig_re=29
my_exit=2

trap 'go=up' $sig_up
trap 'go=down' $sig_down
trap 'go=left' $sig_left
trap 'go=rigth' $sig_right
trap 'star_l' $sig_re
trap 'my_exit_l' $my_exit

get_key_l(){
	speed_s=$speed
	if [[ ${#speed_s} -lt 4 ]]
	then
		for i in `seq 1 $((4-${#speed_s}))`
		do
			speed_s=0$speed_s
		done
	speed_s=${speed:0:$((${#speed}-3))}.${speed:0-3}
	fi
	while [[ ! $go_w && $((time_old+speed)) -ge $((`date +%s%N`/1000000)) ]]
	do
		read -t "$speed_s" -n 1 key
		printf_l $((y_max+8)) 2 $1
		if [[ $turn = 1 ]]
		then
			case $key in
				2)
					key=8
					;;
				8)
					key=2
					;;
				1)
					key=7
					;;
				3)
					key=9
					;;
				7)
					key=1
					;;
				9)
					key=3
					;;
			esac
		fi
		case $key in
			2)
				if [[ $go != down ]];then go_w=up;fi
				;;
			8)
				if [[ $go != up ]];then go_w=down;fi
				;;
			4)
				if [[ $go != right ]];then go_w=left;fi
				;;
			6)
				if [[ $go != left ]];then go_w=right;fi
				;;
			1)
				if [[ $go = up || $go = down ]];then go_w=left
				elif [[ $go = left || $go = right ]];then go_w=up;fi
				;;
			3)
				if [[ $go = up || $go = down ]];then go_w=right
				elif [[ $go = left || $go = right ]];then go_w=up;fi
				;;
			7)
				if [[ $go = up || $go = down ]];then go_w=left
				elif [[ $go = left || $go = right ]];then go_w=down;fi
				;;
			9)
				if [[ $go = up || $go = down ]];then go_w=right
				elif [[ $go = left || $go = right ]];then go_w=down;fi
				;;
		esac
	done
}
##open a terminal
#施工中

##some function
my_exit_l(){
echo -e '\033[?25h'
exit
}
cls_l(){
echo -e '\033c'
echo -e '\033[?25l'
}
cls_l
#backgrond
backgrond_l(){
for i in `seq 1 $((x_max*y_max))`;do
	field_x=$((i%x_max))
	if [[ $field_x -eq 0 ]];then
		field_x=$x_max
	fi
	field_y=$(($(($((i-1))/x_max))+1))
	echo -ne "\033[${field_y};${field_x}H${logo_background}"
done
}
#star point
star_l(){
	star_x=$[RANDOM%$x_max+1]
	star_y=$[RANDOM%$y_max+1]
	star_xy="$star_x,$star_y"
	for i in ${body_xy[@]}
	do
		if [[ $star_xy == $i ]]
		then
		star_l
		fi
	done
	echo -ne "\033[${star_y};${star_x}H${logo_star}"
}
#print something
printf_l(){
	printf "\033[$1;$2H""$3"
}
score_l(){
	if [[ $head_xy = $star_xy ]];then
		score=$((score+1))
		star_l
	fi
}
#snake go
head_x=$[RANDOM%$x_max+1]
head_y=$[RANDOM%$y_max+1]
head_xy="$head_x,$head_y"
snake_l(){
	body_x=($head_x ${body_x[@]})
	body_y=($head_y ${body_y[@]})
		body_x_d=(${body_x[@]:0:$((score+1))})
		body_y_d=(${body_y[@]:0:$((score+1))})
			body_x_d=${body_x_d[@]:0-1:1}
			body_y_d=${body_y_d[@]:0-1:1}
		body_x=(${body_x[@]:0:$score})
		body_y=(${body_y[@]:0:$score})
	body_xy=($head_xy ${body_xy[@]})
	body_xy=(${body_xy[@]:0:$score})
	if [[ $go_w ]]
	then
		go=$go_w
		unset go_w
	fi
		case $go in
			up)
				head_y=$((head_y-1))
				;;
			down)
				head_y=$((head_y+1))
				;;
			left)
				head_x=$((head_x-1))
				;;
			right)
				head_x=$((head_x+1))
				;;
		esac
	if [[ $head_x -lt 1 ]];then head_x=$x_max
	elif [[ $head_x -gt $x_max ]];then head_x=1
	elif [[ $head_y -lt 1 ]];then head_y=$y_max
	elif [[ $head_y -gt $y_max ]];then head_y=1
	fi
	head_xy="$head_x,$head_y"
	echo -ne "\033[${head_y};${head_x}H${logo_head}"
	if [[ $go ]]
	then
		echo -ne "\033[${body_y_d};${body_x_d}H${logo_background}"
	fi
	for i in `seq 0 $((${#body_xy[@]}-1))`
	do
		echo -ne "\033[${body_y[$i]};${body_x[$i]}H${logo_body}"
	done
}

#Hit self game over
game_over_l(){
	for i in ${body_xy[@]}
	do
		if [[ $head_xy == $i ]]
		then
		for i in `seq 0 $((${#body_xy[@]}-1))`
		do
			echo -ne "\033[${body_y[$i]};${body_x[$i]}H${logo_background}"
			sleep 0.1
		done
			echo -ne "\033[${head_y};${head_x}H${logo_background}" 
			sleep 0.5
		printf_l $(($((y_max/2))-2)) $((x_max/4)) '|------------------------|'
		printf_l $(($((y_max/2))-1)) $((x_max/4)) '|     Touch Youself      |'
		printf_l $((y_max/2)) $((x_max/4)) '|       Game over        |'
		printf_l $(($((y_max/2))+1)) $((x_max/4)) '|    You Score is '$score'     |'
		printf_l $(($((y_max/2))+2)) $((x_max/4)) '|------------------------|'
		printf_l $((y_max+2)) 1 '∑三三三⊂ (っゝд・)っ      '
		printf_l $((y_max+3)) 1 
		printf_l $((y_max+3)) 1 
		my_exit_l
		fi
	done
}
#speed ms
speed_al=300
speed=$speed_al
time_old=$((`date +%s%N`/1000000))

##drawing anything
backgrond_l
star_l
while :
do	
#	printf_l $((y_max+3)) 2 $time_old
#	printf_l $((y_max+4)) 2 `date +%s%N`
	get_key_l
#	printf_l $((y_max+5)) 2 go=$go'       '
#	printf_l $((y_max+6)) 2 go_w=${go_w[@]}'         '
#	printf_l $((y_max+7)) 2 speed_s=$speed_s
	if [[ $((time_old+speed)) -le $((`date +%s%N`/1000000)) ]]
	then
		snake_l
		score_l
		if [[ $speed -gt 100 ]]
		then
			speed=$((speed_al-$((score*15))))
		else
			speed=100
		fi
		game_over_l
#		printf_l 3 $((x_max+2)) $$
		printf_l $((y_max+2)) 2 score=$score
#		printf_l $((y_max+3)) 2 speed=$speed
#		printf_l $((y_max+8)) 2 ${body_y[@]}~~~${body_x[@]}
		time_old=$((`date +%s%N`/1000000))
	fi
done
my_exit_l
