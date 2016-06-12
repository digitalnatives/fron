require 'date'

# Methods for date class
class Date
  class << self
    # Returns a range for this week
    #
    # @return [Range] The days as range
    def this_week
      Date.week(Date.today)
    end

    # Returns a range for last week
    #
    # @return [Range] The days as range
    def last_week
      Date.week(Date.today - 7)
    end

    # Returns the monday of the current week
    #
    # @return [Date] The date
    def monday(date = Date.today)
      today = date
      day = today.wday
      diff = case day
             when 0
               6
             when 1..6
               day - 1
             end
      today - diff
    end

    # Returns the week days in the current week
    #
    # @return [Range] The days as range
    def week(date = Date.today)
      day = monday(date)
      (day..day + 6)
    end
  end

  # Returns the begging of the month
  #
  # @return [Date] The date
  def beginning_of_month
    self.class.new year, month, 1
  end

  # Returns the end of the month
  #
  # @return [Date] The date
  def end_of_month
    self.class.new year, month + 1, 0
  end
end
