class AddGoogleUidToIdentities < ActiveRecord::Migration[8.2]
  def change
    add_column :identities, :google_uid, :string
    add_index  :identities, :google_uid, unique: true
  end
end
