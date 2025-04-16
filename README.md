Here's a sample `README.md` for your **Receptionist-Doctor Portal** that includes the key features you mentioned:

---

# 🏥 Receptionist-Doctor Portal

A simple Rails-based web portal for doctors, receptionists, and patients with role-based authentication, user management, and a shared social feed.

---

## 🚀 Features

- **Role-Based Access**  
  - Doctors and Receptionists can log in using provided credentials  
  - Unlimited users (patients, doctors, receptionists) can register

- **User Management**  
  - Doctors and Receptionists can:
    - Create new users (any role)
    - Delete users
    - Activate/Deactivate users
    - Send **email notifications** upon user creation

- **Authentication**  
  - Secure login with Devise  
  - **Forgot Password** functionality with **email reset links**

- **Post Sharing**  
  - Any logged-in user (doctor, receptionist, patient) can create and view posts

---

## 🧑‍⚕️ Sample Login Credentials

| Role         | Email                  | Password   |
|--------------|------------------------|------------|
| Doctor       | doctor@example.com     | doctor     |
| Receptionist | reception@example.com  | password   |

---

## 🛠️ Tech Stack

- Ruby on Rails 7
- PostgreSQL
- Devise (Authentication)
- Action Mailer (Emails)

---

## 🏗️ Installation

```bash
git clone https://github.com/yourusername/receptionist-doctor-portal.git
cd receptionist-doctor-portal
bundle install
rails db:setup
```

> Add your email SMTP configuration in `config/environments/development.rb` for sending emails.

---

## ✅ Usage

### Start the Server
```bash
rails server
```

### Access in browser:
```bash
http://localhost:3000
```

---

## 📬 Email Configuration (Development)

In `config/environments/development.rb`, configure ActionMailer:

```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'example.com',
  user_name: '<your-email>@gmail.com',
  password: '<your-password>',
  authentication: 'plain',
  enable_starttls_auto: true
}
```

> ⚠️ Use environment variables or credentials to hide sensitive data.

---

## 📦 Features Breakdown

### ✅ Admin Role (Doctor, Receptionist)
- `Create User` (with email confirmation)
- `Delete User`
- `Activate / Deactivate` Users
- `View All Posts`

### ✅ Patients
- Can register on their own
- Can log in, view dashboard
- Can create posts

### ✅ All Users
- Create and view posts (shared feed)
- Reset password via email

---

## 📌 To Do

- ✅ Role-based UI
- ✅ Post system
- ⬜ Pagination for posts
- ⬜ Admin dashboard UI improvements

---

## 🤝 Contributing

Feel free to fork this repo, submit pull requests, or open issues!

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

Let me know if you'd like me to generate the models, controllers, routes, or test examples for this project too.