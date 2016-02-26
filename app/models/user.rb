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
    rated_styles.sort_by { |s| average_rating_for_style(s) }.reverse.first
  end

  def favorite_brewery
    rated_breweries.sort_by { |b| average_rating_for_brewery(b) }.reverse.first
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
  def rated_styles
    styles = ratings.map { |r| r.beer.style }
    styles.to_set
  end

  def average_rating_for_style(style)
    arr = ratings.find_all{ |r| r.beer.style==style }
    average(arr)
  end

  def rated_breweries
    b = ratings.map { |r| r.beer.brewery }
    b.to_set
  end

  def average_rating_for_brewery(brewery)
    arr = ratings.find_all{ |r| r.beer.brewery==brewery }
    average(arr)
  end

end
