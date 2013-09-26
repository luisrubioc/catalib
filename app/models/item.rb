class Item < ActiveRecord::Base
  belongs_to :library
  validates :library_id, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :rating, numericality: { 
  																	only_integer: true, 
  																	greater_than_or_equal_to: 0,
  																	less_than_or_equal_to: 10 
  																 }
  validates :status, length: { maximum: 200 }
  validates :lent, length: { maximum: 30 }
  validates :notes, length: { maximum: 201 }
end