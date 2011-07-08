class Project < ActiveRecord::Base
  belongs_to :user
  has_many   :expense_reports
  
  validates :name, :presence => true
  validate  :start_date_before_end_date,
            :current_project_cannot_have_past_end_date
  
  scope :current, where(:current => true)
  
  private
    def start_date_before_end_date
      if self.start_date.present? && self.end_date.present?
        errors.add(:end_date, "cannot come before start date") if self.end_date < self.start_date
      end
    end
    
    def current_project_cannot_have_past_end_date
      if self.end_date.present? && self.current.present?
        errors.add(:current, "cannot be true if project has ended in past") if (self.end_date < Time.current.to_date) && self.current?
      end
    end
end