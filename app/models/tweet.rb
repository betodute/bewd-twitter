class Tweet < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :message, presence: true, length: {minimum: 0, maximum: 140}
end
