class AddNotificationFieldToTodos < ActiveRecord::Migration
  def up
    add_column :todos, :notification, :string
  end

  def down
    remove_column :todos, :notification
  end
end
