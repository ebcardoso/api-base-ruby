class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  has_secure_password
  
  validates :name, presence: {message: "Field :name is required"}
  validates :email, presence: {message: "Field :email is required"}
  validates :email, uniqueness: {message: "This :email already exists"}
end
