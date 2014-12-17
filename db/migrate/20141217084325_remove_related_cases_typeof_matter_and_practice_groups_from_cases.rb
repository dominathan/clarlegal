class RemoveRelatedCasesTypeofMatterAndPracticeGroupsFromCases < ActiveRecord::Migration
  def change
    remove_column :cases, :type_of_matter
    remove_column :cases, :related_cases
    remove_column :cases, :practice_group
  end
end
