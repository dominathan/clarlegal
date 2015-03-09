class RemoveDefaultFromReferral < ActiveRecord::Migration
  def change
    change_column_default :fees, :referral, nil
  end
end
