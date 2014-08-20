ThinkingSphinx::Index.define :case, :with => :active_record do
  indexes :name
  indexes type_of_matter
  indexes practice_group
  indexes case_number
  indexes opposing_attorney
  indexes judge
  indexes description

  has client_id
end
