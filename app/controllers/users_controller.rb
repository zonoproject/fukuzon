class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  def edit
  end

  def update
    @user.update_without_password(user_params)
    redirect_to mypage_users_url
  end

  def mypage
  end
  
  def edit_address
  end
  
  def update_password
    if password_set?
      result = @user.update_password(user_params) 
      if result
       flash[:notice] = "パスワードは正しく更新されました。"
       redirect_to root_url
      else
       render "edit_password"
      end 
    else
      @user.errors.add(:password, "に不備があります。")
      render "edit_password"
    end
  end

  def edit_password
  end
  
  def favorite
    @favorites = @user.likees(Product)
  end
  
  private
  def set_user
    @user = current_user
  end
  
  def user_params
    params.permit(:name, :email, :address, :phone, :password, :password_confirmation)
  end
  
  def password_set?
    user_params[:password].present? && user_params[:password_confirmation].present? ?
    true : false
  end
end
