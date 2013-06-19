module Mailchimp
  class MandrillDeliveryHandler
    attr_accessor :settings, :message_payload

    def initialize(options = {})
      self.settings = {:track_opens => true, :track_clicks => true}.merge(options)
    end

    def deliver!(message)
      self.message_payload = {
        :message => {
          :track_opens => settings[:track_opens],
          :track_clicks => settings[:track_clicks],
          :subject => message.subject,
          :from_name => (message[:from_name].blank? or message[:from_name].value.blank?) ? settings[:from_name] : message[:from_name].value,
          :from_email => message.from.first,
          :to => message.to.map {|email| { :email => email, :name => email } },
          :headers => {'Reply-To' => message.reply_to.nil? ? nil : message.reply_to },
          :bcc_address  => message.bcc ? message.bcc.first : nil,
        }
      }

      [:html, :text].each do |format|
        content = get_content_for(message, format)
        self.message_payload[:message][format] = content.to_s if content
      end

      self.message_payload[:tags] = settings[:tags] if settings[:tags]

      api_key = message.header['api-key'].blank? ? settings[:api_key] : message.header['api-key']

      self.settings[:return_response] = Mailchimp::Mandrill.new(api_key).messages_send(self.message_payload)
    end

    private

    def get_content_for(message, format)
      mime_types = {
        :html => "text/html",
        :text => "text/plain"
      }

      content = message.send(:"#{format.to_s}_part")
      content = content.body if content and content.respond_to? :body

      content ||= message.body if message.mime_type == mime_types[format]
      content
    end

  end
end

if defined?(ActionMailer)
  ActionMailer::Base.add_delivery_method(:mailchimp_mandrill, Mailchimp::MandrillDeliveryHandler)
end

