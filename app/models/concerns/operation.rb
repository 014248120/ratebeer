module Operation
  extend ActiveSupport::Concern

  def average_rating
    if self.ratings.count == 0
      return -1
    end
    summa = self.ratings.inject(0){ |tulos, x| tulos + x.score}
    summa/self.ratings.count
  end
end
