require 'rspec'
require './activerecord_practice.rb'
require 'byebug'

ALL_CUSTOMERS = [nil] + Customer.all.order('id')

RSpec.configure do |config|
  config.default_formatter = 'doc'
  config.full_backtrace = false
  config.backtrace_inclusion_patterns = [ /check/ ]
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
    raise "Result should have contained these, but it did not:\n" + missing.join("\n")
  end
  extra = actual - expected
  unless extra.empty?
    raise "Result should NOT have contained these, but it did:\n" + missing.join("\n")
  end
end

describe 'ActiveRecord practice'
describe 'to find customer(s)' do
  before(:each) { expect(Customer).not_to receive(:find) }
  specify 'Candice Mayer (HINT: lookup `find_by`)', :pending => true do
    result = Customer.candice_mayer
    expect(result.id).to eq(1)
  end
  specify 'with valid email (email addr contains "@") (HINT: look up SQL LIKE operator)' do
    result = Customer.with_valid_email
    check result, [1,2,4,5,7,8,10,11,12,13,14,15,17,18,19,20,23,26,29,30]
  end
  specify 'with .org emails (HINT: remember email addresses are NOT case-sensitive!)' do
    check Customer.with_dot_org_email, [5,7,8,12,23,26,29] 
  end
  specify 'with invalid but nonblank email (does not contain "@")', :pending => true do
    check Customer.with_invalid_email, [3,6,9,16,22,25,27,28] 
  end
  specify 'with blank email (blank or does not contain "@")' do
    check  Customer.with_blank_email, [21,24]
  end
  specify 'born before 1 Jan 1980' do
    check Customer.born_before_1980, [3,8,9,11,15,16,17,19,20,24,25,27]
  end
  specify 'with valid email AND born before 1/1/1980' do
    check Customer.with_valid_email_and_born_before_1980, [8,11,15,17,19,20]
  end
  specify '20 youngest customers, in any order (hint: lookup ActiveRecord `order` and `limit`)' do
    check Customer.twenty_youngest, [7,5,6,30,1,10,29,21,18,13,14,28,26,4,2,22,23,12,11,9] 
  end
  specify 'with last names starting with "B", sorted by birthdate' do
    expect(Customer.last_names_starting_with_b.map(&:id)).to eq( [25,23,4,28,18,21,29,1] )
  end
  describe 'to update' do
    specify 'the birthdate of Gussie Murray to February 8,2004 (HINT: lookup `Time.parse`)' do
      Customer.update_gussie_murray_birthdate
      expect(Customer.find_by(:first => 'Gussie').birthdate).to eq(Time.parse '2004-Feb-08')
    end
    specify 'all invalid emails to be blank' do
      Customer.change_all_invalid_emails_to_blank
      expect(Customer.count("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'")).to be_zero
    end
    specify 'database by deleting customer Maggie Herman' do
      Customer.delete_maggie_herman
      expect(Customer.find_by(:first => 'Maggie', :last => 'Herman')).to be_empty
    end
    specify 'database by deleting all customers born on or before 31 Dec 1977' do
      Customer.delete_everyone_born_before_1978
      expect(Customer.where('birthdate < ?', Time.parse("1 January 1978"))).to be_empty
    end
  end
end
