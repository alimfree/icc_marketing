require "faker"

def create_user(name: Faker::Name.first_name, username: Faker::Internet.username(specifier: 4..30), email: Faker::Internet.email, password: "password1^")
  Khateeb.create(
    first_nm: name,
    last_nm: Faker::Name.last_name,
    title: "Br",
    username: username,
    email: email,
    password: password
  )
end

def create_post(user_id: create_user().id, caption: Faker::Lorem.sentence(word_count: 20), image: getImage())
  Reminder.create(
    user_id: user_id,
    caption: caption,
    image: image
  )
end

def getImage
  image_path = "#{::Rails.root}/storage/defaults/default_post_image.png"
  return {
    io: File.open(image_path),
    filename: "default_post_image.png",
    content_type: "image/png"
  }
end

10.times { create_user() }

Khateeb.all.each() do |khateeb|
  3.times { create_post(khateeb_id: khateeb.id) }
  5.times do 
    khateeb_to_follow = Khateeb.all.sample
    unless khateeb.followed.include?(khateeb_to_follow)
      khateeb.followed << khateeb_to_follow
    end
  end
  khateeb.save()
end