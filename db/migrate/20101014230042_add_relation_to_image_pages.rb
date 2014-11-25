class AddRelationToImagePages < ActiveRecord::Migration
  def change
    add_column Refinery::Image.table_name, :page_id, :integer
    add_column Refinery::Image.table_name, :caption, :text
    add_column Refinery::Image.table_name, :position, :integer
    add_index Refinery::Image.table_name, :page_id
  end
end
