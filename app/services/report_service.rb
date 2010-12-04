require 'tempfile'

class ReportService
  def flatten_receipt( receipt_id )
    receipt = Receipt.find(receipt_id)
    store = Store.find_by_name(receipt.store.name)
    expense_category = ExpenseCategory.find_by_name(store.expense_category.name)
    participant_names = receipt.participants.collect{ |p| p.name }
    participant_names << "me"
    
    flat_receipt = Array.new(9)
    flat_receipt[0] = expense_category.name
    flat_receipt[1] = receipt.purchase_date
    flat_receipt[2] = receipt.total
    flat_receipt[3] = "USD"
    flat_receipt[4] = receipt.note.nil? ? "" : receipt.note
    flat_receipt[5] = store.name
    flat_receipt[6] = "Personal Card"
    flat_receipt[7] = participant_names.join("; ")
    flat_receipt[8] = false
    return flat_receipt
  end
  
  # UNTESTED SPIKE
  def export_expense_report_as_csv( receipt_ids )
    file_name = "public/expense_report.csv"
    File.open(file_name, "w") do |file|    
      receipt_ids.each do |receipt|
        file.puts flatten_receipt(receipt).join(",")
      end
    end
    return file_name
  end
  #END UNTESTED SPIKE
end