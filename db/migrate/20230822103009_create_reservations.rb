class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code, unique: true
      t.date :start_date
      t.date :end_date
      t.integer :nights
      t.integer :guests
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.string :status
      t.string :currency
      t.string :payout_price
      t.string :security_price
      t.string :total_price
      t.references :guest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
