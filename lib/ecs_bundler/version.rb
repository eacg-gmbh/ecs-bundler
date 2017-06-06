# frozen_string_literal: true

module ECSBundler
  # Contains version string
  VERSION = File.exist?('VERSION') ? File.read('VERSION') : ''
end
