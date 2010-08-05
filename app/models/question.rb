class Question < ActiveRecord::Base

  hobo_model # Don't put anything above this

  searchable do
    text :subject, :default_boost => 2
    text :description
  end

  fields do
    subject     :string, :name => true
    description :optional_markdown
    markdown    :boolean
    timestamps
  end
  
  has_many :answers, :dependent => :destroy
  has_many :recipes, :through => :answers, :uniq => true
 
  named_scope :none, { :conditions => 'id = 1 and id = 2' } 
  include OwnedModel

end
