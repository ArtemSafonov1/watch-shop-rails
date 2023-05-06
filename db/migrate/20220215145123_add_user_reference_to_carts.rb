class AddUserReferenceToCarts < ActiveRecord::Migration[6.1]
  def change
    add_reference :carts, :user, index: true
  end
end
