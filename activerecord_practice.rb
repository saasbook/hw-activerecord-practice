require 'csv'
require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'activerecord_practice.sqlite3')

class Customer < ActiveRecord::Base
  def self.with_invalid_email
  end
end
