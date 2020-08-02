class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.datetime :detected_at, null: false
      t.references :event, foreign_key: true, index: true
    end
  end
end
