require 'csv'
class CaseType < ActiveRecord::Base
  belongs_to :lawfirm

  validates :lawfirm_id, presence: true
  validates :mat_ref, uniqueness: {scope: :lawfirm_id}



  def self.import(file,user)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if !CaseType.where(mat_ref: row["Matter Name"], lawfirm_id: user.lawfirm.id).empty?
        mat_ref = CaseType.find_by(mat_ref: row["Matter Name"], lawfirm_id: user.lawfirm.id)
        mat_ref.update_attributes(mat_ref: row["Matter Name"],
                               external_id: row['External ID'])
        mat_ref.save
      else
        CaseType.create(mat_ref: row["Matter Name"],
                        external_id: row["External ID"],
                        lawfirm_id: user.lawfirm_id)
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
