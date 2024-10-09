#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  #create a variable for winning team
  WINNING_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  #create a varaible for opponent team
  OPONNET_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
  
  #if statement to check so WINNER i not equal to headline "winner"
  if [[ $WINNER != "winner" ]]
  then
    #check if WINNING_TEAM is NULL
    if [[ -z $WINNING_TEAM  ]]
    then
      #insert team into teams table
      INSERT_WINNING_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      #if INSERT_TEAM is sussessfull "(INSERT 0 1)" echo statement
      if [[ $INSERT_WINNING_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $WINNER
      fi
    fi
  fi
  
  #if statemet to check so OPPONENT is not equal to headline "opponent"
  if [[ $OPPONENT != "opponent" ]]
  then
    #check if OPPONENT_TEAM is NULL
    if [[ -z $OPPONENT_TEAM ]]
    then
      #insert team into teams tabele
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      #if a team is successfully inserted echo it to the terminal
      if [[ $INSERT_OPPONENET_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $OPPONENT
      fi
    fi
  fi

  #create variables for winner_id and opponent_id
  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  #check whether TEAM_ID_W and TEAM_ID_O is not null
  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
  then
    #insert data into games table
    #exclude the headlines
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS)")

      #if successfully inserted data into games table echo it to the terminal
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Data inserted into games table
      fi    
    fi
  fi
done
