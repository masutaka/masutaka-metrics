require 'active_support/time'
require 'erb'
require 'newrelic_rpm'
require 'yaml'
require_relative 'blog_subscribers_number'
require_relative 'blog_subscribers_number/growth_forecast'
require_relative 'blog_subscribers_number/social_service'

path = File.join(__dir__, '..', 'settings.yml')
settings = YAML.load(ERB.new(IO.read(path)).result)

BlogSubscribersNumber.new(settings).start
