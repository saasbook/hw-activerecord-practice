require 'rspec'
require './activerecord_practice.rb'
require 'byebug'

ALL_CUSTOMERS = [nil] + Customer.all.order('id')

RSpec.configure do |config|
  config.default_formatter = 'doc'
  config.full_backtrace = false
  config.backtrace_clean_patterns = /./
  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end

def check(actual,expected_ids)
  actual ||= []
  expected = ALL_CUSTOMERS.values_at(*expected_ids)
  missing = expected - actual
  unless missing.empty?
    fail "Result should have contained these, but it did not:\n" + missing.join("\n")
  end
  extra = actual - expected
  unless extra.empty?
    fail "Result should NOT have contained these, but it did:\n" + missing.join("\n")
  end
end
  

describe 'find customer(s)' do
  before(:each) { expect(Customer).not_to receive(:find) }
  specify 'Candice Mayer (HINT: lookup `find_by`)', :pending => true do
    result = Customer.candice_mayer
    expect(result.id).to eq(1)
  end
  specify 'with valid email (email addr contains "@")' do
    result = Customer.with_valid_email
    check(result, [1, 2, 4, 5, 7, 8, 10, 11, 12, 13, 14, 15, 17, 18, 19, 20, 23, 26, 29, 30])
  end
  specify 'with invalid email (does not contain "@")', :pending => true do
    result = Customer.with_invalid_email
    expect(result.map(&:id).sort).
      to eq([6, 7, 8, 9, 35, 36, 39, 48, 53, 62, 66, 70, 77, 78, 94, 95])
  end
  specify 'with blank email (blank or does not contain "@")' do
    result = Customer.with_blank_email
  end
  specify 'with valid email AND born before 1/1/1980'
  specify 'born before 1 Jan 1980, in any order'
  specify '20 youngest customers, in any order (hint: lookup ActiveRecord `order` and `limit`)'
  specify 'with last names starting with "M", results sorted by birthdate (HINT: lookup the SQL LIKE operator)'
  specify 'with .org emails (HINT: remember email addresses are NOT case-sensitive!)'
end

describe 'change' do
  specify 'the birthdate of Kennedy Pollich to February 8, 2004 (HINT: lookup `Time.parse`)'
  specify 'all invalid emails to be blank'
  specify 'database by deleting customer Fern Pouros'
  specify 'database by deleting all customers born on or before 31 Dec 1977'
end

