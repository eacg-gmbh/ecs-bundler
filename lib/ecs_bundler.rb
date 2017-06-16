# frozen_string_literal: true

module ECSBundler
  autoload :BundlerScanner, 'ecs_bundler/bundler_scanner'
  autoload :Config, 'ecs_bundler/config'
  autoload :ProjectSpecification, 'ecs_bundler/project_specification'
  autoload :RestClient, 'ecs_bundler/rest_client'
  autoload :Scan, 'ecs_bundler/scan'
  autoload :VERSION, 'ecs_bundler/version'
  class BundlerScanner
    autoload :RepositoryFinder, 'ecs_bundler/bundler_scanner/repository_finder'
  end

  class << self
    # Return config class
    def config
      @@config ||= Config.new
    end

    # Return rest-client class
    def rest_client(options = {})
      @@rest_client ||= RestClient.new(options)
    end

    # Run cli application
    def run_cli
      require 'cli'
      cli = ::CLI.new do
        version(ECSBundler::VERSION)
        option :apiKey, short: :k, description: 'api key'
        option :userName,	short: :u, description: 'user name'
        option :url, description: 'Base url'
        option :project, short: :p, description: 'Project name'
        option :config, short: :c, description: 'Config path'
      end
      settings = cli.parse
      print settings.help if settings.help
      print settings.version.gsub('"', '') if settings.version
      exit 0 if settings.help || settings.version
      run(settings.to_h.compact)
    rescue CLI::ParsingError => pe
      cli.usage!(pe)
    end

    # Run application
    def run(options = {})
      config.load(options[:config] ? options[:config] : nil)
      options = config.data.merge(options)
      validate_options!(options)
      rest_client(options)
      scan = Scan.create(BundlerScanner.run)
      if scan.id
        print "ecs-bundler successfully transferred scan to server: scanId => #{scan.id}\n"
      else
        print "ecs-bundler error transferring scan: #{scan.message}\n"
      end
    end

    private

    # validate options
    def validate_options!(options)
      if !options[:userName] || !options[:apiKey]
        raise "Please provide a 'userName' and 'apiKey' property in credentials file('#{Config::FILE_NAME}')."
      end
      raise "Please provide a 'project' property in credentials file('#{Config::FILE_NAME}')." unless options[:project]
    end
  end
end
