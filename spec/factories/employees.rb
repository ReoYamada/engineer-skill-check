FactoryBot.define do
  factory :employee do
    sequence(:number) { |n| n }
    last_name { 'yamada' }
    first_name { 'taro' }
    sequence(:account) { |n|"yamataro#{n}" }
    password { 1234 }
    email { 'yama@example.com' }
    date_of_joining { '2020/10/01' }
    employee_info_manage_auth { true }
    news_posting_auth { true }
  end
end
