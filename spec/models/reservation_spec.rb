# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:guest) }
  end

  describe 'validations' do
    subject { build(:reservation) }  # Assuming you're using FactoryBot for test data

    it { is_expected.to validate_uniqueness_of(:code) }
    it { is_expected.to validate_inclusion_of(:status).in_array(described_class.statuses.keys) }
  end
end
