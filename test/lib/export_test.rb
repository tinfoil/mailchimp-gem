require 'test_helper'

class ExportTest < Test::Unit::TestCase

  context "export API" do
    setup do
      @key = "TESTKEY-us1"
      @api = Mailchimp::Export.new(@key)
      @url = "http://us1.api.mailchimp.com/export/1.0/list/"
      @body = {:apikey => @key, :id => "listid"}
      @returns = Struct.new(:body).new(["array", "entries"].to_json)
    end
    should 'allow timeout option through constructor' do
      @api = Mailchimp::Export.new(@key, :timeout => 200)
      expect_post(@url, @body, 200)
      @api.list(:id => "listid")
    end
    should 'allow timeout option through params' do
      expect_post(@url, @body, 180)
      @api.list(:id => "listid", :timeout => 180)
    end

    should "not throw exception if the Export API replies with a JSON hash containing a key called 'error'" do
      Mailchimp::Export.stubs(:post).returns(Struct.new(:body).new({'error' => 'bad things'}.to_json))

      assert_nothing_raised do
        @api.say_hello(@body)
      end
    end
=begin #pending throw exception decision
    should "throw exception if configured to and the Export API replies with a JSON hash containing a key called 'error'" do
      @api.throws_exceptions = true
      params = {:body => @body, :timeout => nil}
      Mailchimp::Export.stubs(:post).returns(Struct.new(:body).new({'error' => 'bad things', 'code' => '123'}.to_json))

      assert_raise RuntimeError do
        @api.say_hello(@body)
      end
    end
=end
  end
  private

  def expect_post(expected_url, expected_body, expected_timeout=nil)
    Mailchimp::Export.expects(:post).with do |url, opts|
      url == expected_url &&
      opts[:body] == expected_body &&
      opts[:timeout] == expected_timeout
    end.returns(Struct.new(:body).new("") )
  end

end