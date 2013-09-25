class Category < ActiveRecord::Base
  has_many :libraries
  validates :name, presence: true, length: { maximum: 60 }
  validates :description, length: { maximum: 200 }  
end
