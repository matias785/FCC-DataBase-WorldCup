#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  
  if [[ $WINNER != "winner" || $OPPONENT != "opponent" ]] 
  then 

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")
    if [[ -z $WINNER_ID ]] 
    then
      echo [TEAMS] $($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]] 
    then
      echo [TEAMS] $($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
    fi  

  fi        
done  

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG 
do
  if [[ $WINNER != "winner" || $OPPONENT != "opponent" ]] 
  then 
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT'") 
    echo [GAMES] $($PSQL "insert into games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values ($YEAR, '$ROUND', $W_ID, $O_ID, $WG, $OG)")
  fi        
done  

echo Teams count: $($PSQL "select count(*) from teams")
echo games count: $($PSQL "select count(*) from games")
