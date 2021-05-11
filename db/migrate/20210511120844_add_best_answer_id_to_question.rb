class AddBestAnswerIdToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :best_answer_id, :bigint
    add_index :questions, :best_answer_id
    add_foreign_key :questions, :answers, column: :best_answer_id
  end
end
