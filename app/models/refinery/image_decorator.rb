module Refinery
  Image.class_eval do
    belongs_to :page, :class_name => "Refinery::Page"

    translates :caption
  end
end