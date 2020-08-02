class CreateEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.string :value, null: false
      t.datetime :last_detected_at, null: false
      t.references :address, foreign_key: true, index: true

      t.index :value, unique: true
    end
  end
end
