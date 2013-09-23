class Library < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :description, length: { maximum: 200 }
  validates :content, presence: true, length: { maximum: 60 }
end
