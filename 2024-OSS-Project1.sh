#! /bin/bash

if [ $# -ne 3 ] 
then
  echo "usage: $0 file1 file2 file3"
  exit 1
fi

echo "********OSS1 - Project1********"
echo "*    StudentID : 12202051     *"
echo "*    Name : Jang Hyeon Wu     *"
echo "*******************************"
echo


stop="N"
until [ "$stop" = "Y" ]
do 
   
  echo "[MENU]"
  echo "1. Get the data of Heung-Min Son's Current Club, Apperances, Goals, Assists in players.csv"
  echo "2. Get the team data to enter a league position in teams.csv"
  echo "3. Get the Top-3 Attendance matches in matches.csv"
  echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
  echo "5. Get the modified format of date_GMT in matches.csv"
  echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
  echo "7. Exit"
  echo -n "Enter your CHOICE (1-7) : "
  read choice

  case "$choice" in 

    1)
      echo -n "Do you want to get the Heung-Min Son's data? (y/n) : " 
      read res
      
      if [ $res = "y" ]
      then
        cat "$2" | awk -F, '$1=="Heung-Min Son" {printf("Team: %s, Apperance: %d, Goal: %d, Assist: %d\n", $4, $6, $7, $8)}'
      fi 
      ;;
    2)
      echo -n "What do you want to get the team data of league_position[1~20] : "
      read res
      
      cat "$1" | awk -v a=$res -F, '$6==a {print $6, $1, $2/($2+$3+$4)}'
      ;;
    3)
      echo -n "Do you want to know Top-3 attendance data (y/n) : "
      read res

      if [ $res = "y" ]
      then
        echo "***Top-3 Attendance Match***"
        echo 
        cat "$3" | sort -t ',' -n -r -k 2 | head -3 | awk -F, '{printf("%s vs %s (%s)\n%d %s\n\n", $3, $4, $1, $2, $7)}'
      fi
      ;;
    
    4) 
      echo -n "Do you want to get each team's ranking and the highest-scoring player? (y/n) : "
      read res
      echo 

      if [ $res = "y" ] 
      then 
        IFS=$'\n'
        for var in $(cat "$1" | sort -t ',' -n -k 6 | awk -F, 'NR != 1 {print $1}') 
        do 
          rank=$(cat "$1" | awk -v r=$var -F, '$1==r {print $6}')
          info=$(cat "$2" | awk -v a=$var -F, '$4==a {print $7}' | sort -n -r | head -1)

          echo "$rank $var"
          cat "$2" | awk -v t=$var -v m=$info -F, '$4==t && $7==m {print $1, $7}'
          echo 

        done
      fi
      ;;
    
    5)
      echo -n "Do you want to modify the format of date? (y/n) : "
      read res
      if [ $res = "y" ] 
      then
      cat "$3" | awk -F, 'NR != 1 && NR <= 11 {print $1}' | sed -E 's/Jan/01/;s/Feb/02/;s/Mar/03/;s/Apr/04/;s/May/05/;s/Jun/06/;s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/;s/Dec/12/' | awk '{printf("%d/%d/%d %s\n",$3, $1, $2, $5)}'
      echo
        
      fi 
      ;;
    6) 
      echo "1) Arsenal                  11) Liverpool"
      echo "2) Tottenham Hotspur        12) Chelsea"
      echo "3) Machester City           13) West Ham United"
      echo "4) Leicester City           14) Watford"
      echo "5) Crystal Palace           15) Newcastle United"
      echo "6) Everton                  16) Cardiff City"
      echo "7) Burnley                  17) Fulham"
      echo "8) Southhampton             18) Brighton & Hove Albion"
      echo "9) AFC Bournemouth          19) Huddersfield Town"
      echo "10) Machester United        20) Wolverhampton Wanderers"
      echo -n "Enter your team number : "
      read n 
      echo 

      team=$(cat "$1" | awk -v i=$n -F, 'NR==i+1 {print $1}')
      max=$(cat "$3" | awk -v t=$team -F, '$3==t {print $5 - $6}' | sort -n -r | head -1)
      cat "$3" | awk -v t=$team -v m=$max -F, '$3==t && $5-$6==m {printf("%s\n%s %d vs %d %s\n\n", $1, $3, $5, $6, $4)}'
      ;;

    7) 
    echo "Bye!"
    stop="Y"
    ;;
    esac
    echo
done
