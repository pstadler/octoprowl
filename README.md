# Octoprowl

> GitHub + Prowl = Octoprowl

Get [Prowl](http://www.prowlapp.com/) notifications whenever you have a new **follower**, or someone **starred** / **forked** one of your repositories on GitHub.

## Deploying to Heroku

```
# Clone the repository
git clone https://github.com/pstadler/octoprowl.git && cd octoprowl

# Create a new app
heroku create
# Add addons
heroku addons:add scheduler:standard
heroku addons:add redistogo:nano
# Add configuration
heroku config:add feed_url='<github-private-feed-url>' # "News Feed" on the GitHub start page
heroku config:add username='<github-username>'
heroku config:add prowl_api_key='<prowl-api-key>'

# Push to heroku
git push heroku master

# Open the scheduler configuration and create a new task: 'ruby task.rb', every 10 minutes
heroku addons:open scheduler

# Test if the task works...
heroku run ruby task.rb
```

## Running locally

```
# Clone the repository
git clone https://github.com/pstadler/octoprowl.git && cd octoprowl

# Install dependencies
bundle install

# Configuration
export feed_url='<github-private-feed-url>' # "News Feed" on the GitHub start page
export username='<github-username>'
export prowl_api_key='<prowl-api-key>'

# Run it
./task.rb
```

## License
Octoprowl is released under the MIT license.