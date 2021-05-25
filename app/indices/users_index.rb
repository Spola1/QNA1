ThinkingSphinx::Index.define :user, with: :active_record do
  # fileds
  indexes email, sortable: true
  indexes admin, sortable: true

  # attributes
  has created_at, updated_at
end
