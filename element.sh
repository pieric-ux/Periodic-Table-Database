#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  if [[ ! $1 ]]
    then
      echo Please provide an element as an argument.
  else
    if [[ $1 =~ ^[0-9]+$ ]]
      then
        ELEMENT_SELECTED=$($PSQL "
          SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements 
          INNER JOIN properties USING(atomic_number) 
          INNER JOIN types USING(type_id)
          WHERE elements.atomic_number = $1
        ")
      else
        ELEMENT_SELECTED=$($PSQL "
          SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements 
          INNER JOIN properties USING(atomic_number) 
          INNER JOIN types USING(type_id)
          WHERE symbol = '$1' OR name = '$1'
        ")
    fi
    
    if [[ -z $ELEMENT_SELECTED ]]
      then
        echo I could not find that element in the database.
    else
      echo $ELEMENT_SELECTED | while IFS=" |" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
        do
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
        done
    fi
  fi
