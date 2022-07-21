class User < ApplicationRecord
  has_many :reviews
  extend DisplayList
  extend SwitchFlg
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  acts_as_liker
  
  def update_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end
  scope :search_information, -> (keyword) { 
    where("cast(name as text) LIKE :keyword OR cast(id as text) LIKE :keyword OR cast(email as text) LIKE :keyword OR cast(address as text) LIKE :keyword OR cast(postal_code as text) LIKE :keyword OR cast(phone as text) LIKE :keyword", keyword: "%#{keyword}%")
  }
end