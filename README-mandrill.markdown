# Mailchimp::Mandrill

Mailchimp::Mandrill is a simple API wrapper for the [Mailchimp Mandrill API](http://mandrillapp.com/api/docs/index.html).

##Requirements

A MailChimp account and a Mandrill specific API key.

Note, to be able to send messages, you'll have to click an e-mail in a message sent to you the first time you try to use that sender.

##Usage

There are a few ways to use Mandrill.

You can create an instance of the API wrapper:

    mandrill = Mailchimp::Mandrill.new("your_api_key")

You can set your api_key globally and call class methods:

    Mailchimp::Mandrill.api_key = "your_api_key"
    Mailchimp::Mandrill.user_senders(...)

You can also set the environment variable 'MAILCHIMP_MANDRILL_API_KEY' and Mandrill will use it when you create an instance:

    mandrill = Mailchimp::Mandrill.new
    
To check if your api_key is valid:

    mandrill.valid_api_key?
    Mailchimp::Mandrill.valid_api_key?("your_api_key")

### Sending a message

Send a message so a single email:

    response = mandrill.messages_send({
        :message      => { 
            :subject => 'your subject', 
            :html => '<html>hello world</html>', 
            :text => 'hello world', 
            :from_name => 'John Smith', 
            :from_email => 'support@somedomain.com', 
            :to => ['user@someotherdomain.com']
        }
    })

Calling other methods is as simple as calling API methods directly on the Mandrill instance (e.g. mandrill.users_verify_sender(...)). Check the API [documentation](http://mandrillapp.com/api/docs/index.html)) for more information about API calls and their parameters.


### Plugging into ActionMailer

You can tell ActionMailer to send mail using Mandrill by adding the follow to to your config/application.rb or to the proper environment (eg. config/production.rb) :
    
    config.action_mailer.delivery_method = :mailchimp_mandrill
    config.action_mailer.mailchimp_mandrill_settings = {
          :api_key => "your_mailchimp_mandrill_apikey",
          :track_clicks => true,
          :track_opens  => true, 
          :from_name    => "Change Me"
     }

These setting will allow you to use ActionMailer as you normally would, any calls to mail() will be sent using Mandrill

If your application will specify the API Key on a per email basis, you can configure your application like so:

    config.action_mailer.delivery_method = :mailchimp_mandrill
    config.action_mailer.mailchimp_mandrill_settings = {
          :track_clicks => true,
          :track_opens  => true, 
          :from_name    => "Change Me"
    }
    
Once this is specified, be sure to include the api_key in ActionMailer.mail()'s options:

	class ExampleMailer < ActionMailer::Base
	  default from: "no-reply@example.com"
	  
	  def test_email(object_with_api_key)
	    
	    mail(to: object_with_api_key.email,
	         subject: "This is an example Mandrill Email",
	         api_key: object_with_api_key.api_key)
	  end
	end
	
And the Mandrill Delivery Hander will read the api key from the email message object, instead of the application configuration