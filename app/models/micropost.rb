class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :context, presence: true , length: {maximum: 140 }
  default_scope -> { order(created_at: :desc) }
end
