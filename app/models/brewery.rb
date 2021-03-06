require 'operation.rb'
require 'year_validation.rb'

class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  include Operation
  include YearValidation

  validates :name, presence: true, uniqueness: true
  validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
  validate :year_cannot_be_in_the_future

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year=Date.today.year
    puts "changed year to #{year}"
  end

  def self.top n
    rated = Brewery.all.select{ |b| b.ratings.count>0 }
    sorted = rated.sort_by{ |b| -(b.average_rating)||0 }
    sorted.first(n)
  end

end
