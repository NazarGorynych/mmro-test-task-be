class CreateBids < ActiveRecord::Migration[7.1]
  def change
    create_table :bids do |t|
      t.float :amount
      t.belongs_to :auction, foreign_key: true, index: true
      t.belongs_to :user, foreign_key: true, index: true
      t.boolean :max_by_user, default: true
      t.timestamps
    end
  end
end
