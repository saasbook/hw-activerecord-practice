require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => './activerecord_practice.sqlite3')
ActiveRecord::Schema.define do
  create_table 'customers', :force => true do |t|
    t.string 'first'
    t.string 'last'
    t.string 'email'
    t.string 'zip'
    t.datetime 'birthdate'
  end
