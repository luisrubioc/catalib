class Item < ActiveRecord::Base
  belongs_to :library
  validates :library_id, presence: true
  validates :title, presence: true, length: { maximum: 60 }
  validates :rating, allow_nil: true, numericality: { only_integer: true, 
                    																  greater_than_or_equal_to: 0,
                    																  less_than_or_equal_to: 10
                                                    }
  validates :status,
            presence: true,
            length: { maximum: 100 },
            inclusion: { :in => AppConfig['valid_item_status'] }
  validates :lent, length: { maximum: 30 }
  validates :notes, length: { maximum: 201 }
end