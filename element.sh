#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Get atomic number from argument
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_QUERY="$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number = $1")"
else
  ELEMENT_QUERY="$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE symbol = INITCAP('$1') OR name = INITCAP('$1')")"
fi

if [[ -z $ELEMENT_QUERY ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Read values
IFS="|" read ATOMIC_NUMBER NAME SYMBOL <<< "$ELEMENT_QUERY"
PROPERTIES_QUERY="$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")"
IFS="|" read MASS MELTING BOILING TYPE <<< "$PROPERTIES_QUERY"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
