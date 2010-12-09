module ReportServiceHelper
  
  def sanitize_email ( email )
    email["@"] = "-at-" unless email["@"].nil?
    email["."] = "-dot-" unless email["."].nil?
    return email
  end
end