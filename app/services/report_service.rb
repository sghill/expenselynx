class ReportService
  def flatten_receipt( receipt_id )
    receipt = Receipt.find(receipt_id)
    store = Store.find_by_name(receipt.store.name)
    expense_category = ExpenseCategory.find_by_name(store.expense_category.name)
    
    flat_receipt = []
    flat_receipt << expense_category.name
    flat_receipt << receipt.purchase_date
    flat_receipt << receipt.total
    flat_receipt << "USD"
    return flat_receipt
  end
end