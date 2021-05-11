class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards
  has_many :votes, dependent: :destroy

  def author?(object)
    id == object.user_id
  end

  def voted?(object)
    !votes.where(votable: object).empty?
  end
end
