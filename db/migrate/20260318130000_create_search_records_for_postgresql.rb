class CreateSearchRecordsForPostgresql < ActiveRecord::Migration[8.2]
  def up
    return unless connection.adapter_name == "PostgreSQL"

    create_table :search_records, id: :uuid do |t|
      t.uuid :account_id, null: false
      t.string :searchable_type, null: false
      t.uuid :searchable_id, null: false
      t.uuid :card_id, null: false
      t.uuid :board_id, null: false
      t.string :title
      t.text :content
      t.datetime :created_at, null: false

      t.index [:searchable_type, :searchable_id], unique: true
      t.index :account_id
    end
  end

  def down
    return unless connection.adapter_name == "PostgreSQL"

    drop_table :search_records, if_exists: true
  end
end
