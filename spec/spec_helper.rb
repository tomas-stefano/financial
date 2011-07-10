require 'rspec'
require 'financial'

# require 'simplecov'
# SimpleCov.start

include Financial::DSL

RSpec.configure do |config|
  include Financial::RSpecMatchers

  def mock_date(day, month, year)
    Date.should_receive(:today).at_least(:once).and_return(Date.civil(year, month, day))
  end

  def stub_date(day, month, year)
    Date.stub!(:today).and_return(Date.civil(year, month, day))
  end

  def ensure_locale(locale_name)
    Financial.locale = locale_name
    Financial.locale.name.should equal locale_name
  end

end