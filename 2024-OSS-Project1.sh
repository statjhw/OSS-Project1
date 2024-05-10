#! /bin/zsh

if [ $# -ne 3 ] 
then
  echo "usage: $0 file1 file2 file3"
  exit 1
fi

echo "********OSS1 - Project1********"
echo "*    StudentID : 12202051     *"
echo "*    Name : Jang Hyeon Wu     *"
echo "*******************************\n"


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
      echo -n "Do you want to get the Heung-Min Son's data? (y/n) :" 
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
      echo -n "Do you want to know Top-3 attendance data and average attendance? (y/n) : "
      read res

      if [ $res = "y" ]
      then
        echo "***Top-3 Attendance Match***"
        echo 
        cat "$3" | sort -t ',' -n -r -k 2 | head -3 | awk -F, '{printf("%s vs %s (%s)\n%d %s\n\n", $3, $4, $1, $2, $7)}'
      fi
      ;;
    4)
      for i in $ (seq 1 20)
      do
        team=$(cat "$1" | awk -v rank=$i -F, '$6==rank {print $1}')
        echo "$i $team"
        pg=$(cat "$2" | awk -v a=$team -F, '$4==a {print $1, $7}' | sort -r -k 2)
      done  
      ;;
    
    5) 
      echo - n "Do you want to modify the format of date? (y/n) : "
      read res

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
