# frozen_string_literal: true

# Class object for Guest
class Guest < ApplicationRecord
  validates :email, uniqueness: true
end
