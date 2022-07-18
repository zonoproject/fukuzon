class Product < ApplicationRecord
    belongs_to :category
    has_many :reviews
    acts_as_likeable
    
    PER = 15
 
    scope :display_list, -> (page) { page(page).per(PER) }
    scope :on_category, -> (category) { where(category_id: category) }
    scope :sort_order, -> (order) { order(order) }
 
    scope :category_products, -> (category, page) { 
        on_category(category).
        display_list(page)
    }
    scope :sort_products, -> (sort_order, page) {
        on_category(sort_order[:sort_category]).
        sort_order(sort_order[:sort]).
        display_list(page)
    }
    scope :sort_list, -> { 
        {
            "並び替え" => "", 
            "安い順" => "price asc",
            "高い順" => "price desc", 
            "古い順" => "updated_at asc", 
            "新しい順" => "updated_at desc"
        }
   }
    def reviews_new
        reviews.new
    end
    
    def reviews_with_id
        reviews.reviews_with_id
    end
end
