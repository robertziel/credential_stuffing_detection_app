class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.inet :ip, null: false
      t.datetime :banned_at

      t.index :ip, unique: true
    end
  end
end
