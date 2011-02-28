class User < ActiveRecord::Base
  has_many :expense_reports
  has_many :receipts
  has_many :participants
  has_many :projects
  has_many :user_store_expense_categories
  has_many :expense_categories, :through => :user_store_expense_categories

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def report report_receipts, as_report
    new_report = expense_reports.new(:external_report_id => as_report[:as])
    begin
      transaction do
        report_receipts.each do |rec|
          rec.report new_report
        end
        new_report.save!
      end
    rescue ActiveRecord::RecordInvalid => e
    end
    new_report
  end
end
