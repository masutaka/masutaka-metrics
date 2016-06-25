require 'active_support/time'
require 'erb'
require 'newrelic_rpm'
require 'yaml'
require_relative 'lib/masutaka_metrics'
require_relative 'lib/masutaka_metrics/social_service'

GC::Profiler.enable

path = File.join(__dir__, 'config', 'settings.yml')
settings = YAML.load(ERB.new(IO.read(path)).result)

MasutakaMetrics.new(settings).start
