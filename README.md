# Practice with ActiveRecord basics

**NOTE: Do not clone this repo.  Fork it first, then clone your fork.**

For this assignment we've created a database of 100 fake customers,
with fake names, fake email addresses, and fake birthdates (courtesy
of the [Faker gem](https://github.com/stympy/faker)).

You will write various ActiveRecord queries to extract and/or update
subsets of these customers.

About 75% of the customers have a (syntactically) valid email address;
about 20% have no email address; and about 5% have a syntactically
invalid email address.  The rules for syntactically valid email
addresses are complicated, but we will simplistically say an email
address is invalid if it does not include the '@' character.

The files in this assignment are:

* `activerecord_practice.rb`, where you will fill in your code

* `customers.sqlite3`, the database containing the fake customers

* `customers_orig.sqlite3`, a backup copy of the database. If you need
  to revert the database to its original form, just copy this file to
  `customers.sqlite3`.
  
* `spec/activerecord_practice_spec.rb`, containing RSpec tests that
will check the result of each query you write.

* `Guardfile`, to enable automatic test running: each time you make a
change to your file, tests are re-run automatically.

* `customers.csv`, a version of the customer list that you can
open in Excel or Google Sheets if you want to manually check your
results

