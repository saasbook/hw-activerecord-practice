require 'active_record'
require 'sqlite3'
require 'csv'

unless ENV['CLOBBER']
  raise RuntimeError.new("*** Running this file will clobber the database and rebuild it with new random data, and the tests will not work.  This is probably not what you want.  If this is really, really what you want to do, add `gem 'faker'` to your Gemfile, re-run `bundle`, then say `CLOBBER=1 bundle exec ruby seed.rb` to force it.")
end

require 'faker'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
ActiveRecord::Schema.define do
  create_table 'customers', :force => true do |t|
    t.string 'first'
    t.string 'last'
    t.string 'email'
    t.datetime 'birthdate'
  end
end

class Customer < ActiveRecord::Base
  CSV.open("customers.csv", "w") do |csv_file|
    30.times do
      first = Faker::Name.first_name
      last = Faker::Name.last_name
      birthdate = Faker::Date.birthday(13,65)
      email = if rand() < 0.75          # 75% customers have valid email
                Faker::Internet.email("#{first} #{last}")
              elsif rand() < 0.5 # 5% have invalid email
                "#{first}.#{last}"
              else              # 20% have no email address
                nil
              end
      c = Customer.create!(:first => first, :last => last,:email => email, :birthdate => birthdate)
      csv_file << [c.id, first, last, email, %Q{="#{birthdate.strftime('%Y-%m-%d')}"}]
    end
  end
  puts "customers.csv re-created"
end
