# Random Lunch

Send mail at random at 12 o'clock

## Installation

    $ bundle
    $ foreman

Use cron addon if you want to deploy to heroku.

    $ heroku addons:add sendgrid:starter
    $ heroku scale web=0 clock=1
