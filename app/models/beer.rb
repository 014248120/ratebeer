require 'operation'

class Beer < ActiveRecord::Base
  include Operation

  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{if !self.brewery.nil? then self.brewery.name + " " end}#{self.name}"
  end

  def self.top(n)
    rated = Beer.all.select{ |b| b.ratings.count>0 }
    sorted = rated.sort_by{ |b| -(b.average_rating)||0 }
    sorted.first(n)
  end
end
