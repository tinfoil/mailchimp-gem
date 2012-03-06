require 'cover_me'
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'
require 'shoulda'
require 'mocha'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mailchimp'

FakeWeb.allow_net_connect = false

def mock_mail_message(options = {})
  subject = options.fetch(:subject) { 'Subject' }
  from = [ options.fetch(:from) { 'foo@bar.com' } ]
  to = [ options.fetch(:to) {'foo@bar.com'} ]
  body = options.fetch(:body) { 'foo@bar.com has moved use awesome@awesomesauce.com now' }
  
  message = mock('Mail::Message')
  message.stubs(:subject).returns(subject)
  message.stubs(:date).returns(Date.today)
  message.stubs(:from).returns(from)
  message.stubs(:to).returns(to)
  message.stubs(:body).returns(body)
  message.stubs(:header).returns('')
  message.stubs(:multipart?).returns(false)
  message.stubs(:mime_type).returns('text/html')
  message.stubs(:html_part).returns(nil)
  message.stubs(:text_part).returns(nil)
  
  message
end
