class RenamePasskeysToActionPackPasskeys < ActiveRecord::Migration[8.2]
  def change
    rename_table :passkeys, :action_pack_passkeys
  end
end
