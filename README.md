#Sample Loan Calculations

##Loan Class

```ruby
class Loan
```

Assumes a loan class that holds at least balance, term, rate attributes as well
as a monthly boolean attribute that describes whether the term is (not the rate)
is in months rather than years.

```ruby
def monthly_payment
```

Calculates the monthly payment for a Loan object.

```ruby
def total_cost
```

Calculates the total cost (sum of all payments) for a Loan object.

```ruby
def total_interest
```

Calculates the lifetime interest expense (total cost less original principal
balance) for a Loan object.


