RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    # Will default to `true` in RSpec 4
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Will default to `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # Will default to `:apply_to_host_groups` in RSpec 4
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.order = :random
  Kernel.srand config.seed

end
