#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  # Check if an argument is provided
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    exit 0
  fi

  ELEMENT_INPUT=$1

  # Determining if the input is a number
  if [[ $ELEMENT_INPUT =~ ^[0-9]+$ ]]
  then
    QUERY_CONDITION="atomic_number=$ELEMENT_INPUT"
  else
    QUERY_CONDITION="name='$ELEMENT_INPUT' OR symbol='$ELEMENT_INPUT'"
  fi

  # Query to get details
  ELEMENTS_READ=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $QUERY_CONDITION")

  # Check if the input exists
  if [[ -z $ELEMENTS_READ ]]
  then
    echo "I could not find that element in the database."
  else
  # If it exists read the query
    echo "$ELEMENTS_READ" | while IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
  # Reading the element
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
