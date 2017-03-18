class Group < ApplicationRecord
  belongs_to :user
  has_many :posts

  validates :title, presence: true
  validates :description, presence: true
  scope :recent, -> {order("created_at DESC")}
end
