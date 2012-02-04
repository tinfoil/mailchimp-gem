module Mailchimp
  class API
    include HTTParty
    format :plain
    default_timeout 30

    attr_accessor :api_key, :timeout, :throws_exceptions

    def initialize(api_key = nil, extra_params = {})
      @api_key = api_key || ENV['MAILCHIMP_API_KEY'] || self.class.api_key
      @default_params = {:apikey => @api_key}.merge(extra_params)
      @throws_exceptions = false
    end

    def api_key=(value)
      @api_key = value
      @default_params = @default_params.merge({:apikey => @api_key})
    end

    def base_api_url
      "https://#{dc_from_api_key}api.mailchimp.com/1.3/?method="
    end
    
    def valid_api_key?(*args)
      %q{"Everything's Chimpy!"} == call("#{base_api_url}ping")
    end

    protected

    def call(method, params = {})
      api_url = base_api_url + method
      params = @default_params.merge(params)
      timeout = params.delete(:timeout) || @timeout
      response = self.class.post(api_url, :body => CGI::escape(params.to_json), :timeout => timeout)

      begin
        response = JSON.parse(response.body)
      rescue
        response = JSON.parse('['+response.body+']').first
      end

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

    class << self
      attr_accessor :api_key

      def method_missing(sym, *args, &block)
        new(self.api_key).send(sym, *args, &block)
      end
    end

    def dc_from_api_key
      (@api_key.nil? || @api_key.length == 0 || @api_key !~ /-/) ? '' : "#{@api_key.split("-").last}."
    end
  end
end
