# frozen_string_literal: true

require 'spec_helper'
require 'cli'

RSpec.describe ECSBundler do
  describe '.config' do
    it { expect(ECSBundler.config).to be_an_instance_of(ECSBundler::Config) }
  end

  describe '.rest_client' do
    it { expect(ECSBundler.rest_client).to be_an_instance_of(ECSBundler::RestClient) }
  end

  describe '.run_cli' do
    it 'call run with no options' do
      expect_any_instance_of(::CLI).to receive(:parse!).and_return(userName: nil)
      expect(ECSBundler).to receive(:run).with({})
      ECSBundler.run_cli
    end

    it 'call run with options' do
      expect_any_instance_of(::CLI).to receive(:parse!).and_return(userName: 'userName')
      expect(ECSBundler).to receive(:run).with(userName: 'userName')
      ECSBundler.run_cli
    end
  end

  describe '.run' do
    it do
      expect(ECSBundler::BundlerScanner).to receive(:run).and_return({})
      expect(ECSBundler::Scan).to receive(:create).and_return(OpenStruct.new(id: 1))
      expect(ECSBundler).to receive(:print).with(/successfully.*scanId => 1/)
      ECSBundler.run(config: RSpec.root.join('fixtures'))
    end

    it do
      expect(ECSBundler::BundlerScanner).to receive(:run).and_return({})
      expect(ECSBundler::Scan).to receive(:create).and_return(OpenStruct.new(id: nil, message: 'MESSAGE'))
      expect(ECSBundler).to receive(:print).with(/error.*scan: MESSAGE/)
      ECSBundler.run(config: RSpec.root.join('fixtures'))
    end
  end

  describe '.validate_options!' do
    it { expect { ECSBundler.send(:validate_options!, {}) }.to raise_error RuntimeError, /Please provide a 'userName' and 'apiKey'/ }
    it { expect { ECSBundler.send(:validate_options!, userName: 'userName', apiKey: 'apiKey') }.to raise_error RuntimeError, /Please provide a 'project' property/ }
    it { expect { ECSBundler.send(:validate_options!, userName: 'userName', apiKey: 'apiKey', project: 'project') }.to_not raise_error }
  end
end
