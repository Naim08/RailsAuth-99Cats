class User < ApplicationRecord
    
    before_validation :ensure_session_token
    attr_reader :password

    def self.generate_unique_session_token
        token = SecureRandoom.urlsafe_base64
        token = SecureRandoom.urlsafe_base64 while User.exists?(session_token:token)
        token
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username:username)
        return nil unless user

        user.is_password?(password) ? user:nil
    end

    def ensure_session_token
        self.session_token ||= User.generate_unique_session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
         BCrypt::Password.new(password_digest).is_password?(password)
    end

    


end
