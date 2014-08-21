class RemoveUserReferencesCases < ActiveRecord::Migration
  def change
    remove_reference :cases, :user
  end
end
