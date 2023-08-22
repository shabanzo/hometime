# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe 'validations' do
    subject { build(:guest) }

    it { is_expected.to validate_uniqueness_of(:email) }
  end
end
