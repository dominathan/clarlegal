ThinkingSphinx::Index.define :client, :with => :active_record do
  # fields
  indexes client_name
  indexes client_email

  # attributes
  has user_id
end
