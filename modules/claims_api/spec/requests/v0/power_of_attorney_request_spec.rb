# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Power of Attorney ', type: :request do
  let(:headers) do
    { 'X-VA-SSN': '796043735',
      'X-VA-First-Name': 'WESLEY',
      'X-VA-Last-Name': 'FORD',
      'X-VA-EDIPI': '1007697216',
      'X-Consumer-Username': 'TestConsumer',
      'X-VA-User': 'adhoc.test.user',
      'X-VA-Birth-Date': '1986-05-06T00:00:00+00:00',
      'X-VA-Gender': 'M' }
  end

  describe '#2122' do
    let(:data) { File.read(Rails.root.join('modules', 'claims_api', 'spec', 'fixtures', 'form_2122_json_api.json')) }
    let(:path) { '/services/claims/v0/forms/2122' }

    it 'should return a successful response with all the data' do
      post path, params: data, headers: headers
      parsed = JSON.parse(response.body)
      expect(parsed['data']['type']).to eq('claims_api_power_of_attorneys')
      expect(parsed['data']['attributes']['status']).to eq('submitted')
    end

    it 'should return a unsuccessful response without mvi' do
      allow_any_instance_of(ClaimsApi::Veteran).to receive(:mvi_record?).and_return(false)
      post path, params: data, headers: headers
      expect(response.status).to eq(404)
    end

    it 'should set the source' do
      post path, params: data, headers: headers
      token = JSON.parse(response.body)['data']['id']
      poa = ClaimsApi::PowerOfAttorney.find(token)
      expect(poa.source).to eq('TestConsumer')
    end

    context 'with the same request already ran' do
      let!(:count) do
        post path, params: data, headers: headers
        ClaimsApi::PowerOfAttorney.count
      end

      it 'should reject the duplicated request' do
        post path, params: data, headers: headers
        expect(count).to eq(ClaimsApi::PowerOfAttorney.count)
      end
    end

    context 'validation' do
      let(:json_data) { JSON.parse data }

      it 'should require poa_code subfield' do
        params = json_data
        params['data']['attributes']['poa_code'] = nil
        post path, params: params.to_json, headers: headers
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['errors'].size).to eq(1)
      end
    end
  end
end
