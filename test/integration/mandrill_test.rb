require 'test_helper'

class MandrillIntegrationTest < Test::Unit::TestCase
  should "send request to Mandrill API" do
    FakeWeb.register_uri(
      :post,
      'http://mandrillapp.com/api/1.0/users/ping',
      body: '"PONG!"'
    )
    expected_request = "key=abc123-us1&options[track_opens]=true&options[track_clicks]=true"
    
    m = Mailchimp::Mandrill.new('abc123-us1')
    assert_equal '"PONG!"', m.users_ping
    assert_equal true, m.valid_api_key?
    assert_equal expected_request, URI::decode(FakeWeb.last_request.body)
  end

end