# masutaka metrics

Post masutaka metrics to GrowthForecast

* [feedly](https://feedly.com/)
* [Hatena::Bookmark](http://b.hatena.ne.jp/)
* [Live Dwango Reader](http://reader.livedoor.com/)

## for development

### Require

* [GrowthForecast](http://kazeburo.github.io/GrowthForecast/)

### Setup

    $ cp config/settings.example.yml config/settings.yml

Modify config/settings.yml

### Clockwork

Create an awesome GitHub feed

    # Start
    $ bundle exec clockwork clockwork.rb

    # Start daemon
    $ export NRCONFIG=`pwd`/config/newrelic.yml
    $ bundle exec clockworkd -c clockwork.rb --log start

    # Stop daemon
    $ bundle exec clockworkd -c clockwork.rb --log stop

## Automatic deployment

When any commits are pushed to master, [CircleCI will deploy to masutaka.net](https://circleci.com/gh/masutaka/masutaka-metrics/tree/master).

## Automatic `$ bundle update`

A pull request regularly creates by a trigger https://dashboard.heroku.com/apps/bu-masutaka-metrics
