class BulkUserMailer < ApplicationMailer
    def upload_status(admin_email, success_count, failure_count)
      @success_count = success_count
      @failure_count = failure_count
      mail(to: admin_email, subject: "Bulk User Upload Status")
    end
end