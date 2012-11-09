require 'action_mailer'

module Mailchimp
  class StsDeliveryHandler
    attr_accessor :settings

    def initialize options
      self.settings = {:track_opens => true}.merge(options)
    end

    def deliver! message
      message_payload = {
        :track_opens => settings[:track_opens],
        :message => {
          :subject => message.subject,
          :from_name => settings[:from_name],
          :from_email => message.from.first,
          :to_email => message.to
        }
      }
      message_payload[:track_clicks] = message.track_clicks if message.track_clicks

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

      STS.new(settings[:api_key]).send_email(message_payload)
    end

  end
end

ActionMailer::Base.add_delivery_method :mailchimp_sts, Mailchimp::StsDeliveryHandler