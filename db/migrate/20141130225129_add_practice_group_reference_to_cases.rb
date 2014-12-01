class AddPracticeGroupReferenceToCases < ActiveRecord::Migration
  def change
    add_reference :cases, :practicegroup, index: true
  end
end
