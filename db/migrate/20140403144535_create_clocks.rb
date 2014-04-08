class CreateClocks < ActiveRecord::Migration
  def change
    create_table :clocks do |t|
      t.boolean :active
      t.integer :current_player
      t.float :player_one_time
      t.float :player_two_time

      t.timestamps
    end
  end
end
