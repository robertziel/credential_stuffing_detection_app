class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events, id: false do |t|
      t.string :name, null: false
      t.datetime :detected_at, null: false, default: -> { 'NOW()' }
      t.references :email, foreign_key: true, index: true
    end
  end
end
