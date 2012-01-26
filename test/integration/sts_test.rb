require 'test_helper'

class STSIntegrationTest < Test::Unit::TestCase
  
  should "send request to STS API" do
    FakeWeb.register_uri(
      :post,
      'https://us1.sts.mailchimp.com/1.0/Ping',
      body: "Everything's Chimpy!"
    )
    expected_request = "apikey=abc123-us1&options[track_opens]=true&options[track_clicks]=true"
    
    m = Mailchimp::STS.new('abc123-us1')
    assert_equal "Everything's Chimpy!", m.ping
    assert_equal expected_request, URI::decode(FakeWeb.last_request.body)
  end
  should 'use the regular API for checking key validity' do
    FakeWeb.register_uri(
      :post,
      'https://us1.api.mailchimp.com/1.3/?method=ping',
      body: %q{"Everything's Chimpy!"}
    )
    assert_equal true, Mailchimp::STS.new('abc123-us1').valid_api_key?
    
  end

end