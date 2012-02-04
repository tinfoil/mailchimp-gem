if defined?(ActionMailer)
  require File.join(File.dirname(__FILE__), 'handlers', 'sts_delivery_handler')
end

module Mailchimp
  class STS < Base
    def initialize(api_key = nil, extra_params = {})
        super(api_key,{
        :apikey => api_key,
        :options => {
          :track_opens => true, 
          :track_clicks => true
          }
        }.merge(extra_params))
    end

    def call(method, params = {})
      super("#{base_api_url}#{method}",params.merge({:apikey => @api_key}))
    end

    def method_missing(method, *args)
      method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
      call(method, *args)
    end

    class << self
      attr_accessor :api_key

      def method_missing(sym, *args, &block)
        new(self.api_key).send(sym, *args, &block)
      end
    end
    
    private
      
      def base_api_url
        "https://#{dc_from_api_key}sts.mailchimp.com/1.0/"
      end
  end
end
