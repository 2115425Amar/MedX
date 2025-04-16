require "csv"
require "caxlsx"

class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
  end

  # Generates and downloads reports
  def download_report
    format = params[:format] || "csv"

    case params[:report_type]
      # 📋 all_users: All users with post, comment, and like counts
    when "all_users"
      users = User.find_by_sql("
        SELECT users.id, users.first_name, users.last_name, users.email,
               COUNT(DISTINCT posts.id) AS posts_count,
               COUNT(DISTINCT comments.id) AS comments_count,
               COUNT(DISTINCT likes.id) AS likes_count
        FROM users
        LEFT JOIN posts ON posts.user_id = users.id
        LEFT JOIN comments ON comments.user_id = users.id
        LEFT JOIN likes ON likes.user_id = users.id
        GROUP BY users.id
      ")
      filename = "all_users_report.#{format}"
      data = generate_users_report(users, format)

    # 🔥 active_users: Users with more than 10 posts
    when "active_users"
      users = User.find_by_sql("
        SELECT users.id, users.first_name, users.last_name, users.email,
               COUNT(DISTINCT posts.id) AS posts_count,
               COUNT(DISTINCT comments.id) AS comments_count,
               COUNT(DISTINCT likes.id) AS likes_count
        FROM users
        LEFT JOIN posts ON posts.user_id = users.id
        LEFT JOIN comments ON comments.user_id = users.id
        LEFT JOIN likes ON likes.user_id = users.id
        GROUP BY users.id
        HAVING COUNT(posts.id) > 10
      ")
      filename = "active_users_report.#{format}"
      data = generate_users_report(users, format)

    # 📝 postwise: Posts with comment and like counts
    when "postwise"
      posts = Post.find_by_sql("
        SELECT posts.id, posts.description,
               COUNT(DISTINCT comments.id) AS comments_count,
               COUNT(DISTINCT likes.id) AS likes_count
        FROM posts
        LEFT JOIN comments ON comments.post_id = posts.id
        LEFT JOIN likes ON likes.likeable_id = posts.id AND likes.likeable_type = 'Post'
        GROUP BY posts.id
      ")
      filename = "postwise_report.#{format}"
      data = generate_posts_report(posts, format)

    else
      redirect_to reports_path, alert: "Invalid report type"
      return
    end

    file_type = format == "xlsx" ? "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" : "text/#{format}"
    send_data data, filename: filename, type: file_type
  end

  private

  def check_admin
    redirect_to root_path, alert: "Access denied" unless current_user.has_role?(:admin)
  end

  # Converts user details into CSV or Excel.
  def generate_users_report(users, format)
    return unless users.present?
    # Rails.logger.info "Generating Users Report - Total Users: #{users.count}"

    if format == "csv"
      CSV.generate(headers: true) do |csv|
        csv << [ "ID", "First Name", "Last Name", "Email", "Posts Count", "Comments Count", "Likes Count" ]
        users.each do |user|
          csv << [ user.id, user.first_name, user.last_name, user.email, user.posts_count, user.comments_count, user.likes_count ]
        end
      end
    elsif format == "xlsx"
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Users Report") do |sheet|
        sheet.add_row [ "ID", "First Name", "Last Name", "Email", "Posts Count", "Comments Count", "Likes Count" ]
        users.each do |user|
          Rails.logger.info "Adding User: #{user.first_name} #{user.last_name} (Posts: #{user.posts_count})"
          sheet.add_row [ user.id, user.first_name, user.last_name, user.email, user.posts_count, user.comments_count, user.likes_count ]
        end
      end

    # Save to disk for inspection
    file_path = Rails.root.join("tmp", "users_report.xlsx")
    package.serialize(file_path)
    Rails.logger.info "Excel file saved to #{file_path}"

      package.to_stream.read
    end
  end

  def generate_posts_report(posts, format)
    return unless posts.present?
    # Rails.logger.info "Generating Posts Report - Total Posts: #{posts.count}"

    if format == "csv"
      CSV.generate(headers: true) do |csv|
        csv << [ "Post ID", "Description", "Comments Count", "Likes Count" ]
        posts.each do |post|
          csv << [ post.id, post.description, post.comments_count, post.likes_count ]
        end
      end
    elsif format == "xlsx"
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Postwise Report") do |sheet|
        sheet.add_row [ "Post ID", "Description", "Comments Count", "Likes Count" ]
        posts.each do |post|
          sheet.add_row [ post.id, post.description, post.comments_count, post.likes_count ]
        end
      end

    # Temporarily save to disk for inspection
    file_path = Rails.root.join("tmp", "users_report.xlsx")
    package.serialize(file_path)
    Rails.logger.info "Excel file saved to #{file_path}"

    package.to_stream.read
    end
  end
end
