# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ECSBundler::Config do
  let(:config) { ECSBundler::Config.new }

  describe '#new' do
    it { expect(config.data).to be_an_instance_of(Hash) }
    %i[url project apiKey userName userAgent].each do |key|
      it { expect(config.data).to have_key(key) }
    end
  end

  describe '#load' do
    it do
      config.load(RSpec.root.join('fixtures'))
      expect(config[:userName]).to eq('userName')
    end

    it do
      config.load(RSpec.root.join('fixtures/config.json'))
      expect(config[:userName]).to eq('userNameConf')
    end
  end

  describe '#[]' do
    it { expect(config[:userAgent]).to match(ECSBundler.name) }
    it { expect(config[:userAgent]).to eq(config.data[:userAgent]) }
  end

  describe '#get_default_options' do
    it { expect(config.send(:get_default_options)).to be_an_instance_of(Hash) }
    it { expect(config.send(:get_default_options)).to eq(config.data) }
  end
end
