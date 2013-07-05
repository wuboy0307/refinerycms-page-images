module Refinery
  class ImagePage < Refinery::Core::BaseModel

    belongs_to :image
    belongs_to :page, :polymorphic => true

    translates :caption if self.respond_to?(:translates)

    attr_accessible :image_id, :position, :locale, :tag, :part_title
    self.translation_class.send :attr_accessible, :locale

  end
end
