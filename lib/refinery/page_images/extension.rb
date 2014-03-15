module Refinery
  module PageImages
    module Extension
      def has_many_page_images
        has_many :image_pages, :as => :page, :class_name => 'Refinery::ImagePage', :order => 'position ASC', :include => :image
        has_many :images, :through => :image_pages, :class_name => 'Refinery::Image', :order => 'position ASC' do
          def part(part_title="-1")
            where("LOWER(#{Refinery::ImagePage.table_name}.part_title)=?", part_title.to_s.downcase)
          end
        end
        # accepts_nested_attributes_for MUST come before def images_attributes=
        # this is because images_attributes= overrides accepts_nested_attributes_for.

        accepts_nested_attributes_for :images, :allow_destroy => false

        # need to do it this way because of the way accepts_nested_attributes_for
        # deletes an already defined images_attributes
        module_eval do
          def images_attributes=(data)
            ids_to_keep = data.map{|i, d| d['image_page_id']}.compact

            image_pages_to_delete = if ids_to_keep.empty?
              self.image_pages
            else
              self.image_pages.where(
                Refinery::ImagePage.arel_table[:id].not_in(ids_to_keep)
              )
            end

            image_pages_to_delete.destroy_all

            data.each do |i, image_data|
              image_page_id, image_id, caption, tag, part_title =
                image_data.values_at('image_page_id', 'id', 'caption', "tag", "part_title")

              next if image_id.blank?

              image_page = if image_page_id.present?
                self.image_pages.find(image_page_id)
              else
                self.image_pages.build(:image_id => image_id)
              end

              image_page.position = i
              image_page.caption = caption if Refinery::PageImages.captions
              image_page.tag = tag
              image_page.part_title = part_title
              image_page.save
            end
          end
        end

        include Refinery::PageImages::Extension::InstanceMethods
      end

      module InstanceMethods

        def caption_for_image_index(index)
          self.image_pages[index].try(:caption).presence || ""
        end

        def image_page_id_for_image_index(index)
          self.image_pages[index].try(:id)
        end

        def tag_for_image_index(index)
          self.image_pages[index].try(:tag).presence || ""
        end

        def part_for_image_index(index)
          self.image_pages[index].try(:part_title).presence || ""
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, Refinery::PageImages::Extension)
