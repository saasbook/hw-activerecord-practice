require 'faker'
require 'active_record'
require 'sqlite3'
require 'csv'

unless ENV['CLOBBER']
  raise RuntimeError.new("*** Running this file will clobber the database and rebuild it with new random data, and the tests will not work.  This is probably not what you want.  If it is really, really what you want, say `CLOBBER=1 bundle exec ruby seed.rb` to force it.")
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'activerecord_practice.sqlite3')
ActiveRecord::Schema.define do
  create_table 'customers', :force => true do |t|
    t.string 'first'
    t.string 'last'
    t.string 'email'
    t.string 'zip'
    t.datetime 'birthdate'
  end
end

class Customer < ActiveRecord::Base
  CSV.open("all_customers.csv", "w") do |csv_file|
    100.times do
      c = Customer.create!(
        :first => (first = Faker::Name.first_name),
        :last => (last = Faker::Name.last_name),
        :email => if rand() < 0.8 then Faker::Internet.email("#{first} #{last}") else nil end,
        :birthdate => Faker::Date.birthday(13,65)
        )
      csv_file << [c.first, c.last, c.email, c.birthdate.strftime('%Y-%M-%d')]
    end
  end
end
