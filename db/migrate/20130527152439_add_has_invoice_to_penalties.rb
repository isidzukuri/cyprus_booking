class AddHasInvoiceToPenalties < ActiveRecord::Migration
  def change
    add_column :penalties, :has_invoice, :integer
  end
end
