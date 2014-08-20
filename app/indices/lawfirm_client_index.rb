ThinkingSphinx::Index.define :client, :with => :active_record do
  # fields
  indexes client_name

  # attributes
  has user_id
end
