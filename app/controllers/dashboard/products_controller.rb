class Dashboard::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: %w[show edit update destroy]
  layout "dashboard/dashboard"

  def index
    if sort_params.present?
      @category = Category.request_category(sort_params[:sort_category])
      @products = Product.sort_products(sort_params, params[:page])
    elsif params[:category].present?
      @category = Category.request_category(params[:category])
      @products = Product.category_products(@category, params[:page])
    else
      @products = Product.display_list(params[:page])
    end

    @major_category_names = Category.major_categories
    @categories = Category.all
    @sort_list = Product.sort_list
  end

  def show
    @reviews = @product.reviews_with_id
    @review = @reviews.new
    @star_repeat_select = Review.star_repeat_select
  end


  def destroy
    @product.destroy
    redirect_to dashboard_products_path
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id)
    end
end