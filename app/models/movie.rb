class Movie < ActiveRecord::Base
    
  def self.find_all_by_rating(ratings)
      where(arel_table[:rating].in(ratings))
  end 
  
  def self.ratings 
    ['G','PG','PG-13','R']
  end
  
end
