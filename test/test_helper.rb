require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end
require 'dotenv'
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require 'vcr'
require 'httparty'
require "awesome_print"
# require_relative '../lib/workspace'
# require_relative '../lib/channel'
# require_relative '../lib/user'
Dotenv.load

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes" # folder where casettes will be located
  config.hook_into :webmock # tie into this other tool called webmock
  config.default_cassette_options = {
    :record => :new_episodes,    # record new data when we don't have it yet
    :match_requests_on => [:method, :uri, :body], # The http method, URI and body of a request all need to match
  }

  # config.allow_http_connections_when_no_cassette = true #added by Rachael and Christabel to allow to HTTP Requests without cassettes

  # Don't leave our token lying around in a cassette file.
  config.filter_sensitive_data("<SLACK_TOKEN>") do
    ENV["SLACK_TOKEN"]
  end

end
