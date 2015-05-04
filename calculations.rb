require "rubygems"
gem "test-unit"
require "test/unit"

class Loan
  def initialize(balance, term, rate, options = {})
    @balance = balance
    @term = term
    @rate = rate
    @monthly = options[:monthly]
  end

  def monthly_payment
    if @monthly
      i = @rate / 12.0
      num_pmts = @term
    else
      i = @rate / 12.0
      num_pmts = @term * 12
    end

    frac = (i + i / ((1+i)**num_pmts - 1))
    pmt = @balance * frac
    pmt.round(2)
  end

  def total_cost
    if @monthly
      term = @term
    else
      term = @term * 12
    end
    (monthly_payment * term).round(2)
  end

  def total_interest
    (total_cost - @balance).round(2)
  end
end

class TestLoan < Test::Unit::TestCase
  def test_payment
    a = Loan.new(10000,10,0.08)
    b = Loan.new(10000, 120, 0.08, {monthly: true})
    c = Loan.new(10000, 10, 0.08, {monthly: true})
    assert_equal(a.monthly_payment, 121.33)
    assert_equal(b.monthly_payment, 121.33)
    assert_equal(c.monthly_payment, 1037.03)
  end

  def test_interest_cost
    d = Loan.new(5000, 10, 0.10)
    e = Loan.new(10000, 10, 0.08)
    assert_equal(d.total_cost, 7929.6)
    assert_equal(d.total_interest, 2929.6)
    assert_equal(e.total_cost, 14559.6)
    assert_equal(e.total_interest, 4559.6)
  end
end

