# -*- coding: utf-8 -*-
require 'helper'

class TestHolidayJp < Test::Unit::TestCase
  should '#between return correct holidays' do
    holidays = HolidayJp.between(Date.new(2009, 1, 1), Date.new(2009, 1, 31))
    new_year_day = holidays[0]
    assert_equal new_year_day.date, Date.new(2009, 1, 1)
    assert_equal new_year_day.name, '元日'
    assert_equal new_year_day.name_en, "New Year's Day"
    assert_equal new_year_day.week, '木'
    assert_equal new_year_day.wday_name, '木'
    assert_equal holidays[1].date, Date.new(2009, 1, 12)
    assert_equal holidays[1].name, '成人の日'
    holidays = HolidayJp.between(Date.new(2008, 12, 23), Date.new(2009, 1, 12))
    assert_equal holidays[0].date, Date.new(2008, 12, 23)
    assert_equal holidays[1].date, Date.new(2009, 1, 1)
    assert_equal holidays[2].date, Date.new(2009, 1, 12)
  end

  should '#holiday?(date) returns date is holiday or not' do
    assert HolidayJp.holiday?(Date.new(2011, 9, 19))
    assert !HolidayJp.holiday?(Date.new(2011, 9, 18))
  end

  should 'Mountain Day from 2016' do
    assert !HolidayJp.holiday?(Date.new(2015, 8, 11))
    (2016..2050).each do |year|
      assert HolidayJp.holiday?(Date.new(year, 8, 11))
    end
  end

  should "#next_holiday_from '2014-09-28' is '2014-10-03'" do
    expected = Date.new(2014, 10, 13)
    actual = HolidayJp.next_holiday_from(Date.new(2014, 9, 28))
    assert_equal expected, actual
  end

  should "#possible_new_year_holiday(2014) starts on 27th Sat Dec, 2014 and ends on 4th Sun Jan, 2015" do
    expected = Date.new(2014, 12, 27)..Date.new(2015, 1, 4)
    actual = HolidayJp.possible_new_year_holiday(2014)
    assert_equal expected, actual
  end

  # This case has Constitution Memorial Day observed on 6th May. So,
  # holiday ends on 10th May Sunday 2014.
  should "#possible_golden_week(2015) starts on 25th Sat Apr, 2015 and ends on 10th Sun May, 2015" do
    expected = Date.new(2015, 4, 25)..Date.new(2015, 5, 10)
    actual = HolidayJp.possible_golden_week(2015)
    assert_equal expected, actual
  end

  should "#possible_silver_week(2015) starts on 19th Sep Sat, 2015 and ends on 27th Sep Sun, 2015" do
    expected = Date.new(2015, 9, 19)..Date.new(2015, 9, 27)
    actual = HolidayJp.possible_silver_week(2015)
    assert_equal expected, actual
  end

  should "#next_holidays 2014-11-23 starts on 22nd Nov Sat, 2014, and ends on 24th Nov Mon, 2014" do
    expected = Date.new(2014, 11, 22)..Date.new(2014, 11, 24)
    actual = HolidayJp.next_holidays_from(Date.new(2014, 11, 23))
    assert_equal expected, actual
  end
end
