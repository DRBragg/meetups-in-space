class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |table|
      table.integer :meetup_id, null: false
      table.integer :user_id, null: false
    end

    add_index :rsvps, [:meetup_id, :user_id], unique: true
  end
end
