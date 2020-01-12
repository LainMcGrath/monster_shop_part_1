class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :name
  validates_presence_of :code
  validates_presence_of :discount
end
