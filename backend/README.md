# Family Budget backend

## Creating venv

Run this command in terminal
```bash
python -m venv venv
```
And then to activate venv run this 
```bush
.\venv\Scripts\activate
```

## Installing modules

Install all modules from requirements.txt
```bush
python -m pip install -r requirements.txt
```

## Configere database

Open ```app.yml``` file and change there database name here
```yml
SQLALCHEMY_DATABASE_URI: 'mysql://{0}:{1}@localhost/YOUR_DB_NAME'
```

and in this file also change mysql username and password
```yml
MYSQL_ROOT_USER: username
MYSQL_ROOT_PASSWORD: password
```

## Running server

And now you have all what you need to run your server

To do this you need just to run app.py

If you are using vscode you can just press ```F5``` to run with debuger or ```CTRL+F5``` to run without debuger anywhere in this poject.