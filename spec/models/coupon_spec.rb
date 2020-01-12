require 'rails_helper'

RSpec.describe Coupon do
  describe "relationship" do
    it { should belong_to :merchant }
    it { should have_many :orders}
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :discount }
  end
end
