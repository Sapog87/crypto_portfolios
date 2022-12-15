class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :symbol

      t.index :symbol

      t.timestamps
    end
  end
end
