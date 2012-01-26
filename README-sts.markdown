# Mailchimp::STS

STS is a simple API wrapper for the [MailChimp STS API](http://http://apidocs.mailchimp.com/sts/1.0/) 1.0, which wraps Amazon SES.
    
##Requirements

A paid MailChimp account, MailChimp API key, and Amazon AWS account with SES ready to go. You can see your API keys [here](http://admin.mailchimp.com/account/api). Caveats include the inability to send to unconfirmed email addresses until you request (and Amazon provides) production access to your AWS account.

##Usage

There are a few ways to use STS.

You can create an instance of the API wrapper:

    sts = Mailchimp::STS.new("your_api_key")

You can set your api_key globally and call class methods:

    Mailchimp::STS.api_key = "your_api_key"
    Mailchimp::STS.send_email(...)

You can also set the environment variable 'MAILCHIMP_API_KEY' and STS will use it when you create an instance:

    sts = Mailchimp::STS.new

### Sending a message

Send a message so a single email:

    response = sts.send_email({
        :track_opens  => true, 
        :track_clicks => true, 
        :tags         => ["awesome", "tags", "here"] #optional STS tags
        :message      => { 
            :subject => 'your subject', 
            :html => '<html>hello world</html>', 
            :text => 'hello world', 
            :from_name => 'John Smith', 
            :from_email => 'support@somedomain.com', 
            :to_email => ['user@someotherdomain.com']
        }
    })

Calling other methods is as simple as calling API methods directly on the STS instance (e.g. u.get_send_quota, u.verify_email_address, and so on). Check the API [documentation](http://apidocs.mailchimp.com/sts/1.0/) for more information about API calls and their parameters.


### Plugging into ActionMailer

You can tell ActionMailer to send mail using Mailchimp STS by adding the follow to to your config/application.rb or to the proper environment (eg. config/production.rb) :
    
    config.action_mailer.delivery_method = :mailchimp_sts
    config.action_mailer.mailchimp_sts_settings = {
          :api_key => "your_mailchimp_apikey",
          :track_clicks => true,
          :track_opens  => true, 
          :from_name    => "Change Me"
          :tags         => ["awesome", "tags", "here"] #optional STS tags
     }

These setting will allow you to use ActionMailer as you normally would, any calls to mail() will be sent using Mailchimp STS

If, for some reason, you want to use ActionMailer and change your tags dynamically at runtime, you can do something like:

    ActionMailer::Base.mailchimp_sts_settings[:tags] = ["dynamically", "set", "tags"]

