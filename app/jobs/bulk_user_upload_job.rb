class BulkUserUploadJob < ApplicationJob
  queue_as :default

  def perform(file_path, admin_email)
    users = []
    errors = []

    begin
      case File.extname(file_path)
      when ".csv"
        CSV.foreach(file_path, headers: true) do |row|
          password = Devise.friendly_token[0, 10] # Generate a random password
          # Converts the CSV row into a hash and merges it with the generated password.
          user = User.new(row.to_hash.merge(password: password))
          if user.save
            users << user
            send_welcome_email(user, password) # Send welcome email to the user
          else
            errors << { row: row.to_h, errors: user.errors.full_messages || [] }
          end
        end
      when ".xlsx"
        xlsx = Roo::Excelx.new(file_path)
        xlsx.each_row_streaming(offset: 1) do |row|
          password = Devise.friendly_token[0, 10] # Generate a random password
          user = User.new(
            name: row[0].value,
            email: row[1].value,
            phone_number: row[2].value,
            password: password
          )
          if user.save
            users << user
            send_welcome_email(user, password) # Send welcome email to the user
          else
            errors << { row: row.map(&:value), errors: user.errors.full_messages || [] }
          end
        end
      end
    rescue => e
      errors << { error: "Exception raised: #{e.message}" }
    ensure
      # Sends an email report to the admin after processing.
      AdminMailer.bulk_upload_status(admin_email, users.count, errors).deliver_later
      # Deletes the file after the process completes.
      File.delete(file_path) if File.exist?(file_path) # Clean up the file after processing
    end
  end

  # Send welcome email to the user
  def send_welcome_email(user, password)
    begin
      UserMailer.byadmin_welcome_email(user, password).deliver_later
    rescue => e
      Rails.logger.error "Failed to send welcome email to #{user.email}: #{e.message}"
    end
  end
end
