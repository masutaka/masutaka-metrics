require 'active_support/time'
require 'erb'
require 'yaml'

require_relative 'blog_subscribers_number'
require_relative 'growth_forecast'
require_relative 'social_service'

path = File.join(__dir__, '..', 'settings.yml')
settings = YAML.load(ERB.new(IO.read(path)).result)

BlogSubscribersNumber.new(settings).start
