class AddUniqueIndexToPostsTrainingId < ActiveRecord::Migration[7.2]
  def change
    remove_index :posts, :training_id
    add_index :posts, :training_id, unique: true
  end
end
