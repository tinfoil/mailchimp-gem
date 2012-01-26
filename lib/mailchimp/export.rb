module Mailchimp
  class Export < Base
    def initialize(api_key = nil, default_parameters = {})
      super(api_key, {:apikey => api_key}.merge(default_parameters))
    end

    def export_api_url
      "http://#{dc_from_api_key}api.mailchimp.com/export/1.0/"
    end

    def call(method, params = {})
      api_url = export_api_url + method + "/"
      params = @default_params.merge(params)
      timeout = params.delete(:timeout) || @timeout
      response = self.class.post(api_url, :body => params, :timeout => timeout)

      lines = response.body.lines
      if @throws_exceptions
        first_line_object = JSON.parse(lines.first) if lines.first
        raise "Error from MailChimp Export API: #{first_line_object["error"]} (code #{first_line_object["code"]})" if first_line_object.is_a?(Hash) && first_line_object["error"]
      end

      lines  
    end
    class << self
      attr_accessor :api_key

      def method_missing(sym, *args, &block)
        new(self.api_key).send(sym, *args, &block)
      end
    end
  end
  
end