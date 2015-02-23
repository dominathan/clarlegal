class DefaultClientCompanyValueIsEmptyString < ActiveRecord::Migration
  def change
    change_column_default :clients,:company,""
  end
end
