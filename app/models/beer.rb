require 'operation'

class Beer < ActiveRecord::Base
  include Operation

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true

  def to_s
    "#{if !self.brewery.nil? then self.brewery.name + " " end}#{self.name}"
  end
end
