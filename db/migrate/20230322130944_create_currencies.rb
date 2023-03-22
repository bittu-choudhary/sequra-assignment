class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies, id: :uuid do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
