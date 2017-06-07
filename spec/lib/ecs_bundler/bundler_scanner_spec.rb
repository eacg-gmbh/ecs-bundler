# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ECSBundler::BundlerScanner do
  let(:project_specification) { ECSBundler::ProjectSpecification.new }
  let(:scanner) { ECSBundler::BundlerScanner }

  describe '.run' do
    it 'return correct result' do
      expect_any_instance_of(ECSBundler::ProjectSpecification).to receive(:runtime_dependencies).and_return([])
      allow(ECSBundler.config).to receive(:[]).with(:project).and_return('Test')
      result = scanner.run
      expect(result).to include(project: 'Test', module: 'Test', moduleId: 'bundler:Test')
      expect(result).to have_key(:dependencies)
    end
  end

  describe '.specification_to_h' do
    it do
      expect(project_specification).to receive(:runtime_dependencies).and_return([])
      allow(ECSBundler.config).to receive(:[]).with(:project).and_return('actioncable')
      result = scanner.send(:specification_to_h, project_specification)
      expect(result).to include(
        name: 'actioncable',
        key: 'bundler:actioncable',
        description: nil,
        private: true,
        licenses: [],
        homepageUrl: nil,
        repoUrl: 'https://github.com/rails/rails',
        versions: [ECSBundler::VERSION],
        dependencies: []
      )
    end

    it 'call specification_to_h to dependency spec' do
      allow_any_instance_of(ECSBundler::ProjectSpecification).to receive(:runtime_dependencies).and_return([])
      expect(project_specification).to receive(:runtime_dependencies).and_return([OpenStruct.new(to_spec: ECSBundler::ProjectSpecification.new)])
      allow(ECSBundler.config).to receive(:[]).with(:project).and_return('actioncable')
      expect(scanner.send(:specification_to_h, project_specification)[:dependencies].count).to eq(1)
    end
  end
end
