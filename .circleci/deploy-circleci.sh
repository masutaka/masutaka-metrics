#!/bin/sh -e

# for recording deployments of New Relic
curl -Ls -o config/newrelic.yml $NEWRELIC_FILE_PATH

cat <<EOF >> $HOME/.ssh/config
  User masutaka
  ForwardAgent yes
EOF

cat $HOME/.ssh/config

# Add the preferred key for getting GitHub Permission
# See https://circleci.com/gh/masutaka/masutaka-metrics/edit#checkout
eval $(ssh-agent)
ssh-add

bundle exec cap production deploy
