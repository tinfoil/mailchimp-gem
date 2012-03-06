require 'test_helper'
require File.join('./lib/mailchimp','handlers', 'mandrill_delivery_handler')

class MandrillDeliveryHandlerTest < Test::Unit::TestCase
  context "when delivering a Mail::Message to the Mandrill API" do
    setup do
      @mandrill_delivery_handler = Mailchimp::MandrillDeliveryHandler.new
      @fake_mandrill_api_response = [{"email"=>"foo@bar.com", "status"=>"sent"}]
      
      FakeWeb.register_uri(
      :post,
      'http://mandrillapp.com/api/1.0/messages/send',
      body: @fake_mandrill_api_response.to_json
    )
    end
    
    should "deliver successfully" do
      message = mock_mail_message
      response = @mandrill_delivery_handler.deliver!(message)
      assert_equal @fake_mandrill_api_response, response 
    end
  end
end