class TranslatePageImageCaptions < ActiveRecord::Migration
  def up

    Refinery::Image.reset_column_information
    unless defined?(Refinery::Image::Translation) && Refinery::Image::Translation.table_exists?
      Refinery::Image.create_translation_table!({
        :caption => :text
      }, {
        :migrate_data => true
      })
    end
  end

  def down
    Refinery::Image.reset_column_information
    Refinery::Image.drop_translation_table! :migrate_data => true
  end
end
