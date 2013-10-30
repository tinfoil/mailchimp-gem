module Mailchimp
  class PsuedoJSONParser < HTTParty::Parser
    # Unfornately Mailchimp's API returns invalid JSON for some valid requests,
    # specifically mandrill's users/ping.  We need to just pass that through instead
    # of blowing up inside of HTTParty so that we can do something with it later.
    def json
      begin
        MultiJson.decode(body)
      rescue
        body
      end
    end
  end
end
