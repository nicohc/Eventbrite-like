class User < ApplicationRecord
  has_many :created_events , class_name: "Event"
  has_and_belongs_to_many  :attended_events, class_name: "Event"

  attr_accessor :remember_token

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-zA-Z0-9_]*\z/ }
                   #RegExp du format Username

  EMAIL = /\A([\w\!\#\z\%\&\'\*\+\-\/\=\?\\A\`{\|\}\~]+\.)*[\w\+-]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)\z/i

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: EMAIL }
                    #RegExp du format Email

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
     self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


end
