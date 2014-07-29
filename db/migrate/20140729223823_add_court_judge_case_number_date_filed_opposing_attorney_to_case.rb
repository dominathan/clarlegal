class AddCourtJudgeCaseNumberDateFiledOpposingAttorneyToCase < ActiveRecord::Migration
  def change
    add_column :cases, :court, :string
    add_column :cases, :case_number, :string
    add_column :cases, :opposing_attorney, :string
    add_column :cases, :judge, :string
    rename_column :cases, :description, :type_of_matter
    rename_column :cases, :matter_reference, :related_cases
  end
end
