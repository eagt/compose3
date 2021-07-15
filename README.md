# Creating a Docker-Compose Project from scrach

Create a folder where you want to create your project
`$ mkdir project_name && cd project_name`

Open it on your text editor, in my case
`$ subl .`

Create a Dockerfile in the root of your project
$ touch Dockerfile
Add all what is included in the <b>compose3</b> project in GH or in the <b>compose3</b> in local machine. 
***Note:*** Remember to change the *project_name*

Then Create a <b>docker-compose.yml</b> file in the root of your project
`$ touch docker-compose.yml`
Add all what is included in the <b>compose3</b>  project in GH or in the <b>compose3</b>  in local machine. ***Note:***  Remember to change the *project_name*

Then Create a <b>entrypoint.sh</b> file in the root of your project    
`$ touch entrypoint.sh`. 

```
#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

```

Create some directories to store our environment-specific config: 

`$ mkdir -p .env/development && cd .env/development`

Then create the file inside the <b>.env/development</b> called ***web*** (without a file extension), which contains our web-service-specific environment variables:  

`$ touch web`

Create another file inside the, <b>.env/development</b> called ***db*** (for the database variables), containing those for our database service:  
`$ touch db`

Add all what is included in the <b>compose3</b> project in GH or in the <b>compose3</b>  in local machine.  
***Note:*** Remember to change the name of the application for the POSTGRES_DB or any other if variable.

Create a Gemfile and a Gemfile.lock file at the root of the project    

`$ touch Gemfile.lock`  
`$ touch Gemfile`  

with the following on the Gemfile this case 

```
source 'https://rubygems.org'
gem 'rails', '~> 6.1.4 '

```
***Note:***  You can add the version you need. Leave the Gemfile.lock file empty.  

Run  
`$ docker-compose build`  

Create your application  
`$ docker-compose run --no-deps web rails new . --force --database=postgresql`  

Then adjust the database.yml file similar to what is included in the <b>compose3</b> project in GH or in the <b>compose3</b>  in local machine only the following

```
default: &default
  adapter: postgresql
  encoding: unicode
  host:     <%= ENV.fetch('DATABASE_HOST') %>
  username: <%= ENV.fetch('POSTGRES_USER') %>
  password: <%= ENV.fetch('POSTGRES_PASSWORD') %>
  database: <%= ENV.fetch('POSTGRES_DB') %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  variables:
     statement_timeout: 5000
```

Now, check you’re ready to launch our app    
`$ docker-compose up`  

Installing the newest version of Postgres Gem
Go to Ruby gems and get the pg version you would like to use and change it from the one already there on your Gemfile.   <?php

`$ docker-compose stop`  
`$ docker-compose up -d web`  
`$ docker-compose exec web bundle OR $ docker-compose exec web bundle`  
`$ docker-compose up`  
	
Check on your browser <b>localhost:3000</b>. You should see the Rails message!!

					***Remember***  
Every time you stop/finish working in a project remember to run ***
`$ docker-compose down`


## Creating the DB ##

When you create the first model, you will need to run this   
`$ docker-compose run web rake db:create`
OR  
`$ docker-compose exec web bin/rails db:create db:migrate`  

Now, check you’re ready to launch our app  
`$ docker-compose up`

Check on your browser <b>localhost:3000</b>. You should see the Rails message!! or if you created a model and you go to the index.html for the model you should be able to see it. 


## Bootstrap5 ##

Add bootstrap and dependencies using yarn  

`$ docker-compose run web yarn add bootstrap@next jquery @popperjs/core`  
***Note:*** Jquery is no longer required by Bootstrap5 but I know I’ll need it later so I have added it.

Add the stylesheet_pack_tag to the application.html.erb file. So, go and update the application layout app/views/layouts/application.html.erb.

Create a new directory inside at app/javascript called stylesheets. 
We will then put our stylesheets in here and they will be managed by webpack. 
Create new file inside the <b>app/javascript/stylesheets</b> called <b>application.scss</b>. Inside the file add the following line

`@import "~bootstrap/scss/bootstrap";`

Now, in file <b>app/javascript/packs/application.js</b>, at the bottom of the file, add the following code which will also deal with popovers and tooltips. Add also the require("jquery") as we’ll need it for the ajax calls later in some projects

```

require.context('../images', true)

require("jquery")
// ADDING BOOTSTRAP PART STARTS HERET -- and enable tooltips and popovers everywhere

import * as bootstrap from 'bootstrap'
import "../stylesheets/application.scss"

document.addEventListener("DOMContentLoaded", function(event) {
  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
});
```  

Make sure your <b>config/webpack/environment.js</b> looks like below

``` 
const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide', 
	new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

module.exports = environment

```

Bootstrap should be working now.

You are ready to start working on your project.  

If you add a gem to your Gemfile run  
`$ docker-compose stop`
`$ docker-compose up -d web`
`$ docker-compose exec web bundle install`

If you change any configuration
`$ docker-compose restart web`


##Creating a Model example##

`$ docker-compose exec web bin/rails g scaffold User first_name last_name `  

`$ docker-compose exec web bin/rails db:migrate`  

Re-launch your app
`$ docker-compose up`

Check on your browser localhost:3000.

					***Remember***  
Every time you stop working in a project remember to run
`$ docker-compose down`


## WORKING WITH GITHUB ##

The process to work with git and GitHub still the same. You will commit and push to your repo in GitHub in the same way. If you cloned a repository (docker project in this case) that is on your machine already what you need to do to have it run it as expected is:

Run 
`$ docker-compose build`

`$ docker-compose up`

Check you have the Rails message if it just a plain docker-compose set up or if it has any model already check it is there. Go to

localhost:3000

You are ready to start working on the project

					***Remember***  
Every time you stop/finish working in a project remember to run

`$ docker-compose down`

This will save you time trying to figure out why you cann't initiate a server on another project.

