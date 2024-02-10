class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.float :amount
      t.float :reserved_amount
      t.belongs_to :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
