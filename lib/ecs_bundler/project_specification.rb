# frozen_string_literal: true
require 'bundler'

module ECSBundler
  class ProjectSpecification
    def name
      return Rails.application.class.parent.name if defined?(Rails)
      ECSBundler.config[:project].gsub(/[^a-zA-Z]+/, '-')
    end

    def description; end

    def license; end

    def homepage; end

    def version
      path = [
        (Rails.root.join('VERSION') if defined?(Rails)),
        "#{Dir.pwd}/VERSION"
      ].compact.find { |path| File.exist?(path) }
      path ? File.read(path) : nil
    end

    def runtime_dependencies
      Bundler.load.current_dependencies
    end
  end
end
