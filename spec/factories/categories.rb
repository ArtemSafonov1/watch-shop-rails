

FactoryBot.define do
  factory :category do
    title {'Men'}
    bytitle {title.downcase}
    keywords {Faker::Lorem.sentence(word_count: 10)}
    description {Faker::Lorem.sentence(word_count: 10)}
  end
end