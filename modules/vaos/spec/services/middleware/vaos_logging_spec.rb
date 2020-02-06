# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/fixture_helper'

describe VAOS::Middleware::VaosLogging do

  subject(:client) do
    Faraday.new do |conn|
      conn.use :vaos_logging, service_name

      conn.adapter:test do |stub|
        stub.get('success') { [200, { 'Content-Type' => 'text/plain' }, response_data] }
        stub.post(user_service_uri) { [200, { 'Content-Type' => 'text/plain' }, response_data] }
      end
    end
  end

  let(:service_name) { 'jalepeno' }
  let(:response_data) { 'eyJhbGciOiJSUzUxMiJ9.eyJsYXN0TmFtZSI6Ik1vcmdhbiIsInN1YiI6IjEwMTI4NDU5NDNWOTAwNjgxIiwiYXV0aGVudGljYXRlZCI6dHJ1ZSwiYXV0aGVudGljYXRpb25BdXRob3JpdHkiOiJnb3YudmEudmFvcyIsImlkVHlwZSI6IklDTiIsImlzcyI6Imdvdi52YS52YW1mLnVzZXJzZXJ2aWNlLnYxIiwidmFtZi5hdXRoLnJlc291cmNlcyI6WyJeLiooXC8pP3BhdGllbnRbc10_XC8oSUNOXC8pPzEwMTI4NDU5NDNWOTAwNjgxKFwvLiopPyQiLCJeLiooXC8pP3NpdGVbc10_XC8oZGZuLSk_OTg0XC9wYXRpZW50W3NdP1wvNTUyMTYxNzMyXC9hcHBvaW50bWVudHMoXC8uKik_JCIsIl4uKihcLyk_c2l0ZVtzXT9cLyhkZm4tKT85ODNcL3BhdGllbnRbc10_XC83MjE2NjkwXC9hcHBvaW50bWVudHMoXC8uKik_JCJdLCJ2ZXJzaW9uIjoyLjEsInZpc3RhSWRzIjpbeyJwYXRpZW50SWQiOiI1NTIxNjE3MzIiLCJzaXRlSWQiOiI5ODQifSx7InBhdGllbnRJZCI6IjcyMTY2OTAiLCJzaXRlSWQiOiI5ODMifV0sImZpcnN0TmFtZSI6IkNlY2lsIiwic3RhZmZEaXNjbGFpbWVyQWNjZXB0ZWQiOnRydWUsIm5iZiI6MTU3MDczMTExNiwicGF0aWVudCI6eyJmaXJzdE5hbWUiOiJDZWNpbCIsImxhc3ROYW1lIjoiTW9yZ2FuIiwiaWNuIjoiMTAxMjg0NTk0M1Y5MDA2ODEifSwidXNlclR5cGUiOiJWRVRFUkFOIiwidmFtZi5hdXRoLnJvbGVzIjpbInZldGVyYW4iXSwicmlnaHRPZkFjY2Vzc0FjY2VwdGVkIjp0cnVlLCJleHAiOjE1NzA3MzIxOTYsImp0aSI6ImViZmM5NWVmNWYzYTQxYTdiMTVlNDMyZmU0N2U5ODY0IiwibG9hIjoyfQ.HD2xgVYoCmF87XLlgawiCvddtkhQ0mOj7T00kh02ygY8cQhoYiylH9DaQRiFg-ymsf0xA-BHP4JqrDXLKho7wTJceRBfeYRysUSa0bbRVDPPeEuQF0f96DCTsL_t6ZRJB72fL4yK-Z5jovGVD8yYX6Fg4j9IJhGN2ibwJwjS6bS4I7quhm_29SjRNtjgPlvM87Lz9xg3KDHjcHBfthOvhcsnvwcsQnVKyvyM4ujy7nUqTF8qyJdFflDLC1F3KbY0W5IcJwR1R226Jp7K8tsfmWaZOWWD_1BITQBbdl-0jfgWcdpxpv67WBAkv3Lw9DN5dplOuan5DqN-ZTMun8ub0A' }
  let(:user_service_uri) {'https://veteran.apps.va.gov/users/v2/session?processRules=true'}

  before { Settings.va_mobile.key_path =  fixture_file_path('open_ssl_rsa_private.pem') }

  it 'is a temp test to check for failure' do
    client.post(user_service_uri)
 #   expect('not nil').to be_nil
  end

  # test for exception during call

end
