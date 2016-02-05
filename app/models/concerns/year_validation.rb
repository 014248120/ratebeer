module YearValidation
  extend ActiveSupport::Concern

  def year_cannot_be_in_the_future
    if year and year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
  end
end
