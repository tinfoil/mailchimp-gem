module Mailchimp
  def self.valid_api_key?(api_key)
    Base.new(api_key).valid_api_key?
  end
  class Base
    include HTTParty
    default_timeout 30

    attr_accessor :api_key, :timeout, :options

    def initialize(api_key = nil, default_parameters = {})
      @api_key = api_key || ENV['MAILCHIMP_API_KEY'] || nil
      @timeout = default_parameters.delete(:timeout) 
      @default_params = default_parameters
    end

    def dc_from_api_key
      (@api_key.nil? || @api_key.length == 0 || @api_key !~ /-/) ? '' : "#{@api_key.split("-").last}."
    end
    
    def valid_api_key?
      %q{"Everything's Chimpy!"} == self.class.post(_base_api_url+"ping", :body => {apikey: @api_key}, :timeout => 30).body
    end
    
    class << self
      attr_accessor :api_key

      def method_missing(sym, *args, &block)
        self.api_key = args[0] if sym == :valid_api_key?
        new(self.api_key).send(sym, *args, &block)
      end
    end
    
    protected
    
      def call(url, params = {})
        params = @default_params.merge(params)
        timeout = params.delete(:timeout) || @timeout
        response = self.class.post(url, :body => params, :timeout => timeout)
        begin; response = JSON.parse(response.body); rescue; response = response.body ;end
        if @throws_exceptions && response.is_a?(Hash) && response["error"]
          raise "Error from MailChimp API: #{response["error"]} (code #{response["code"]})"
        end
        response
      end
      
      def method_missing(method, *args)
        method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
        method = method[0].chr.downcase + method[1..-1].gsub(/aim$/i, 'AIM')
        call(method, *args)
      end

    private
    
      def _base_api_url
        "https://#{dc_from_api_key}api.mailchimp.com/1.3/?method="
      end
  end
end

  
