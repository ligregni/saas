class Movie < ActiveRecord::Base
  def self.getCategories
    cats = find(:all, :select => "distinct rating")
    resp = Array.new
    cats.each do |obj|
      resp << obj.rating
    end
    return resp
  end
end
