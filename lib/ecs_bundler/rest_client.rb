# frozen_string_literal: true

require 'rest-client'
require 'json'

module ECSBundler
  # Wrapper under rest-client with authorization headers
  class RestClient
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def headers
      {
        content_type: :json,
        accept: :json,
        'User-Agent' => options[:userAgent],
        'X-ApiKey' => options[:apiKey],
        'X-User' => options[:userName]
      }
    end

    def respond_to?(name)
      return true if %i[get delete head options post patch put].include?(name)
      super(name)
    end

    # get delete head options post patch put methods
    def method_missing(name, *args)
      if %i[get delete head options post patch put].include?(name)
        if %i[get delete head options].include?(name)
          path, headers = args
          payload = nil
        else
          path, payload, headers = args
        end
        return ::RestClient::Request.execute(
          method: name,
          url: "#{options[:url]}#{path}",
          payload: payload ? payload.to_json : payload,
          headers: self.headers.merge(headers || {})
        ) do |response|
          parsed_response = JSON.parse(response.body) rescue {}
          message = [
            "#{response.code} #{::RestClient::STATUSES[response.code]}",
            parsed_response['info'],
            (parsed_response['messages'] || []).map { |message| message['message'] }
          ].compact.join(', ')
          yield(response, parsed_response, message) if block_given?
          response
        end
      end
      super(name, *args)
    end
  end
end
