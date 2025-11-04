#! /bin/bash

# Den Terminal in den Steuerzeichenmodus versetzen
#stty -echo
#stty -icanon

clear
# crig - helferlein für rigctl/hamlib
# source language.sh
# source deutsch.sh

declare -A language
#language[foo]=bar
#echo "${language[foo]}"
#exit

if [ $(echo $LANG|cut -c -2) == "de" ]
then
language[yourinput]="Du hast eingegeben"
language[firstmessage]="\033[1;37mcrig\033[0m - Helferlein für rigctl/hamlib\n\r"
language[menu]="mögliche Kommandos:\r\n
s  - Statusabfrage\r\n
c  - COMP - Kompressor ein/aus\n\r
t  - Tuner - Tuner ein/aus\n\r
'T  - TUNE - tuning\n\r
p  - Power - Power 5W/100W\n\r
'P  - Power - prozentuale eingabe 5-99W\n\r
w  - Squelch - open/close(9/10) \n\r
v  - AF LEVEL - 0.05/0.2\n\r
'V -  AF - Prozent AF Lautstärke\n\r
a  - ANT 1/2\n\r
0  - VFOA/VFOB\n\r
1  - MEM - Memory 1\n\r
2  - MEM - Memory 2\n\r
3  - MEM - Memory 3\n\r
4  - MEM - Memory 4\n\r
+  - MEM - Multi/Memory up \n\r
-  - MEM - Multi/Memory down\n\r

\n\r
 === Eingabe \n\r"

fi

if [ $(echo $LANG|cut -c -2) == "en" ]
then
language["yourinput"]="your input"
language["firstmessage"]="crig - helping tool for rigctl/hamlib"
language["menu"]="possible input:\r\n
s  - status\r\n
c  - COMP - on/off\n\r
t  - TUNER - on/off\n\r
'T -  TUNE - tuner on and tuning \n\r
p  - RFPOWER - 5W/100W\n\r
'P  - Power - input in percent 5-99W\n\r
w  - SQL - off(0)/on(0.9)\n\r
v  - AF switch - 0.05/0.2\n\r
'V -  AF enter in percent\n\r
a  - ANT 1/2\n\r
0  - VFOA/VFOB\n\r
1  - MEM - Memory 1\n\r
2  - MEM - Memory 2\n\r
3  - MEM - Memory 3\n\r
4  - MEM - Memory 4\n\r
+  - MEM - Multi/Memory up \n\r
-  - MEM - Multi/Memory down\n\r
\r
 === Eingabe \n\r"

#### then  echo
fi

# funktonen
function rig() {
#1 model (2,1034)
#2 command (l,L,U,u)
#2 parameter 1  (RFPOWER,SQL)
#3 parameter 2 ( 1/0/0-1)
status[0]=$(rigctl -m u SQL)
status[1]=$(rigctl -m$0 $1 $2)
status[2]=$(rigctl -m u SQL)

}



# beginn programm
echo -e -n "\033[0m"
echo -e -n ${language["firstmessage"]}
echo -e -n ${language["menu"]}
read -rsn1 -p ":  " userinput
echo

# ABFRAGE
#if [ $in == 'c' ]
#    echo "c"
#    then rigctl -m2 "U COMP 0"
#    then rigctl -m2 "u COMP"
#elif [ $in == 't' ]
#    echo "t"
#    then rigctl -m2 "U TUNER 0"
#else echo "Abbruch."
#fi



case $userinput in
    s)
      ### STATUS
      echo -e "\n\rStatus abfrage:"
      echo -e -n "\033[0m COMP  :  \033[0;34m"
      status=$(rigctl -m2 u COMP)
if [ $status == "0" ];then echo $status - off;fi
if [ $status == "1" ];then echo $status - on ;fi
      echo -n -e "\033[0m TUNER :  \033[0;31m"
      stattuner=$(rigctl -m2 u TUNER)
if [ $stattuner == "0" ];then echo $stattuner - off;fi
if [ $stattuner == "1" ];then echo $stattuner - on ;fi
      echo -n -e "\033[0m RFPOWER :  \033[1;33m"
      watt=$(rigctl -m2 l RFPOWER)
