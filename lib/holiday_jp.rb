# -*- coding: utf-8 -*-
require 'holiday_jp/holiday'
require 'holiday_jp/holidays'
require 'active_support/core_ext/date'

module HolidayJp
  # == Between date
  # === Example:
  #  >> holidays = HolidayJp.between(Date.new(2010, 9, 14), Date.new(2010, 9, 21))
  #  >> holidays.first.name # 敬老の日
  # === parameters
  # * <tt>start</tt>
  # * <tt>last</tt>
  def self.between(start, last)
    HOLIDAYS.find_all do |date, holiday|
      start <= date && date <= last
    end.map(&:last)
  end

  # == Whether the date is holiday or not.
  # === Example:
  # >> HolidayJp.holiday?(Date.new(2011, 9, 19)) # => true
  # === parameter(s)
  # * <tt>date</tt>
  def self.holiday?(date)
    !HOLIDAYS[date].nil?
  end

  def self.next_holidays(date = Date.today)
    next_holidays_from(date)
  end

  def self.next_holidays_from(date)
    period = next_holiday_from(date)..next_holiday_from(date)
    possible_holiday(period, 1)
  end

  def self.next_holiday
    next_holiday_from Date.today
  end

  def self.next_holiday_from(date_start)
    last_holiday = HOLIDAYS.keys.last

    (date_start..last_holiday).each do |date|
      return date if holiday?(date)
    end
  end

  def self.possible_new_year_holiday(year = Date.today.year)
   period = minimum_new_year_holiday(year)
   possible_holiday(period)
  end

  def self.possible_golden_week(year = Date.today.year)
    period = minimum_golden_week(year)
    possible_holiday(period)
  end

  def self.possible_silver_week(year = Date.today.year)
    period = minimum_silver_week(year)
    possible_holiday(period)
  end

  private

  # Assume you can take two days of on your own. And, if there is
  # adjacent weekend, we can combine it with the holiday. So, here
  # we add up 4 to the edge of holiday.
  def self.possible_holiday(period, surrounding_days = 5)
    beggining = nil
    ending = nil

    possibility = period.first.advance(days: -surrounding_days)..period.last.advance(days: surrounding_days)
    possibility.each {|date|
      if beggining.nil? && day_off?(date)
        beggining = date
      elsif day_off?(date)
        ending = date
      end
    }
    beggining..ending
  end
end
