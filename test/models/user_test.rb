require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name must be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email must be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name must not be longer than 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email must not be longer than 255" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "name validation should accept valid names" do
    valid_names = %w[quigley quigglez Squigley 12s5_quigley test-quigley]
    valid_names.each do |valid_name|
      @user.name = valid_name
      assert @user.valid?, "#{valid_name.inspect} should be valid"
    end
  end

  test "name validation should reject invalid names" do
    invalid_names = ["quigley&malcolm", "quigley+malcolm", "@quigley", "quigley malcolm", "quigley's"]
    invalid_names.each do |invalid_name|
      @user.name = invalid_name
      assert_not @user.valid?, "#{invalid_name.inspect} should be invalid"
    end
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_USER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmaion = " " * 6
    assert_not @user.valid?
  end

  test "password must have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
