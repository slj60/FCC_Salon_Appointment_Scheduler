#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~ SALON ~~\n"

MAIN_MENU() {
  SERVICES=$($PSQL "SELECT * FROM services")
  echo -e "Choose a Service:\n"
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  if [[ -z $SERVICE_ID_SELECTED || $SERVICE_ID_SELECTED < 0 || $SERVICE_ID_SELECTED > 3 ]]
  then
    echo "Invalid Option"
    MAIN_MENU
  else
    SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo "Please enter your phone number:"
    read CUSTOMER_PHONE

    PHONE_NUMBER_CHECK=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $PHONE_NUMBER_CHECK ]]
    then
      echo "Unknown Phone Number. Please Enter a name to register:"
      read CUSTOMER_NAME
      INSERT_PHONE_NAME_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customer WHERE phone='$CUSTOMER_PHONE'")
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    echo "Please Enter a time:"
    read SERVICE_TIME

    INSERT_APPOINTMENT_CHECK=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo "I have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

MAIN_MENU
