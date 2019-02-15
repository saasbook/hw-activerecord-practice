require 'rspec'
require './activerecord_practice.rb'

RSpec.configure do |config|
  config.default_formatter = 'doc'
  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end

include Enumerable
module Enumerable
  def to_simple_list
    self.map { |c| c.to_a rescue c }.flatten.sort
  end
end

describe 'selecting customers:' do
  specify 'with valid email' do
    result = Customer.with_valid_email
    expect(result.size).to eq(10)
  end
  specify 'born before 1/1/1980'
  specify 'with valid email AND born before 1/1/1980'
  specify '20 youngest customers (hint: lookup ActiveRelation `order` and `limit`)'
end

describe 'modifying customers:' do
  specify 'change invalid emails to be blank'
end


