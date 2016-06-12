# masutaka metrics

Post masutaka metrics to fluentd and GrowthForecast

* [feedly](https://feedly.com/)
* [Hatena::Bookmark](http://b.hatena.ne.jp/)
* [Live Dwango Reader](http://reader.livedoor.com/)

## for development

### Require

* [fluentd](http://www.fluentd.org/)
* [GrowthForecast](http://kazeburo.github.io/GrowthForecast/)

### Setup

    $ cp config/settings.example.yml config/settings.yml

Modify config/settings.yml

### Clockwork

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

Automatically update by https://www.deppbot.com
