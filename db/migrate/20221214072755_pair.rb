class Pair < ActiveRecord::Migration[7.0]
  def change
    rename_column :pairs, :from, :coin1
    rename_column :pairs, :to, :coin2
  end
end