#      echo w1: $w1
#      watt= expr $w1 \* 100
#      watt=$(printf "$w2" "$text")
      echo -n -e $watt"\033[0m*100 Watt\n\r"
      echo -n -e "\033[0m SQL - off(0)/on(0.9) :  \033[0;33m"
      rigctl -m2 l SQL
      echo -n -e "\033[0m AF LEVEL - 0.05/0.2 :  \033[0;33m"
      rigctl -m2 l AF
      antstatus=$(rigctl -m2 w "AN;"|tr -d '\0')
      echo -n -e "\033[0m antenna full status:" $antstatus "antenna: "${antstatus:2:1}

      echo -e "\033[0;31m"
      echo -e "\033[0m"

      echo Taste drücken
      read -rsn1
      ;;
    c)
      thiscase=COMP
      echo -e "\r\r  "${language[yourinput]}": c - für COMP\r\r"
      cstat=$(rigctl -m2 u COMP)
      echo "COMP status :  " $cstat
      echo now switching
      rigctl -m2 U COMP "$(( ! cstat ))"
      cstat=$(rigctl -m2 u COMP)
      echo "COMP status :  " $cstat
      sleep 1
      ;;
    t)
      thiscase=TUNER
      echo -e "\r\r  "${language[yourinput]}": t - TUNER\r\r"
      status=$(rigctl -m2 u TUNER)
      echo "TUNER status:" $status
      echo now switching
      rigctl -m2 U TUNER "$(( ! status ))"
      status=$(rigctl -m2 u TUNER)
      echo "TUNER status :" $status
      sleep 1
      ;;
    T)
      thiscase=TUNE
      echo -e "\r\r  "${language[yourinput]}": t - TUNE\r\r"
      status=$(rigctl -m2 u TUNE)
      echo "TUNER status:" $status
      echo now switching
      rigctl -m2 G TUNE
      status=$(rigctl -m2 u TUNER)
      echo "TUNER status :" $status
      sleep 1
      ;;
    q)
      echo "Programmende"
      exit 0;;
    p)
      thiscase=RFPOWER
      echo -e "\r\r  "${language[yourinput]}": p - Power\r\r"
      status=$(rigctl -m2 l RFPOWER)
      echo "RFPOWER status:" $status
      echo now switching
      if (( $(echo "$status < 1" | bc -l) ));   then rigctl -m2 L RFPOWER 1; fi
      if (( $(echo "$status > 0.05" | bc -l) )); then rigctl -m2 L RFPOWER 0.1; fi
      status=$(rigctl -m2 l RFPOWER)
      echo "RFPOWER status :" $status
      sleep 1
      ;;
    w)
      thiscase=SQL
      tc=SQL
      echo -e "\r\r  "${language[yourinput]}": w - Squelch\r\r"
      status=$(rigctl -m2 l SQL)
      echo $thiscase" old status:" $status
      if (( $(echo "$status < 1" | bc -l) ));   then rigctl -m2 L SQL 1; fi
      if (( $(echo "$status > 0.1" | bc -l) )); then rigctl -m2 L SQL 0; fi
      echo now switching
      status=$(rigctl -m2 l SQL)
      echo $tc" new status :" $status
    ;;
    W)
      thiscase=SQL
      tc=SQL
      echo -e "\r\r  "${language[yourinput]}": w - Squelch\r\r"
      status=$(rigctl -m2 l SQL)
      echo $thiscase" old status:" $status
      echo "Enter the percent of your SQL Level"
      read -n2 -p "(only 2char)" sqllev1
      if [[ "$sqllev1" =~ ^[0-9][0-9]$ ]]; then
        echo "new SQL size is "$sqllev1
      status=$(rigctl -m2 L SQL "0."$sqllev1)
      else
        echo "only 2char numbers allowed"
        echo "you entered :  >>" $aflev1"<<"
      read -n1 -p "press any key"
      fi

      echo now switching
      status=$(rigctl -m2 l SQL)
      echo $tc" new status :" $status
      sleep 3
      ;;
    v)
      thiscase=AF
      echo -e "\r\r  "${language[yourinput]}": v - $thiscase\r\r"
      status=$(rigctl -m2 l AF)
      echo "AF status:" $status
      echo now switching
      if (( $(echo "$status < 0.06" | bc -l) )); then rigctl -m2 L AF 0.15; fi
      if (( $(echo "$status > 0.06" | bc -l) )); then rigctl -m2 L AF 0.05; fi
      status=$(rigctl -m2 l AF)
      echo "AF status :" $status
      sleep 1
      ;;
    V)
      thiscase=AF
      echo -e "\r\r  "${language[yourinput]}": v - $thiscase\r\r"
      status=$(rigctl -m2 l AF)
      echo "AF status:" $status
      echo "Enter the percent of your AF/Volume Level"
      read -n2 -p "(only 2char)" aflev1
      if [[ "$aflev1" =~ ^[0-9][0-9]$ ]]; then
        echo "new AF/Volume size is "$aflev1
      status=$(rigctl -m2 L AF "0."$aflev1)
      
      else
        echo "only 2char numbers allowed"
        echo "you entered :  >>" $aflev1"<<"
      read -n1 -p "press any key"
      #cr
      fi


      status=$(rigctl -m2 l AF)
      echo "AF status :" $status
      sleep 1
      ;;
    a)
      thiscase=ANT
      echo -e "\r\r  "${language[yourinput]}": s - $thiscase - Squelch\r\r"
      status=$(rigctl -m2 w "AN;"|tr -d '\0')
      echo $thiscase" status:" $status "antenna: "${status:2:1}
      echo now switching
      if [[ ${status:2:1} == 2 ]]; then rigctl -m2 W "AN100;"; fi
      if [[ ${status:2:1} == 1 ]]; then rigctl -m2 W "AN200;"; fi
      status=$(rigctl -m2 w "AN;"|tr -d '\0')
      echo $thiscase" status :" $statuss "antenna: "${status:2:1}
      sleep 1
      ;;

    m)
      thiscase=MEM
      echo -e "\r\r  "${language[yourinput]}": m - MEM\r\r"
      statusvfo=$(rigctl -m2 v)
      echo "MEM status:" $statusvfo - $statusmem
      echo now switching
      rigctl -m2 V MEM
      status=$(rigctl -m2 v)
      echo "MEM status:" $status
      sleep 1
      ;;
    0)
      thiscase=VFO
      echo -e "\r\r  "${language[yourinput]}": 0 - VFO\r\r"
      statusvfo=$(rigctl -m2 v)
      echo "MEM status:" $statusvfo - $statusmem
      echo now switching
      if [ $statusvfo == "MEM" ]; then rigctl -m2 V VFOA; fi
      if [ $statusvfo == "VFOA" ]; then rigctl -m2 V VFOB; fi
      if [ $statusvfo == "VFOB" ]; then rigctl -m2 V VFOA; fi
      status=$(rigctl -m2 v)
      echo "MEM status:" $status
      sleep 1
      ;;
    1)
      thiscase=MEM.1
      echo -e "\r\r  "${language[yourinput]}": 1 - Memory CH 01\r\r"
      statusvfo=$(rigctl -m2 v)
      statusch=$(rigctl -m2 e)
      echo "MEM status:" $statusvfo - $statusmem
      echo now switching
      rigctl -m2 V MEM;
      rigctl -m2 E 01
      status=$(rigctl -m2 e)
      echo "MEM status:" $status
      sleep 1
      ;;
    2)
      thiscase=MEM.2
      echo -e "\r\r  "${language[yourinput]}": 2 - Memory CH 02\r\r"
      statusvfo=$(rigctl -m2 v)
      status=$(rigctl -m2 e)
      echo "MEM status:" $statusvfo - $statusmem
      echo now switching
      rigctl -m2 V MEM;
      rigctl -m2 E 02
      status=$(rigctl -m2 e)
      echo "MEM status:" $status
      sleep 1
      ;;
    3)
      thiscase=MEM.3
      echo -e "\r\r  "${language[yourinput]}": 3 - Memory CH 03\r\r"
      status=$(rigctl -m2 e)
      statusvfo=$(rigctl -m2 v)
      echo "MEM status:" $statusvfo - $statusmem
      echo now switching
      rigctl -m2 V MEM;
      rigctl -m2 E 03
      status=$(rigctl -m2 e)
      echo "MEM status:" $status
      sleep 1
      ;;
    4)
      thiscase=MEM.4
      echo -e "\r\r  "${language[yourinput]}": 4 - Memory CH 04\r\r"
      statusvfo=$(rigctl -m2 v)
      status=$(rigctl -m2 e)
      echo "MEM status:" $statusvfo - $statusmem
      echo now switching
      rigctl -m2 V MEM;
      rigctl -m2 E 04
      status=$(rigctl -m2 e)
      echo "MEM status:" $status
      sleep 1
      ;;
#    $'\e')  # Escape-Zeichen#
#            read -rsn2 rest  # die nächsten zwei Zeichen lesen
#            input+="$rest"   # restliche Zeichen hinzufügen
#            case "$input" in
#                $'\e[A')  # Cursor hoch
#                    echo "Cursor hoch gedrückt!"
#                    ;;
#                $'\e[B')  # Cursor runter
#                    echo "Cursor runter gedrückt!"
#                    ;;
#                 *)
#                    echo "Andere Escape-Sequenz: $input"
#                    ;;
#            esac
      
    +)
      thiscase=UP
      echo -e "\r\r  "${language[yourinput]}": UP\r\r"
      echo now switching
      rigctl -m2 G UP
      sleep 1
      ;;
    -)
      thiscase=DOWN
      echo -e "\r\r  "${language[yourinput]}": DOWN\r\r"
      echo now switching
      rigctl -m2 G DOWN
      sleep 1
      ;;
    *)
      echo "ungültig"
      echo Taste drücken
      read -n1
      ;;
esac

# echo $deutsch
#      echo Taste drücken
#      read -n1
#stty echo
#stty sane


# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

cr
