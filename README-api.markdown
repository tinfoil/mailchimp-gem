# Mailchimp::API

API is a simple API wrapper for interacting with [MailChimp API](http://www.mailchimp.com/api) 1.3.

##Requirements

A MailChimp account and API key. You can see your API keys [here](http://admin.mailchimp.com/account/api).

##Usage

There are a few ways to use API:

You can create an instance of the API wrapper:

    api = Mailchimp::API.new("your_api_key")

You can set your api_key globally and call class methods:

    Mailchimp::API.api_key = "your_api_key"
    Mailchimp::API.lists

You can also set the environment variable 'MC_API_KEY' and API will use it when you create an instance:

    api = Mailchimp::API.new

Fetching data is as simple as calling API methods directly on the wrapper
object.  The API calls may be made with either camelcase or  underscore
separated formatting as you see in the "More Advanced Examples" section below.

Check the API [documentation](http://apidocs.mailchimp.com/api/1.3/) for details.

### Fetching Campaigns

For example, to fetch your first 100 campaigns (page 0):

    campaigns = api.campaigns({:start => 0, :limit => 100})

### Fetching Lists

Similarly, to fetch your first 100 lists:

    lists = api.lists({:start => 0, :limit=> 100})

### More Advanced Examples

Getting batch member information for subscribers looks like this:

    info = api.list_member_info({:id => list_id, :email_address => email_array})

or

    info = api.listMemberInfo({:id => list_id, :email_address => email_array})

Fetch open and click detail for recipients of a particular campaign:

    email_stats = api.campaign_email_stats_aim({:cid => campaign_id, :email_address => email_array})

or

    email_stats = api.campaignEmailStatsAIM({:cid => campaign_id, :email_address => email_array})


### Export API usage

In addition to the standard API you can make calls to the
[MailChimp Export API](http://apidocs.mailchimp.com/export/1.0/) using a APIExport object.  Given an existing
Mailchimp::API object you can request a new Mailchimp::APIExporter object:

    api = Mailchimp::API.new(@api_key)
    mailchimp_export = api.get_exporter

or you can construct a new object directly:

    mailchimp_export = Mailchimp::APIExport.new(@api_key)

Calling Export API functions is identical to making standard API calls but the
return value is an Enumerator which loops over the lines returned from the
Export API.  This is because the data returned from the Export API is a stream
of JSON objects rather than a single JSON array.

### Error handling

By default you are expected to handle errors returned by the APIs manually.  The
APIs will return a Hash with two keys "errors", a string containing some textual
information about the error, and "code", the numeric code of the error.

If you set the `throws_exceptions` boolean attribute for a given instance then
API will attempt to intercept the errors and raise an exception.
