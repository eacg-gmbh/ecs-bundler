# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ECSBundler::Scan do
  let(:data) { { name: 'test name' } }
  let(:scan) { ECSBundler::Scan.new(data) }

  describe '#new' do
    it { expect(scan.data).to eq(data) }
  end

  describe '#save' do
    after { scan.save }

    it { expect(scan).to receive(:create) }
    it do
      scan.id = 1
      expect(scan).to_not receive(:create)
    end
  end

  describe '#create' do
    it 'call rest-client post' do
      without_partial_double_verification do
        expect(ECSBundler.rest_client).to receive(:post).with("#{ECSBundler::Scan::API_PATH}#{ECSBundler::Scan::CREATE_PATH}", data)
        scan.send(:create)
      end
    end
  end

  describe '.create' do
    it 'create instance and call save method' do
      expect_any_instance_of(ECSBundler::Scan).to receive(:save)
      ECSBundler::Scan.create(data)
    end
  end
end
