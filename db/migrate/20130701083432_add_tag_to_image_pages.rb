class AddTagToImagePages < ActiveRecord::Migration
  def change
    add_column Refinery::ImagePage.table_name, :tag, :string
    add_column Refinery::ImagePage.table_name, :part_title, :string
    add_column Refinery::ImagePage.table_name, :link_url, :string
  end
end
