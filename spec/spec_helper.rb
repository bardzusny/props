RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around(:each) do |example|
    Timecop.freeze if freeze_time?
    example.run
    Timecop.return if freeze_time?
  end

  def freeze_time?
    RSpec.current_example.metadata[:freeze_time]
  end
end
