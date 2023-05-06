module UserOath
  extend ActiveSupport::Concern

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  class_methods do
    def find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
      return authorization.user if authorization

      email = auth.info[:email]
      first_name = auth.info[:name].split(" ").first
      last_name = auth.info[:name].split(" ").last
      country = address = "Unknown"
      phone = "0000000000"
      user = User.where(email: email).first
      email ||= create_email(auth) if email.nil?
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(
          email: email, first_name: first_name, last_name: last_name, address: address,
          country: country, phone: phone, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
      user
    end
    def create_email(auth)
      "#{auth[:uid]}@rails_watch.com"
    end
  end
end