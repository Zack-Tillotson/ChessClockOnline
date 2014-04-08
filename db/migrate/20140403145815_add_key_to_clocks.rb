class AddKeyToClocks < ActiveRecord::Migration
  def change
    add_column :clocks, :key, :string
  end
end
