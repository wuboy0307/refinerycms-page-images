module Refinery
  Page.class_eval do
    has_many :images, proc { order('position ASC') }, :class_name => 'Refinery::Image'
    accepts_nested_attributes_for :images, :allow_destroy => false

  end
end