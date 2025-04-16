## app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  default from: "amar8601082@gmail.com"

  def bulk_upload_status(admin_email, success_count, errors)
    @success_count = success_count
    @errors = errors || [] # Ensure @errors is always an array
    mail(to: admin_email, subject: "Bulk User Upload Status")
  end
end
