FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :category do
    name "Books"
    description "Books category"
  end 

  factory :library do
    title "My library"
    user
    category
  end 

  factory :item do
    title "My item"
    library
    status "not begun"
  end  
end