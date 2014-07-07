class DropTableUtilizations < ActiveRecord::Migration
  def change
    drop_table :utilizations
  end
end
