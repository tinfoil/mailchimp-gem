# mailchimp

Mailchimp is a simple API wrapper public Mailchimp APIs.

This is heavily based on https://github.com/amro/uakari/ and https://github.com/amro/gibbon/, and adds
support for the private beta release of Mandrill.

While this works for some simple use cases, it comes with warranty of any kind and may not work for 
your needs yet!

We welcome bug reports and pull requests, and will remove the .alpha label from this gem once we are
confident that it should work out of the box for most usage scenarios.

##Installation

        # This supercedes uakari and gibbon
        $ gem install mailchimp

##Requirements

A MailChimp account, MailChimp API key, and any extra setup/keys for other services/APIs that
you want to use.

##Basic Usage

See README-api.markdown for details about the API class, which supersedes the Gibbon Gem

        api      = Mailchimp::API.new("your_api_key")

See README-sts.markdown for details about the STS class, which supersedes the Uakari Gem

        sts      = Mailchimp::STS.new("your_api_key")
        
See README-mandrill for details about the Mandrill class

        mandrill = Mailchimp::Mandrill.new("your_api_key")
        
##Examples

Take a look in the examples/ folder for examples using each of the APIs. The only actions these perform
are either read only or only send emails to you or the address you specify, so it's ok to use your real
Mailchimp API keys for them. run them like:

        ruby examples/api_example.rb
        ruby examples/sts_example.rb
        ruby examples/mandrill_example.rb

### Other Stuff

API calls default to a 30 second timeout. You can optionally set your own timeout (in seconds) like so:

    api = Mailchimp::API.new("apikey", timeout: 60)
    api.timeout = 5
    api.listBatchSubscribe(list_id: "123", batch: [1..7000], timeout: 300) #per-request will override default


##Development

Write tests before you change anything, run tests before you commit anything:

        $ rake test

We welcome concise pull requests that match the style of this gem and have appropriate tests. To get a
console running where you can play, run:

        irb
        $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
        $LOAD_PATH.unshift(File.dirname(__FILE__))
        require 'mailchimp'

##Contributors

See CONTRIBUTORS.markdown for the people that have contributed in some way to this Gem
