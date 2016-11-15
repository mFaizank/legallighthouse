FactoryGirl.define do  factory :contact do
    name "MyString"
email "MyString"
subject "MyString"
message "MyText"
  end
  factory :lawyer_lead do
    email "MyString"
specializations "MyString"
  end
  factory :lead do
    email "MyString"
business false
  end
  factory :client do
    status 1
user nil
lawyer nil
  end
  factory :quote do
    agreement "MyString"
fixed_fee false
estimated_min "9.99"
estimated_max "9.99"
total "9.99"
completion_date "2016-05-10 20:44:27"
lawyer nil
client nil
status 1
  end
  factory :inquiry do
    description "MyString"
user nil
lawyer nil
status ""
  end
  factory :admin do
    
  end
  factory :user do
    
  end
  factory :lawyer do
    
  end

end
