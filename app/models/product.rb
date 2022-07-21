class Product < ApplicationRecord
    belongs_to :category
    has_many :reviews
    acts_as_likeable
    has_one_attached :image
 
    extend DisplayList
    scope :on_category, -> (category) { where(category_id: category) }
    scope :sort_order, -> (order) { order(order) }
 
    scope :category_products, -> (category, page) { 
        on_category(category).
        display_list(page)
    }
    
    scope :search_for_id_and_name, -> (keyword) {
        where("cast(name as text) LIKE ?", "%#{keyword}%").
        or(where("cast(id as text) LIKE ?", "%#{keyword}%"))
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
   
    scope :recently_products, -> (number) { order(created_at: "desc").take(number) }
    scope :recommend_products, -> (number) { where(recommended_flag: true).take(number) }
    scope :check_products_carriage_list, -> (product_ids) { where(id: product_ids).pluck(:carriage_flag)}
    
    
    def self.import_csv(file)
        new_products = []
        update_products = []
        CSV.foreach(file.path, headers: true, encoding: "Shift_JIS:UTF-8") do |row|
            row_to_hash = row.to_hash
            byebug
            if row_to_hash[:id].present?
                update_product = find(id: row_to_hash[:id])
                update_product.attributes = row.to_hash.slice!(csv_attributes)
                update_products << update_product
            else
                new_product = new
                new_product.attributes = row.to_hash.slice!(csv_attributes)
                new_products << new_product
            end
        end
        if update_products.present?
            import update_products, on_duplicate_key_update: csv_attributes
        elsif new_products.present?
            import new_products
        end
    end

    
    def reviews_new
        reviews.new
    end
    
    def reviews_with_id
        reviews.reviews_with_id
    end
end
