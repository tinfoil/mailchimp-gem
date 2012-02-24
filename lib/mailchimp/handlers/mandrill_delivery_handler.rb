require 'action_mailer'

module Mailchimp
  class MandrillDeliveryHandler
    attr_accessor :settings

    def initialize options
      self.settings = {:debug => false, :track_opens => true, :track_clicks => true}.merge(options)
    end

    def deliver! message
      message_payload = {
        :track_opens => settings[:track_opens],
        :track_clicks => settings[:track_clicks],
        :message => {
          :subject => message.subject,
          :from_name => settings[:from_name],
          :from_email => message.from.first,
          :to_email => message.to
        }
      }

      mime_types = {
        :html => "text/html",
        :text => "text/plain"
      }

      get_content_for = lambda do |format|
        content = message.send(:"#{format}_part")
        content ||= message if message.content_type =~ %r{#{mime_types[format]}}
        content
      end

      [:html, :text].each do |format|
        content = get_content_for.call(format)
        message_payload[:message][format] = content.body if content
      end

      message_payload[:tags] = settings[:tags] if settings[:tags]
      
      api_key = message.header['api-key'].present? ? message.header['api-key'] : settings[:api_key]
      
      puts "Setting up Mandrill API connection with API Key #{api_key}" if settings[:debug] == true
            
      response = Mandrill.new(api_key).send_email(message_payload)
      
      puts "Got response from Mandrill: #{response}" if settings[:debug] == true
    end

  end
end

ActionMailer::Base.add_delivery_method :mailchimp_mandrill, Mailchimp::MandrillDeliveryHandler
