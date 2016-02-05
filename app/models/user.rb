require 'operation'

class User < ActiveRecord::Base
  include Operation

  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_one :membership, dependent: :destroy
  has_one :beer_club, through: :membership
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: {minimum: 4}
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

end
