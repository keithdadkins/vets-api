# frozen_string_literal: true

class SessionActivity < ApplicationRecord
  SESSION_ACTIVITY_TYPES = %w[signup mhv dslogon idme mfa verify slo].freeze

  # Initial validations on creation
  validates :originating_request_id, presence: true
  validates :originating_ip_address, presence: true
  validates :name, presence: true, inclusion: { in: SESSION_ACTIVITY_TYPES }
  validates :status, presence: true, inclusion: { in: %w[incomplete success fail] }

  # Additional validations on update
  # TODO: add these later.

  def update_success
    update(status: 'success')
  end

  def update_fail
    update(status: 'fail')
  end
end
