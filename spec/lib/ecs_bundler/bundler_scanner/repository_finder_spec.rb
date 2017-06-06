# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ECSBundler::BundlerScanner::RepositoryFinder do
  let(:url) { 'https://github.com/eacg-gmbh/ecs-bundler' }
  let(:repository_finder) { ECSBundler::BundlerScanner::RepositoryFinder }

  describe '.url' do
    it { expect(repository_finder.url(OpenStruct.new(name: 'actioncable'))).to eq 'https://github.com/rails/rails' }
    it { expect(repository_finder.url(OpenStruct.new(name: 'test', homepage: url))).to eq url }
    it { expect(repository_finder.url(OpenStruct.new(name: 'test', homepage: '', description: "description with url #{url} ."))).to eq url }
    it { expect(repository_finder.url(OpenStruct.new(name: 'test', homepage: '', description: ''))).to be_nil }
  end
end
