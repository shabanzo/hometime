# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest, type: :model do
  it 'is valid with a valid email' do
    guest = described_class.new(email: 'test@example.com')
    expect(guest).to be_valid
  end

  it 'is invalid with an invalid email' do
    guest = described_class.new(email: 'invalid-email')
    expect(guest).to be_invalid
    expect(guest.errors[:email]).to include('is invalid')
  end

  it 'is invalid with a duplicate email' do
    create(:guest, email: 'test@example.com')
    guest = described_class.new(email: 'test@example.com')
    expect(guest).to be_invalid
    expect(guest.errors[:email]).to include('has already been taken')
  end
end
