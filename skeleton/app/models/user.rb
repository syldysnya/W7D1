# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# require 'bcrypt'

class User < ApplicationRecord

    attr_reader :password

    validates :user_name, presence: true, uniqueness: true
    validates :password_digest, presence: { message: 'Password can\'t be blank'}
    validates :session_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_session_token

    has_many :cats,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :Cat

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        return user if user && user.is_password?(password)

    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end
end
