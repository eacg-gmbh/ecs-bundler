# frozen_string_literal: true

require 'simplecov'

module ::RSpec
  module_function

  def root
    @spec_root ||= Pathname.new(__dir__)
  end
end

SimpleCov.start do
  load_profile 'test_frameworks'

  at_exit do
    SimpleCov.result.format!
    puts "Click to open report file://#{RSpec.root.join('../').realpath}/coverage/index.html#_AllFiles"
  end
end

require 'bundler/setup'
require 'ecs_bundler'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
