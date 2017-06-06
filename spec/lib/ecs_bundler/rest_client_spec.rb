# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ECSBundler::Scan do
  let(:options) { { userAgent: 'userAgent', apiKey: 'apiKey', userName: 'userName', url: 'url' } }
  let(:rest_client) { ECSBundler::RestClient.new(options) }

  describe '#new' do
    it { expect(rest_client.options).to eq(options) }
  end

  describe '#headers' do
    it { expect(rest_client.headers).to be_an_instance_of(Hash) }
    it { expect(rest_client.headers).to include(content_type: :json, accept: :json, 'User-Agent' => 'userAgent', 'X-ApiKey' => 'apiKey', 'X-User' => 'userName') }
  end

  describe '#respond_to_missing?' do
    it { expect(rest_client.respond_to?(:get)).to be_truthy }
    it { expect(rest_client.respond_to?(:post)).to be_truthy }
    it { expect(rest_client.respond_to?(:poster)).to be_falsey }
  end

  describe '#method_missing' do
    it do
      expect(::RestClient::Request).to receive(:execute).with(method: :get, url: 'url/get', payload: nil, headers: rest_client.headers)
      rest_client.get('/get')
    end

    it do
      data = { test: 1 }
      expect(::RestClient::Request).to receive(:execute).with(method: :post, url: 'url/post', payload: data.to_json, headers: rest_client.headers)
      rest_client.post('/post', data)
    end

    it { expect { rest_client.check('/post') }.to raise_error(NoMethodError) }

    it do
      body = { 'info' => 'info message', 'messages' => [{ 'message' => 'message#1' }] }
      response = double
      allow(response).to receive(:code).and_return(400)
      expect(response).to receive(:body).and_return(body.to_json)
      expect(::RestClient::Request).to receive(:execute).and_yield(response)
      rest_client.post('/post', {}) do |result_response, parsed_response, message|
        expect(result_response).to eq response
        expect(parsed_response).to eq body
        expect(message).to eq '400 Bad Request, info message, message#1'
      end
    end
  end
end
