#!/usr/bin/bash

PROGRAM="psql"
if ! command -v ${PROGRAM} >/dev/null; then

echo -e "\nBASH SCRIPT TO INSTALL AND SETUP POSTGRESQL DATABASE\n"
sleep 1

echo -e "\nINSTALLING PREREQUISITE SOFTWARE PACKAGES\n"
sudo apt install wget ca-certificates



echo -e "\nUPDATING PACKAGE REPOSITORY\n"

sudo apt update -y


echo -e "\nINSTALLING POSTGRESQL\n"
sudo apt install -y postgresql postgresql-contrib

echo -e "\nCHECK POSTGRESQL VERSION\n"
psql -V

else

echo -e "\nPOSTGRESQL IS INSTALLED\n"
fi

read -er -p "PLEASE ENTER A USERNAEM FOR THR NEW DATABASE: " DB_USER
sleep 1

read -er -p "PLEASE ENTER A NAME FOR THE NEW DATABASE: " DB_NAME
sleep 1
read -er -p "PLEASE ENTER A PASSWD FOR THE DATABASE USER:" DB_USER_PWD



echo -e "\nSET-UP USER AND PASSWOPRD FOR DATABASE WITH FULL PRIVILEGE TO THE DATABASE\n"

sudo su postgres <<EOF
createdb $DB_NAME;
psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_USER_PWD';"
psql -c "grant all privileges on database $DB_NAME to $DB_USER;"
echo "Postgres User '$DB_USER' and database '$DB_NAME' created."
EOF

echo -e "\nDATABASE SET SUCCESSFULLY\n"


LISTEN_ADDRESSES="listen_addresses = 'localhost'"
echo -e "\nPOSTGRESQL CONGIFURATION FILE\n"
sudo sed -i "/^#$LISTEN_ADDRESSES/ c$LISTEN_ADDRESSES" /etc/postgresql/14/main/postgresql.conf

sudo sed "s/localhost/*/g" /etc/postgresql/14/main/postgresql.conf


echo -e "\nACCESSING AND EDITING POSTGRESQL ACCESS POLICY CONGIFURATION FILE\n"
sudo echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/14/main/pg_hba.conf

echo "-----------------------------------------------"

echo -e "\nRESTART POSTGRESQL SERVICE\n"
sudo systemctl restart postgresql
sudo systemctl status postgresql

ss -nlt | grep 5432

exit 1




