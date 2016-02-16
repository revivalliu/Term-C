#Term-C

Our app on Heroku:

https://term-c.herokuapp.com/

ruby version : 2.0.0
rails version: 4.2.2

## Postgres setup
Note: As for Mac, follow the tutorials on:
http://www.tunnelsup.com/setting-up-postgres-on-mac-osx
1. Install the postgres database server.
2. Create a Postgres user. 
However, instead of "myapp" create a user named "termc"
   
3. run the command:  
    
    rake db:setup
    
4. If all goes well, you should should be able to run the command 
    
    $rails dbconsole
    
    =>\dt
    
And see the schema_migrations table

 Schema |       Name        | Type  | Owner
--------+-------------------+-------+-------
 public | schema_migrations | table | termc
(1 row)


## Deploying to Heroku
1. View your remotes:

   git remote -v
   
Do you see?
heroku  https://git.heroku.com/term-c.git (fetch)
heroku  https://git.heroku.com/term-c.git (push)
origin  git@github.com:robinsswei/Term-C.git (fetch)
origin  git@github.com:robinsswei/Term-C.git (push)

2. If not, add the Heroku remote:
~/667-workspace/Term-C$ heroku git:remote -a term-c

3. To deploy:

   git push heroku master

## Pusher
App name: normal-duck-129

## Developing Facebook Apps on Heroku
Instructions: https://devcenter.heroku.com/articles/facebook

Following the tutorial, I created a Facebook App which works locally.
(App Name: Term-C-dev ,Site URL: http://localhost:3000/)

We still need to create another Facebook App when deploying on Heroku.

Test Users List:
https://docs.google.com/spreadsheets/d/1vV0F46ov9ijSFP0OxbrY6h7mDD1CSYUyPDJHa-DAgek/edit?usp=sharing

