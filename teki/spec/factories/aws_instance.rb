FactoryGirl.define do
  factory :aws_instance, class: ::Teki::Aws::Instance do
    instance_id { SecureRandom.uuid }
    availability_zone { ['ap-northeast-1a', 'ap-notrheast-1c'].shuffle.first }
    hostname { Faker::Name.first_name }
    instance_type 't2.micro'
    auto_scaling_type 'timer'

    initialize_with do
      new(instance_id, availability_zone, hostname, instance_type, auto_scaling_type )
    end

    skip_create
  end
end
