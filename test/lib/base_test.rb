
require 'test_helper'

class BaseTest < Test::Unit::TestCase
  context 'instance vars/methods' do
    should 'set timeout in constructor' do
      @api = Mailchimp::Base.new(@api_key, :timeout => 65)
      assert_equal(65,@api.timeout)
    end
=begin #pending throws_exceptions decision
    should 'set throws_exceptions in constructor' do
      @api = Mailchimp::API.new(@api_key, :throws_exceptions => true)
      assert_equal(true,@api.throws_exceptions)
    end
=end
  end

end