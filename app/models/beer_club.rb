require 'year_validation'

class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  include YearValidation

  validates :name, presence: true, uniqueness: true
  validates :year, presence: true, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validate :year_cannot_be_in_the_future
  
  def year
    founded
  end
  def to_s
    "#{self.name}"
  end
end
