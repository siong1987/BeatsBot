class User < ActiveRecord::Base
  validates :slack_user_id, presence: true, uniqueness: true
end
