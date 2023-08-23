# frozen_string_literal: true

# Serialized version of reservation entity to show the data to the user
module GuestSerializer
  def self.serialize(guest)
    {
      first_name: guest.first_name,
      last_name:  guest.last_name,
      phone:      guest.phone,
      email:      guest.email
    }
  end
end
