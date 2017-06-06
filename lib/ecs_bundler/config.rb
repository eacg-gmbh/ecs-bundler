# frozen_string_literal: true

require 'json'

module ECSBundler
  class Config
    FILE_NAME = '/.ecsrc.json'.freeze
    URL = 'https://ecs-app.eacg.de'.freeze
    attr_reader :data

    def initialize
      @data = get_default_options
    end

    def load(path = nil)
      path = [path, Dir.pwd, ENV['HOME']].flatten.compact.map do |path|
        if File.directory?(path) && File.exist?("#{path}#{FILE_NAME}")
          "#{path}#{FILE_NAME}"
        elsif File.file?(path) && File.exist?(path)
          path
        end
      end.compact.first
      @data = get_default_options.merge(::JSON.parse(File.read(path)).map { |k, v| [k.to_sym, v] }.to_h) if path
    rescue
    end

    def [](key)
      @data[key]
    end

    private

    def get_default_options
      { url: URL, project: '', apiKey: '', userName: '', userAgent: "#{ECSBundler.name}/#{VERSION}" }
    end
  end
end
