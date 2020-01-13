class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :name
  validates :name, uniqueness: true, presence: true
  validates_presence_of :code
  validates :code, uniqueness: true, presence: true
  validates_presence_of :discount
  # validates :discount, numericality: { less_than_or_equal_to: 100, only_integer: true }
  validates :discount, numericality: { less_than_or_equal_to: 100 }
end
