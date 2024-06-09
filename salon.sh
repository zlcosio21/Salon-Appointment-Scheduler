#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"


SERVICES_LIST=$($PSQL "SELECT service_id || ') ' || name FROM services;")
echo "$SERVICES_LIST"
read SERVICE_ID_SELECTED


SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

while [[ -z $SERVICE_NAME ]]; do
  echo -e "\nI could not find that service. What would you like today?\n"
  echo "$SERVICES_LIST"
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
done


echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE


CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

if [[ -z $CUSTOMER_ID ]]; then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  echo "$($PSQL "INSERT INTO customers (phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")"
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
fi


echo -e "\nWhat time would you like your $SERVICE_NAME, $(echo $CUSTOMER_NAME | awk '{print $1}')?"
read SERVICE_TIME


echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | awk '{print $1}')."
echo "$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")"
