class ChanceColumnNameInOrigination < ActiveRecord::Migration
  def change
    rename_column :originations, :exisitng_client, :existing_client
  end
end
