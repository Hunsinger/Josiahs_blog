class ArticleName < ActiveRecord::Migration
  def change
  	change_table :articles do |t|
  		t.string :name
  	end
  end
end
