# Practice with ActiveRecord basics

For this assignment we've created a database of 30 fake customers, with fake names, fake email addresses, and fake birthdates (courtesy of the [Faker gem](https://github.com/stympy/faker)).

You will write various ActiveRecord queries to extract and/or update subsets of these customers.

As a bonus, you'll get more experience using "continuous testing", in which every time you make a change to code or tests, a whole set of automated tests are automatically re-run.  This way you can get into a "groove" of coding and testing without manually re-running the provided tests to see if your code is correct.

The files in this assignment are:

* `lib/activerecord_practice.rb`, where you will fill in your code. In non-Rails Ruby projects (gems, standalone apps, etc.), `lib` (historically, derived from "library") is where code files typically live.

* `spec/activerecord_practice_spec.rb` (the "specfile"), containing RSpec tests that will check the result of each query you write.

* `customers.sqlite3`, the database containing the fake customers

* `customers.csv`, a version of the customer list that you can open in Excel or Google Sheets if you want to manually check your results

* `Guardfile`, to enable automatic test running: each time you make a change to your file, tests are re-run automatically.

* `Gemfile` and `Gemfile.lock`, as usual

## Prerequisites

If you have never worked with relational databases before, we strongly recommend you get some very basic background: [Intro to Relational Databases](https://lagunita.stanford.edu/courses/DB/RDB/SelfPaced/about) and [Relational Algebra](https://lagunita.stanford.edu/courses/DB/RA/SelfPaced/about), two short (~30 minute) self-paced courses from Stanford's highly-respected database group.

## Preparation

1. In the toplevel directory of the assignment, run `bundle` to make sure you have the necessary Gems.

1. Suggested: make a copy of the file `customers.sqlite3`, which is the SQLite database used in these exercises.  That way if you accidentally get the database into a state from which you can't restore it, you can just restore from your backup file. 



## Background Information

Your goal is to write ActiveRecord queries against the fake customer database whose schema is as follows:

`first`, `last` (first and last name): String

`email`: String

`birthdate`:  Datetime

Each query you will write will be "wrapped" in its own class method of `class Customer < ActiveRecord::Base`, which is defined in `activerecord_practice.rb`.

However, you won't execute this file directly.  Instead, you will use the specfile, contains a test for each of the queries you must write.  

* Run the test file once with `bundle exec rspec spec/activerecord_practice_spec.rb`.  (Recall that `bundle exec` is needed to ensure that the correct version(s) of required gem(s) are properly loaded and activated before your code runs.)  The result should be "13 examples, 0 failures, 13 pending."

We've set up the tests so that initially all tests are skipped.  (They would all fail, because you haven't written the code for them yet.) Open the specfile and take a look. Your workflow will be as follows:

1. Pick an example to work on (we recommend doing them in order). Each example (test case) begins with `xspecify`.

2. In that example, change `xspecify` to `specify` and save the file; this change will cause that particular test _not_ to be skipped on the next testing run

3. The test will immediately fail because you haven't written the needed code

4. You will write the needed code and get the test to pass; then go on to the next example.

## Automating the workflow using Guard

Does this mean you have to manually run `rspec` every time you want to work on a new example?  No!  Happily there is some automation that can help us.  `guard` is a gem that watches for various files in your project to change, and when they do, it automatically re-runs a predefined set of tests.  We have configured `guard` here so that whenever you change either the specfile or `activerecord_practice.rb`, it will re-run all tests that begin with `specify` (as opposed to `xspecify`). (If you're curious about how Guard works, you can look in `Guardfile` to see, but you don't need to worry about it.)

* In a terminal window, say `guard`.  You should see something like "Guard is now watching..."  

Although you see a prompt (`guard(main)>`), you don't need to type anything.  In an editor window, make a trivial change to either the specfile or `activerecord_practice.rb`, such as inserting a space, and save the file.  Within one or two seconds, the terminal window running Guard should come to life as Guard tries to re-run the tests.

## Get your first example to pass

Let's work on example #1 as listed in the output of `rspec`.  The output should look like this:

```
  1) ActiveRecord practice to find customer(s) anyone with first name Candice
     # Temporarily skipped with xspecify
     # /home/fox/hw-activerecord-intro/spec/activerecord_practice_spec.rb:40
```

As the output suggests, take a look at line 40 in the specfile. In the body of the testcase, you can see that the test will try to call the class method `Customer.any_candice`. Change `xspecify` to `specify` in line 40, save the specfile, and Guard should once again run the tests; but this time, test #1 will not be skipped but instead will fail.  

