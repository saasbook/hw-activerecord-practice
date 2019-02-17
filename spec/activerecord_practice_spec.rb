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

describe 'ActiveRecord practice' do
  before(:each) do
    # disable methods we don't want you to use...
    expect(Customer).not_to receive(:find)
  end
  describe 'to find customer(s)' do
    specify 'Candice Mayer (HINT: lookup `find_by`)' do
      method = "candice_mayer"
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      expect(Customer.send(method).id).to eq(24)
    end
    specify 'with valid email (email addr contains "@") (HINT: look up SQL LIKE operator)' do
      method = 'with_valid_email'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check Customer.send(method), [1,2,4,5,7,8,10,11,12,13,14,15,17,18,19,20,23,26,29,30]
    end
    specify 'with .org emails' do
      method = 'with_dot_org_email'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check Customer.send(method), [5,7,8,12,23,26,29] 
    end
    specify 'with invalid but nonblank email (does not contain "@")' do
      method = 'with_invalid_email'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check Customer.send(method), [3,6,9,16,22,25,27,28] 
    end
    specify 'with blank email' do
      method = 'with_blank_email'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check  Customer.send(method), [21,24]
    end
    specify 'born before 1 Jan 1980' do
      method = 'born_before_1980'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check Customer.send(method), [3,8,9,11,15,16,17,19,20,24,25,27]
    end
    specify 'with valid email AND born before 1/1/1980' do
      method = 'with_valid_email_and_born_before_1980'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check Customer.send(method), [8,11,15,17,19,20]
    end
    specify '20 youngest customers, in any order (hint: lookup ActiveRecord `order` and `limit`)' do
      method = 'twenty_youngest'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      check Customer.send(method), [7,5,6,30,1,10,29,21,18,13,14,28,26,4,2,22,23,12,11,9] 
    end
    specify 'with last names starting with "B", sorted by birthdate' do
      method = 'last_names_starting_with_b'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      expect(Customer.send(method).map(&:id)).to eq( [25,23,4,28,18,21,29,1] )
    end
  end
  describe 'to update' do
    specify 'the birthdate of Gussie Murray to February 8,2004 (HINT: lookup `Time.parse`)' do
      method = 'update_gussie_murray_birthdate'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      Customer.send(method)
      expect(Customer.find_by(:first => 'Gussie').birthdate).to eq(Time.parse '2004-Feb-08')
    end
    specify 'all invalid emails to be blank' do
      method = 'change_all_invalid_emails_to_blank'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      Customer.send(method)
      expect(Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").count).to be_zero
    end
    specify 'database by deleting customer Maggie Herman' do
      method = 'delete_maggie_herman'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      Customer.send(method)
      expect(Customer.find_by(:first => 'Maggie', :last => 'Herman')).to be_nil
    end
    specify 'database by deleting all customers born on or before 31 Dec 1977' do
      method = 'delete_everyone_born_before_1978'
      skip "define Customer.#{method} and delete line #{__LINE__} in #{__FILE__}"
      Customer.send(method)
      expect(Customer.where('birthdate < ?', Time.parse("1 January 1978"))).to be_empty
    end
  end
end
