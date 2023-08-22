# frozen_string_literal: true

# Class object for Reservation
class Reservation < ApplicationRecord
  belongs_to :guest

  enum statuses: %w[pending accepted cancelled completed].freeze

  validates :code, uniqueness: true
  validates :status, inclusion: { in: statuses.keys }
end
