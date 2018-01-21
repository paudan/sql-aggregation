sudo apt-get install postgresql-plpython
sudo apt-get install postgresql-plr

sudo su - postgres
psql -c "CREATE DATABASE test_procedures WITH ENCODING 'UTF8' TEMPLATE template0"
