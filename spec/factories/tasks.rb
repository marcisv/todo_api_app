FactoryGirl.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
  end
end
