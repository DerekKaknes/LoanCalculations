require "rubygems"
gem "test-unit"
require "test/unit"

class Loan
  attr_reader :balance, :term, :rate
  def initialize(balance, term, rate, options = {})
    @balance = balance
    @term = term
    @rate = rate
    @annualized = options[:annualized]
  end

  def monthly_payment
    if @annualized
      i = @rate
    else
      i = @rate / 12.0
    end

    frac = (i + i / ((1+i)**@term - 1))
    pmt = @balance * frac
    pmt.round(2)
  end

  def total_cost
    (monthly_payment * @term).round(2)
  end

  def total_interest
    (total_cost - @balance).round(2)
  end

  def payoff_balance(m)
    if @annualized
      i = @rate
    else
      i = @rate / 12.0
    end

    r = i + 1.00
    @balance*r**m - monthly_payment * (r**m -1) / (r-1)
  end

  def rel_err
    payoff_balance(@term) / @balance
  end
end

class TestLoan < Test::Unit::TestCase
  def test_payment
    a = Loan.new(10000,120,0.08)
    c = Loan.new(5000, 120, 0.10)
    assert_equal(a.monthly_payment, 121.33)
    assert_equal(c.monthly_payment, 66.08)
  end

  def test_interest_cost
    d = Loan.new(5000, 120, 0.10)
    e = Loan.new(10000, 120, 0.08)
    assert_equal(d.total_cost, 7929.6)
    assert_equal(d.total_interest, 2929.6)
    assert_equal(e.total_cost, 14559.6)
    assert_equal(e.total_interest, 4559.6)
  end

  def test_payoff_balance
    f = Loan.new(10000,120,0.08)
    g = Loan.new(10**10, 120, 0.08)
    h = Loan.new(1000, 120, 0.08)
    i = Loan.new(1000, 120, 0.20)
    j = Loan.new(1000, 120, 0.01)
    k = Loan.new(1000, 360, 0.08)
    tol = 0.001
    assert_equal(f.payoff_balance(0), 10000)
    assert(f.rel_err < tol, "Relative Error was #{f.rel_err * 100.0}")
    assert(h.rel_err < tol, "Relative Error was #{h.rel_err * 100.0}")
    assert(j.rel_err < tol, "Relative Error was #{j.rel_err * 100.0}")
    assert(i.rel_err < tol, "Relative Error was #{i.rel_err * 100.0}")
    assert(g.rel_err < tol, "Relative Error was #{g.rel_err * 100.0}")
    assert(k.rel_err < tol, "Relative Error was #{k.rel_err * 100.0}")
  end
end
