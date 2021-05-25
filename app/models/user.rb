class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions,  dependent: :destroy
  has_many :answers,    dependent: :destroy
  has_many :awards
  has_many :votes,      dependent: :destroy
  has_many :comments,   dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author?(object)
    id == object.user_id
  end

  def voted?(object)
    !votes.where(votable: object).empty?
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["omniauth"]
        password = Devise.friendly_token[0, 20]
        user.password = password
        user.password_confirmation = password
      end
    end
  end

  def subscribed?(question)
    subscriptions.where(question_id: question.id).any?
  end
end
