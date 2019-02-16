require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, #{email}, #{birthdate.strftime('%Y-%m-%d')}"
  end
  def self.candice_mayer
    # YOUR CODE HERE to return the one customer named Candice Mayer
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses
  end
  def self.with_blank_email
  end
  # etc. - see the activerecord_practice_spec.rb file for the names of methods to define hre
end
