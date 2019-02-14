require 'rspec'
require './activerecord_practice.rb'

describe 'customers' do
  specify 'with invalid email' do
    result = Customer.with_invalid_email
    expect(result.size).to eq(10)
  end
end
