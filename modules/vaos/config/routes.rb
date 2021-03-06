# frozen_string_literal: true

VAOS::Engine.routes.draw do
  defaults format: :json do
    resources :appointments, only: %i[index create] do
      put 'cancel', on: :collection
    end
    resources :appointment_requests, only: %i[index create update] do
      resources :messages, only: %i[index create]
    end
    get 'community_care/eligibility/:service_type', to: 'cc_eligibility#show'
    get 'community_care/supported_sites', to: 'cc_supported_sites#index'
    resources :systems, only: :index do
      resources :direct_scheduling_facilities, only: :index
      resources :pact, only: :index
      resources :clinic_institutions, only: :index
    end
    resources :facilities, only: :index do
      resources :clinics, only: :index
      resources :cancel_reasons, only: :index
      resources :available_appointments, only: :index
      resources :limits, only: :index
      get 'visits/:schedule_type', to: 'visits#index'
    end
    resource :preferences, only: %i[show update]
    get 'apidocs', to: 'apidocs#index'
  end
end
