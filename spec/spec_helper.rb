require 'simplecov'
require 'coveralls'
require 'webmock/rspec'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
 SimpleCov::Formatter::HTMLFormatter,
 Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'social_net'
Dir['./spec/support/**/*.rb'].each {|f| require f}
