class WebController < ApplicationController
  
  PRODUCTS_PER_PAGE = 4
  
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
    @recently_products = Product.recently_products(PRODUCTS_PER_PAGE)
  end

  private
  def sort_params
    params.permit(:sort, :sort_category)
  end
end
