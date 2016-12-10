class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :trackable, :validatable, :rememberable
  belongs_to :warehouse
  accepts_nested_attributes_for :warehouse

  def self.add_user (email:,password:"password")
	  clean_empty_reset_tokens
	  user = self.create(email:email,password:password)
	  user.set_reset_token
	  return user
	end

	def set_reset_token token = self.class.generate_token
	  update(reset_password_token: token)
	  return token
	end

	def self.clean_empty_reset_tokens
	  where(reset_password_token:nil).each do |user|
	    user.update(reset_password_token:generate_token)
	  end
	end

	def self.generate_token
	    raw_token, hashed_token = Devise.token_generator.generate(self, :reset_password_token)
	    return hashed_token
	end
end
