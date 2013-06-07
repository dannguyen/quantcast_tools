require 'quantcast_tools'

# set up fixtures
require_relative "fixtures/spec_fixtures"
require "fakeweb"

# No internet connecting allowed
FakeWeb.allow_net_connect = false
SpecFixtures.list_pages.each do |arr|
   base_uri = arr[0]
   base_uri_rx = Regexp.escape(base_uri)
   FakeWeb.register_uri(:get, %r|#{base_uri_rx}|, :body => SpecFixtures.html(base_uri))
end 



RSpec.configure do |config|

  config.filter_run_excluding :skip => true

  config.before(:each) do
  end
  
  config.after(:each) do
  end
end
