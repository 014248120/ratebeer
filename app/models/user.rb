require 'operation'

class User < ActiveRecord::Base
  include Operation

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_one :membership, dependent: :destroy
  has_one :beer_club, through: :membership
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4 }
  validate :password_has_one_numeric
  validate :password_has_one_capital

  def password_has_one_numeric
    if not password =~ /[[:digit:]]/
      errors.add(:password, "has to have at least one numeric")
    end
  end

  def password_has_one_capital
    if not password =~ /[A-Z]/
      errors.add(:password, "has to have at least one upper case letter")
    end
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    rated('styles').sort_by { |s| average_rating_for('style', s) }.reverse.first
  end

  def favorite_brewery
    rated('breweries').sort_by { |b| average_rating_for('brewery', b) }.reverse.first
  end

  def self.most_active n
    raters = User.all.select{ |u| u.ratings.count>0 }
    sorted = raters.sort_by { |u| -(u.ratings.count)||0}
    sorted.first(n)
  end

  def frozen?
    banned==true
  end

#HELPER METODIT

  def rated(attribute) 
    case attribute
      when 'styles' then ratings.map { |r| r.beer.style }.uniq
      when 'breweries' then ratings.map { |r| r.beer.brewery }.uniq
      when 'beers' then ratings.map { |r| r.beer }.uniq
    end
  end  

  def average_rating_for(attribute, object)
    arr = case attribute
      when 'style' then ratings.find_all{ |r| r.beer.style==object }
      when 'brewery' then ratings.find_all{ |r| r.beer.brewery==object }
      when 'beer' then ratings.find_all{ |r| r.beer==object }
    end
    average(arr)
  end

end
