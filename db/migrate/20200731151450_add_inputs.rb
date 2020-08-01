class AddInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :inputs, id: false do |t|
      t.string :email, null: false
      t.string :event_name, null: false
      t.inet :ip, null: false
      t.datetime :detected_at, null: false, default: -> { 'NOW()' }
    end
  end
end
