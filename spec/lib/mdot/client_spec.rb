# frozen_string_literal: true

require 'rails_helper'

describe MDOT::Client do
  subject { described_class.new(user) }

  let(:user_details) do
    {
      first_name: 'Greg',
      last_name: 'Anderson',
      middle_name: 'A',
      birth_date: '1949-03-04',
      ssn: '000555555'
    }
  end

  let(:user) { build(:user, :loa3, user_details) }

  describe '#get_supplies' do
    context 'with a valid supplies response' do
      it 'returns an array of supplies' do
        VCR.use_cassette('mdot/get_supplies_200') do
          response = subject.get_supplies
          expect(response).to be_ok
          expect(response).to be_an MDOT::Response
        end
      end
    end

    context 'with an unkwown DLC service error' do
      it 'raises a BackendServiceException' do
        VCR.use_cassette('mdot/get_supplies_502') do
          expect(StatsD).to receive(:increment).once.with(
            'api.mdot.get_supplies.fail', tags: [
              'error:Common::Client::Errors::ClientError', 'status:502'
            ]
          )
          expect(StatsD).to receive(:increment).once.with(
            'api.mdot.get_supplies.total'
          )
          expect { subject.get_supplies }.to raise_error(
            MDOT::ServiceException
          ) do |e|
            expect(e.message).to match(/MDOT_502/)
          end
        end
      end
    end
  end

  describe '#submit_order' do
    let(:valid_order) do
      {
        veteranFullName: {
          first: 'Greg',
          middle: 'A',
          last: 'Anderson'
        },
        veteranAddress: {
          street: '101 Example Street',
          street2: 'Apt 2',
          city: 'Kansas City',
          state: 'MO',
          country: 'USA',
          postalCode: '64117'
        },
        order: [
          {
            productId: 1
          },
          {
            productId: 4
          }
        ],
        additionalRequests: ''
      }.to_json
    end

    context 'with a valid supplies order' do
      it 'returns a successful response' do
        VCR.use_cassette('mdot/submit_order_202') do
          response = subject.submit_order(valid_order)
          expect(response).to be_accepted
          expect(response).to be_an MDOT::Response
        end
      end
    end

    context 'with an unkwown DLC service error' do
      it 'raises a BackendServiceException' do
        VCR.use_cassette('mdot/submit_order_502') do
          expect(StatsD).to receive(:increment).once.with(
            'api.mdot.submit_order.fail', tags: [
              'error:Common::Client::Errors::ClientError', 'status:502'
            ]
          )
          expect(StatsD).to receive(:increment).once.with(
            'api.mdot.submit_order.total'
          )
          expect { subject.submit_order(valid_order) }.to raise_error(MDOT::ServiceException)
        end
      end
    end

    context 'with an malformed order' do
      it 'returns a 400 error' do
        VCR.use_cassette('mdot/submit_order_400') do
          expect(StatsD).to receive(:increment).once.with(
            'api.mdot.submit_order.fail', tags: [
              'error:Common::Client::Errors::ClientError', 'status:400'
            ]
          )
          expect(StatsD).to receive(:increment).once.with('api.mdot.submit_order.total')
          expect { subject.submit_order({}) }.to raise_error(MDOT::ServiceException)
        end
      end
    end
  end
end
