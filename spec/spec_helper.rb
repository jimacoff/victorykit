# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryGirl::Syntax::Methods
end

def valid_session
  user = create(:super_user)
  {:user_id => user.id}
end

shared_examples_for "a login protected page" do
  it "allows valid users to carry out the action" do
    session[:user_id] = create(:user).id
    action
    should_not redirect_to login_path
  end
  it "disallows non logged in users to carry out the action" do
    action
    should redirect_to login_path
  end
end

shared_examples_for "a super-user only resource page" do
  it "allows super users to carry out the action" do
    session[:user_id] = create(:super_user).id
    action
    response.status.should_not == 403
    should_not redirect_to login_path
  end
  it "disallows non super users to carry out the action" do
    session[:user_id] = create(:user).id
    action
    response.status.should == 403
  end
  it "disallows non logged in users to carry out the action" do
    action
    should redirect_to login_path
  end
end