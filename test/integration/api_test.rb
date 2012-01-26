require 'test_helper'

class ApiIntegrationTest < Test::Unit::TestCase
  
  should "send request to Mailchimp API" do
    FakeWeb.register_uri(
      :post,
      'https://us1.api.mailchimp.com/1.3/?method=ping',
      body: %q{"Everything's Chimpy!"}
    )
    expected_request = {"apikey"=>"abc123-us1"}
    
    m = Mailchimp::API.new('abc123-us1')
    assert_equal "Everything's Chimpy!", m.ping
    assert_equal expected_request, JSON.parse(URI::decode(FakeWeb.last_request.body))
  end

end