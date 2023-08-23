# frozen_string_literal: true

# Serialized version of reservation entity to show the data to the user
module ReservationSerializer
  def self.serialize(reservation)
    {
      code:           reservation.code,
      start_date:     reservation.start_date,
      end_date:       reservation.end_date,
      nights:         reservation.nights,
      guests:         reservation.guests,
      adults:         reservation.adults,
      children:       reservation.children,
      infants:        reservation.infants,
      status:         reservation.status,
      currency:       reservation.currency,
      payout_price:   reservation.payout_price,
      security_price: reservation.security_price,
      total_price:    reservation.total_price,
      guest:          GuestSerializer.serialize(reservation.guest)
    }
  end
end
