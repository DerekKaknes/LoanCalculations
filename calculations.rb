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

  def payment
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
    (payment * term).round(2)
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
    assert_equal(a.payment, 121.33)
    assert_equal(b.payment, 121.33)
    assert_equal(c.payment, 1037.03)
  end

  def test_interest_cost
    d = Loan.new(5000, 10, 0.10)
    assert_equal(d.total_cost, 7929.6)
    assert_equal(d.total_interest, 2929.6)
  end
end

