require 'active_support/time'
require 'erb'
require 'yaml'

require_relative 'lib/blog_subscribers_number'
require_relative 'lib/growth_forecast'
require_relative 'lib/social_service'

path = File.join(__dir__, 'settings.yml')
settings = YAML.load(ERB.new(IO.read(path)).result)

BlogSubscribersNumber.new(settings).start
