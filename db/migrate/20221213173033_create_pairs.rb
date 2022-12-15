class CreatePairs < ActiveRecord::Migration[7.0]
  def change
    create_table :pairs do |t|
      t.string :pair, null: false
      t.string :from, null: false
      t.string :to, null: false

      t.index :to
      t.index :from

      t.timestamps
    end
  end
end
