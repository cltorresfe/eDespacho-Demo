class CustomerQuote < ActiveRecord::Base
	has_many :quotes, :dependent => :destroy
	belongs_to :user
end
