class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.references :address, foreign_key: true, index: true, null: false

      t.index :name, unique: true
    end
  end
end
