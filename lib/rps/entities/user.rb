module RPS
  class User < ActiveRecord::Base
    has_many :matches
    has_many :moves
    has_many :sessions
    validates_uniqueness_of :username

    def update_password(password)
      self.password_digest = Digest::SHA1.hexdigest(password)
    end

    def has_password?(password)
      Digest::SHA1.hexdigest(password) == self.password_digest
    end
  end
end