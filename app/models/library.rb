class Library < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :category_id, presence: true
  validates :description, length: { maximum: 200 }  
end