Now go to `lib/activerecord_practice.rb` where we have defined an empty method `Customer.any_candice`.  Fill in the body of this method so that it returns the enumerable of `Customer` objects whose first name(s) match "Candice". (Reminder: the `customers.csv` file contains an exported version of the contents of `customers.sqlite3`, which is the database used by this code.)  Each time you make a change and save `activerecord_practice.rb`, Guard will re-run the tests.  When you eventually get the method call right, the test will pass and the name of the test will print in green, with all still-pending tests printed in yellow. Then you can move on to the next example.

Note that for most test cases, the test case will initially fail because the class method of `Customer` that it tries to call doesn't exist at all (we only provided empty method skeletons for the first couple of examples).  But by reading each test case's code, you can see what it expects the class method to be named, and define it yourself. 

When all the examples pass (RSpec should print each passing example's name in green), you're all done!

**NOTE:**  If you want to try the examples interactively, start the Ruby interpreter with `bundle exec irb`, and then within the Ruby interpreter type `load 'activerecord_practice.rb'`.  This will define the `Customer` class and allow you to try things like `Customer.where(...)` directly in the REPL (read-eval-print loop).


## Helpful Hints and Links


As usual, you will have to look up the ActiveRecord documentation to learn how to get these queries to work, which is part of the learning process:

* [Intro to ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html)
* [Basic queries using ActiveRecord](https://guides.rubyonrails.org/active_record_querying.html)
* [Complete ActiveRecord documentation (for Rails 4.2.x)](https://api.rubyonrails.org/v4.2.9/classes/ActiveRecord/Base.html)

Even though the examples call for filtering and sometimes sorting a subset of customer records, **you should never need to call** Ruby collection methods like `map` or `collect` or `sort` -- 100% of the work can be done in the ActiveRecord call.

Also, the goal is to pass each test by using ActiveRecord's query interface, not by calling `find()` with the id's of the expected result records.  To remove that temptation, the RSpec tests raise an  error if you directly use `ActiveRecord::Base.find` in your code.  (Later in the course we will explore the RSpec mechanisms that allow us to do this "method shadowing" to disable certain methods in testing.)

Finally, if you're interested in learning more about the underlying SQL (Structured Query Language) commands that ActiveRecord is generating, we recommend:

* [SQL Queries](https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/about), another short self-paced course from our friends at Stanford
* [SQL Teaching](https://www.sqlteaching.com), which allows you to interactively


<details><summary>Why are `where` and `find` class methods rather than instance methods?</summary><blockquote> Instance methods operate on one instance of the class, but until we look up one or more objects, we have no instance to operate on.</blockquote></details>

## Bonus background information

Although ActiveRecord is a key part of Rails, you can use the ActiveRecord library outside of a Rails app.  Indeed, these exercises make use of ActiveRecord, but the exercises themselves do not constitute a Rails app.  So there are a few differences between how we are using AR here and how you'd use it in a Rails app:

1.  The Gemfile lists `active_record` as an explicit dependency.  In a Rails app, the Gemfile would just list `rails` as a gem, but `rails` in turn depends on `active_record`, and Bundler would detect and resolve that dependency.

2. Similarly, in `activerecord_practice.rb` there is a call to `establish_connection`.  In a normal Rails app you would never need this, since Rails itself takes care of managing the database connections and there are even Rails extensions that can spread connections across multiple databases and handle master-slave replication.

3. The two files in the assignment, `activerecord_practice.rb` and the specfile `spec/activerecord_practice_spec.rb`, explicitly `require` various gems.  If this were a Rails app, Rails would automatically `require` all the gems in your Gemfile when your app starts up, so you'd almost never see explicit `require`s in the code files.

Finally, for the curious, you may wonder why the RSpec tests behave the same each time for cases where you are modifying the database. For example, if you successfully pass test case #12, "delete customer Meggie Herman", wouldn't that cause problems when you re-run the tests and that customer has _already_ been deleted?

This is handled by running each test inside a [database transaction](https://en.wikipedia.org/wiki/Database_transaction), and just before the test case finishes, raising a pseudo-exception that will cause the transaction to be [rolled back](https://en.wikipedia.org/wiki/Rollback_(data_management)), which causes all the changes visible inside the transaction to be undone. When we test Rails apps, this is also the way the test database is handled: every single test case (and you will have hundreds or thousands of them) starts and ends with the database in the same "clean" state, so that they run in a predictable environment.
