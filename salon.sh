#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
EXIT() {
  echo -e "\nBYEE\n"
}
MAIN_MENU() {
  
  echo -e "\n~~ Barber Salon ~~\n"
  echo -e "\nPick a service:"
  if [[ $1 ]]
  then
  echo $1
  fi
  SERVICES=$($PSQL"SELECT service_id, name FROM services")
  echo "$SERVICES" | sed 's/|/) /'
  echo "e) EXIT"
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL"SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  SERVICE_NAME=$($PSQL"SELECT name FROM services WHERE service_id=$SERVICE_ID")

  if [[ $SERVICE_ID_SELECTED = "e" ]]
  then
  EXIT
  elif [[ -z $SERVICE_ID ]]
  then
  MAIN_MENU "We don't offer that service."
  else
  SERVICE_MENU
  fi
}
SERVICE_MENU() {
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  PHONE=$($PSQL"SELECT phone from customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $PHONE ]]
  then
  echo -e "\nWhat is your name?"
  read CUSTOMER_NAME
  CUSTOMER_RESULT=$($PSQL"INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time?"
  read SERVICE_TIME
  APPOINTMENT_RESULT=$($PSQL"INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
  if [[ $APPOINTMENT_RESULT = 'INSERT 0 1' ]]
  then
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
  else
  CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUSTOMER_NAME=$($PSQL"SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time?"
  read SERVICE_TIME
  APPOINTMENT_RESULT1=$($PSQL"INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
  if [[ $APPOINTMENT_RESULT1 = 'INSERT 0 1' ]]
  then
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
  
  fi
}

MAIN_MENU
