class ImportUsersJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      User.create!(
        first_name: row['first_name'],
        last_name: row['last_name'],
        email: row['email'],
        phone_number: row['phone_number'],
        password: SecureRandom.hex(8)
      )
    end
  end
end 