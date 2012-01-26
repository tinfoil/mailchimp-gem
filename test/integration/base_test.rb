require 'test_helper'

class BaseIntegrationTest < Test::Unit::TestCase
  context 'utility methods' do
    setup do
      FakeWeb.register_uri(
        :post,
        'http://us1.api.mailchimip.com/api/1.3?method=ping',
        body: %q{"Everything's Chimpy!"}
      )
    end
  
    should "know valid api key" do
      m = Mailchimp::Base.new('abc123-us1')
      assert_equal true, m.valid_api_key?
      assert_equal true, Mailchimp.valid_api_key?('abc123-us1')
    end
  
    should "know invalid api key" do
      m = Mailchimp::Base.new('abc123-us1')
      assert_equal false, !m.valid_api_key?
      assert_equal false, !Mailchimp.valid_api_key?('abc123-us1')
    end
  end

end