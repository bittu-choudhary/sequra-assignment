class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.string :code, null: false, unique: true

      t.timestamps
    end
  end
end
