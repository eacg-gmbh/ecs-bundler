# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ECSBundler::ProjectSpecification do
  let(:project_specification) { ECSBundler::ProjectSpecification.new }

  describe '#name' do
    it 'eq rails application name' do
      without_partial_double_verification do
        rails = double
        stub_const 'Rails', rails
        expect(rails).to receive(:application).and_return(ECSBundler::ProjectSpecification.new)
        expect(ECSBundler::ProjectSpecification).to receive(:parent).and_return(ECSBundler)
        expect(project_specification.name).to eq(ECSBundler.name)
      end
    end

    it do
      expect(ECSBundler.config).to receive(:[]).with(:project).and_return('Test *&^project')
      expect(project_specification.name).to eq('Test-project')
    end
  end

  %i[description license homepage].each do |key|
    describe "##{key}" do
      it { expect(project_specification.send(key)).to be_nil }
    end
  end

  describe '#version' do
    it { expect(project_specification.version).to eq(ECSBundler::VERSION) }
  end

  describe '#runtime_dependencies' do
    it do
      bundler = double
      expect(Bundler).to receive(:load).and_return(bundler)
      expect(bundler).to receive(:current_dependencies).and_return('result')
      expect(project_specification.runtime_dependencies).to eq('result')
    end
  end
end
