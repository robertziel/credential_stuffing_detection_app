class AddInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :inputs do |t|
      t.string :email, null: false
      t.string :event_name, null: false
      t.inet :ip, null: false

      t.timestamps
    end
  end
end
