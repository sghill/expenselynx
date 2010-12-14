# encoding: utf-8

class ExpenseReportUploader < CarrierWave::Uploader::Base
  def store_dir
    "expense_reports/"
  end
end
