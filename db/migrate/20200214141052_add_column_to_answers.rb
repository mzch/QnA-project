class AddColumnToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean, null: false, default: false
  end
end
