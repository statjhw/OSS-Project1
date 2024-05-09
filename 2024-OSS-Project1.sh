#! /bin/zsh

if [ $# -ne 3 ] 
then
  echo "usage: $0 file1 file2 file3"
  exit 1
fi

echo "********OSS1 - Project1********"
echo "*    StudentID : 12202051     *"
echo "*    Name : Jang Hyeon Wu     *"
echo "*******************************"


stop="N"
until [ "$stop" = "Y" ]
do 
  echo "MENU"
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
        cat "$2" | awk -F, '$1=="Heung-Min Son" {printf("Team: %d, Apperance: %d, Goal: %d, Assist: %d\n", $4, $6, $7, $8)}'
      fi 
      ;;
    2)
      echo -n "What do you want to get the team data of league_position[1~20] : "
      read res
      
      cat "$1" | awk -v a=$res -F, '$6==$a {print $6, $1, $2/($2+$3+$4)}'
      ;;

