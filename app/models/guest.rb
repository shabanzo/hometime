# frozen_string_literal: true

# Class object for Guest
class Guest < ApplicationRecord
  has_many :reservations

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
