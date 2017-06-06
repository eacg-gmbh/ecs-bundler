# frozen_string_literal: true

module ECSBundler
  # Scan model
  class Scan
    API_PATH = '/api/v1'.freeze
    CREATE_PATH = '/scans'.freeze
    attr_accessor :id, :data
    attr_reader :message

    def initialize(data)
      @data = data
    end

    def save
      create unless id
      self
    end

    private

    def create
      ECSBundler.rest_client.post("#{API_PATH}#{CREATE_PATH}", data){ |_, response, message| @id, @message = response['scanId'], message }
    end

    class << self
      def create(data)
        Scan.new(data).save
      end
    end
  end
end
