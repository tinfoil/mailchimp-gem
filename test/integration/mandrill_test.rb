require 'test_helper'

class MandrillIntegrationTest < Test::Unit::TestCase
  should "send request to Mandrill API" do
    FakeWeb.register_uri(
      :post,
      'https://mandrillapp.com/api/1.0/users/ping',
      body: '"PONG!"'
    )
    FakeWeb.register_uri(
      :post,
      'https://mandrillapp.com/api/1.0/messages/send',
      body: "{\"key\":\"abc123-us1\"}"
    )

    m = Mailchimp::Mandrill.new('abc123-us1')
    assert_equal '"PONG!"', m.users_ping
    assert_equal true, m.valid_api_key?
  end

end