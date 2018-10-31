class CreateStripeInfomations < ActiveRecord::Migration[5.2]
  def change
    create_table :stripe_infomations do |t|
      t.integer :stripe_customer_id
      t.references :user, foreign_key: true
      t.integer :credit_no_last4

      t.timestamps
    end
  end
end
