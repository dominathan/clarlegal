ThinkingSphinx::Index.define :client, :with => :active_record do
  # fields
  indexes first_name
  indexes last_name
  indexes email

  # attributes
  has user_id
end
