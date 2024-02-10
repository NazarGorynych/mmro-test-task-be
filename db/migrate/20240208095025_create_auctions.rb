class CreateAuctions < ActiveRecord::Migration[7.1]
  def change
    create_table :auctions do |t|
      t.string :title
      t.text :description
      t.float :min_bid
      t.float :min_bid_diff
      t.integer :bid_type, default: 0
      t.integer :status, default: 0
      t.timestamp :start_date
      t.timestamp :end_date
      t.integer :winner_id
      t.belongs_to :user, foreign_key: true, index: true
      t.timestamps
    end
  end
end
