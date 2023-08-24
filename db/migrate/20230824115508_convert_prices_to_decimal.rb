class ConvertPricesToDecimal < ActiveRecord::Migration[7.0]
  def up
    change_column :reservations, :payout_price, :decimal, precision: 10, scale: 2
    change_column :reservations, :security_price, :decimal, precision: 10, scale: 2
    change_column :reservations, :total_price, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :reservations, :payout_price, :string
    change_column :reservations, :security_price, :string
    change_column :reservations, :total_price, :string
  end
end
