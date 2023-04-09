#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"
SQL_QUERY="SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
SQL_QUERY+=" FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE "
ELEMENT=$1
if [[ -z $ELEMENT ]]
then
  echo "Please provide an element as an argument."
else  
  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    if [[ ${#ELEMENT} > 2 ]]
    then
      SQL_QUERY+=" name = initcap('$ELEMENT')"
    else
      SQL_QUERY+=" symbol = initcap('$ELEMENT')"
    fi
  else
    SQL_QUERY+=" atomic_number = $ELEMENT"
  fi
  ELEMENT_DATA=$($PSQL "$SQL_QUERY")
  if [[ ! -z $ELEMENT_DATA ]]
  then
    echo -e "$ELEMENT_DATA" | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELTING BAR BOILING
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi