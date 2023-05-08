require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 8)
    )
  end

  it 'is valid with all the params' do
    expect(@user).to be_valid
  end

  it 'is not valid without field :name' do
    @user.name = nil
    expect(@user).to_not be_valid
  end

  it 'is not valid without field :email' do
    @user.email = nil
    expect(@user).to_not be_valid
  end

  it 'it not valid if :email already existis' do
    @user.save
    @user2 = User.new(
      name: Faker::Name.name,
      email: @user.email,
      password: Faker::Internet.password(min_length: 8)
    )
    expect(@user2).to_not be_valid
  end

  it 'is not valid without field :password' do
    @user.password = nil
    expect(@user).to_not be_valid
  end
end
