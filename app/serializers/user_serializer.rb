class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
