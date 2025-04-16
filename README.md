# README


![alt text](landingPage.png)
-------------------------------------
![alt text](register.png)
------------------------------------
![alt text](login.png)
------------------------------------
![alt text](forgotPassword.png)
-------------------------------------
![alt text](resetpassword.png)
-----------------------------------
![alt text](<Screenshot (243).png>)
----------------------------------
![alt text](update.png)
------------------------------------
![alt text](post-admin.png)
------------------------------------
![alt text](manageuser-index.png)
------------------------------------
![alt text](uploaduser.png)
-------------------------------------
![alt text](createuserby-admin.png)
--------------------------------------
![alt text](reports.png)
----------------------------------
![alt text](show-post.png)
-----------------------------
![alt text](edit-post.png)
---------------------------------



<!-- Mobile View -->
![alt text](<Screenshot 2025-03-21 122551.png>)

![alt text](<Screenshot 2025-03-21 122606.png>)

![alt text](<Screenshot 2025-03-21 122626.png>)

![alt text](<Screenshot 2025-03-21 122708.png>)

![alt text](<Screenshot 2025-03-21 122815.png>)

![alt text](<Screenshot 2025-03-21 122826.png>)

![alt text](<Screenshot 2025-03-21 123328.png>)

![alt text](<Screenshot 2025-03-21 123924.png>)

![alt text](<Screenshot 2025-03-21 125613.png>)

![alt text](<Screenshot 2025-03-21 124447.png>)

![alt text](<Screenshot 2025-03-21 124918.png>)

![alt text](<Screenshot 2025-03-21 124939.png>)


### FEATURES

- Users can create posts, comment on posts, and like both posts and comments.
- Roles define user permissions (e.g., Admin, User, etc.).
- Polymorphic associations allow likes to be attached to multiple models.
- Cloudinary is used for avatar image uploads.
- Devise handles user authentication.
- Rolify manages roles and permissions.


Your application uses multiple **associations** (`has_many`, `belongs_to`, `has_and_belongs_to_many`, `polymorphic`). Here’s how the **database schema** and **relationship tables** would look based on your models.

---

# **🔹 1. Users Table (`users`)**
This table stores **user details**.

| Column Name     | Data Type    | Constraints |
|----------------|-------------|-------------|
| id             | integer (PK) | Primary Key |
| first_name     | string       | NOT NULL    |
| last_name      | string       | NOT NULL    |
| email          | string       | UNIQUE, NOT NULL |
| phone_number   | string       | UNIQUE, NOT NULL |
| encrypted_password | string   | NOT NULL (Managed by Devise) |
| avatar_public_id | string    | Nullable (Cloudinary Avatar ID) |
| active         | boolean      | Default: `true` |
| created_at     | timestamp    | Auto-generated |
| updated_at     | timestamp    | Auto-generated |

- **Primary Key:** `id`
- **Associations:**
  - `has_many :posts`
  - `has_many :likes`
  - `has_many :comments, through: :posts`
  - `has_and_belongs_to_many :roles`

---

# **🔹 2. Roles Table (`roles`)**
This table defines **different roles** (Admin, User, etc.).

| Column Name | Data Type    | Constraints |
|------------|-------------|-------------|
| id         | integer (PK) | Primary Key |
| name       | string       | NOT NULL (e.g., "admin", "user") |
| created_at | timestamp    | Auto-generated |
| updated_at | timestamp    | Auto-generated |

- **Primary Key:** `id`
- **Associations:**  
  - `has_and_belongs_to_many :users`

---

# **🔹 3. Users Roles Join Table (`users_roles`)**
This is a **join table** that links users to their roles (**Many-to-Many** relationship).

| Column Name | Data Type    | Constraints |
|------------|-------------|-------------|
| user_id    | integer (FK) | Foreign Key to `users.id` |
| role_id    | integer (FK) | Foreign Key to `roles.id` |

- **Primary Keys:** `user_id`, `role_id` (Composite Key)
- **Associations:**  
  - `belongs_to :user`
  - `belongs_to :role`

---

# **🔹 4. Posts Table (`posts`)**
Stores **user-created posts**.

| Column Name  | Data Type    | Constraints |
|-------------|-------------|-------------|
| id          | integer (PK) | Primary Key |
| user_id     | integer (FK) | Foreign Key to `users.id` |
| description | text         | NOT NULL    |
| created_at  | timestamp    | Auto-generated |
| updated_at  | timestamp    | Auto-generated |

- **Primary Key:** `id`
- **Associations:**  
  - `belongs_to :user`
  - `has_many :comments`
  - `has_many :likes, as: :likeable`

---

# **🔹 5. Comments Table (`comments`)**
Stores **comments on posts**.

| Column Name  | Data Type    | Constraints |
|-------------|-------------|-------------|
| id          | integer (PK) | Primary Key |
| user_id     | integer (FK) | Foreign Key to `users.id` |
| post_id     | integer (FK) | Foreign Key to `posts.id` |
| content     | text         | NOT NULL    |
| created_at  | timestamp    | Auto-generated |
| updated_at  | timestamp    | Auto-generated |

- **Primary Key:** `id`
- **Associations:**  
  - `belongs_to :user`
  - `belongs_to :post`
  - `has_many :likes, as: :likeable`

---

# **🔹 6. Likes Table (`likes`)**
Tracks **likes on posts and comments** (Polymorphic Association).

| Column Name  | Data Type    | Constraints |
|-------------|-------------|-------------|
| id          | integer (PK) | Primary Key |
| user_id     | integer (FK) | Foreign Key to `users.id` |
| likeable_id | integer (FK) | Foreign Key to either `posts.id` or `comments.id` |
| likeable_type | string     | Either "Post" or "Comment" |
| created_at  | timestamp    | Auto-generated |
| updated_at  | timestamp    | Auto-generated |

- **Primary Key:** `id`
- **Associations:**  
  - `belongs_to :user`
  - `belongs_to :likeable, polymorphic: true`

### **🔹 Example Polymorphic Data**
| id | user_id | likeable_id | likeable_type |
|----|--------|------------|--------------|
| 1  | 101    | 50         | "Post"       |
| 2  | 102    | 80         | "Comment"    |

- Like **ID 1** is for **Post ID 50**.
- Like **ID 2** is for **Comment ID 80**.

---

# **🔹 ERD (Entity-Relationship Diagram)**

```plaintext
+-------------------+       +--------------------+
|       users      |       |       roles        |
+-------------------+       +--------------------+
| id (PK)          |       | id (PK)           |
| first_name       |       | name              |
| last_name        |       | created_at        |
| email (unique)   |       | updated_at        |
| phone_number     |       +--------------------+
| active          |
+-------------------+
        |  
        | has_and_belongs_to_many
        v  
+-------------------+
|   users_roles    |
+-------------------+
| user_id (FK)     |
| role_id (FK)     |
+-------------------+

+-------------------+       +--------------------+
|      posts       |       |      comments      |
+-------------------+       +--------------------+
| id (PK)          |       | id (PK)           |
| user_id (FK)     |       | user_id (FK)      |
| description      |       | post_id (FK)      |
| created_at       |       | content           |
+-------------------+       +--------------------+
        |  
        | has_many
        v  
+-------------------+
|      likes       |
+-------------------+
| id (PK)          |
| user_id (FK)     |
| likeable_id (FK) |
| likeable_type    |
+-------------------+

```

---

# **🔹 Summary**
✅ **One-to-Many Relations:**
- `User → has_many → Posts`
- `User → has_many → Likes`
- `User → has_many → Comments (through Posts)`

✅ **Many-to-Many Relations:**
- `Users <-> Roles` (via `users_roles` table)

✅ **Polymorphic Relations:**
- `Like → belongs_to → likeable (either Post or Comment)`

---





### **🔍 Explanation of SQL Queries in `download_report` Method**

Your `download_report` method generates different types of reports (`all_users`, `active_users`, `postwise`) using **raw SQL queries** via `find_by_sql`. Let's break them down.

---

## **1️⃣ Query for "all_users" Report**
```sql
SELECT users.id, users.first_name, users.last_name, users.email,
       COUNT(DISTINCT posts.id) AS posts_count,
       COUNT(DISTINCT comments.id) AS comments_count,
       COUNT(DISTINCT likes.id) AS likes_count
FROM users
LEFT JOIN posts ON posts.user_id = users.id
LEFT JOIN comments ON comments.user_id = users.id
LEFT JOIN likes ON likes.user_id = users.id
GROUP BY users.id;
```
### **📌 Explanation:**
- Retrieves **all users** along with their **post count, comment count, and like count**.
- `LEFT JOIN` is used to include users **even if they have no posts, comments, or likes**.
- `COUNT(DISTINCT posts.id)`: Counts unique posts created by each user.
- `COUNT(DISTINCT comments.id)`: Counts unique comments made by each user.
- `COUNT(DISTINCT likes.id)`: Counts unique likes made by each user.
- `GROUP BY users.id`: Groups results by user to calculate counts per user.

### **🛠 Example Output:**
| id  | first_name | last_name | email          | posts_count | comments_count | likes_count |
|-----|-----------|----------|---------------|-------------|----------------|-------------|
| 101 | John      | Doe      | john@xyz.com  | 5           | 10             | 15          |
| 102 | Alice     | Smith    | alice@xyz.com | 0           | 2              | 3           |

---

## **2️⃣ Query for "active_users" Report**
```sql
SELECT users.id, users.first_name, users.last_name, users.email,
       COUNT(DISTINCT posts.id) AS posts_count,
       COUNT(DISTINCT comments.id) AS comments_count,
       COUNT(DISTINCT likes.id) AS likes_count
FROM users
LEFT JOIN posts ON posts.user_id = users.id
LEFT JOIN comments ON comments.user_id = users.id
LEFT JOIN likes ON likes.user_id = users.id
GROUP BY users.id
HAVING COUNT(posts.id) > 10;
```
### **📌 Explanation:**
- **Same as "all_users" query**, but includes only users who have **more than 10 posts**.
- `HAVING COUNT(posts.id) > 10`: Filters users who have posted **more than 10 times**.
- `HAVING` is used because **aggregate functions (`COUNT()`) cannot be used with `WHERE`**.

### **🛠 Example Output:**
| id  | first_name | last_name | email          | posts_count | comments_count | likes_count |
|-----|-----------|----------|---------------|-------------|----------------|-------------|
| 101 | John      | Doe      | john@xyz.com  | 15          | 20             | 25          |
| 104 | Sarah     | Lee      | sarah@xyz.com | 12          | 5              | 10          |

👉 **Users with less than 10 posts are excluded!**

---

## **3️⃣ Query for "postwise" Report**
```sql
SELECT posts.id, posts.description,
       COUNT(DISTINCT comments.id) AS comments_count,
       COUNT(DISTINCT likes.id) AS likes_count
FROM posts
LEFT JOIN comments ON comments.post_id = posts.id
LEFT JOIN likes ON likes.likeable_id = posts.id AND likes.likeable_type = 'Post'
GROUP BY posts.id;
```
### **📌 Explanation:**
- Retrieves all **posts** along with their **comment count and like count**.
- `LEFT JOIN comments ON comments.post_id = posts.id`: Joins comments related to the post.
- `LEFT JOIN likes ON likes.likeable_id = posts.id AND likes.likeable_type = 'Post'`:
  - Ensures that **only likes related to posts** (not comments) are counted.
- `GROUP BY posts.id`: Groups by post ID.

### **🛠 Example Output:**
| id  | description       | comments_count | likes_count |
|-----|------------------|---------------|------------|
| 201 | "Hello World"    | 5             | 10         |
| 202 | "My First Post"  | 2             | 3          |

---

## **📢 Summary of Key Concepts**
| SQL Feature         | Purpose |
|---------------------|---------|
| **`LEFT JOIN`**    | Includes records even if there's no match in the joined table. |
| **`COUNT(DISTINCT column)`** | Counts unique records, avoiding duplicates. |
| **`GROUP BY`**      | Groups rows based on a column to apply aggregate functions (`COUNT`, `SUM`). |
| **`HAVING`**        | Filters groups based on aggregate values (like `COUNT(posts.id) > 10`). |




👉

### **Authentication (Devise)**
1. **User Registration**:
   - Sign up: `/users/sign_up` (GET)
   - Create user: `/users` (POST)

2. **User Sessions**:
   - Login: `/users/sign_in` (GET)
   - Create session: `/users/sign_in` (POST)
   - Logout: `/users/sign_out` (DELETE)

---

### **Posts**
1. **Posts**:
   - List all posts: `/posts` (GET)
   - Create a new post: `/posts` (POST)
   - Show a specific post: `/posts/:id` (GET)
   - Edit a post: `/posts/:id/edit` (GET)
   - Update a post: `/posts/:id` (PATCH/PUT)
   - Delete a post: `/posts/:id` (DELETE)

2. **Comments on Posts**:
   - Create a comment: `/posts/:post_id/comments` (POST)
   - Delete a comment: `/posts/:post_id/comments/:id` (DELETE)

3. **Likes on Posts**:
   - Like a post: `/posts/:post_id/likes` (POST)
   - Unlike a post: `/posts/:post_id/likes/:id` (DELETE)

---

### **Comments**
1. **Likes on Comments**:
   - Like a comment: `/comments/:comment_id/likes` (POST)
   - Unlike a comment: `/comments/:comment_id/likes/:id` (DELETE)

---

### **Profile**
1. **User Profile**:
   - View profile: `/profile` (GET)

---

### **Reports**
1. **Reports**:
   - List reports: `/reports` (GET)
   - Download report: `/reports/download_report` (GET)

---

### **Manage Users**
1. **Manage Users**:
   - List users: `/manage_users` (GET)
   - Create a new user: `/manage_users` (POST)
   - Toggle user status: `/manage_users/:id/toggle_status` (PATCH)

2. **Bulk Upload**:
   - Show upload form: `/manage_users/upload` (GET)
   - Upload users: `/manage_users/upload_users` (POST)

---

### **Home**
1. **Home**:
   - Root: `/` (GET)
   - Landing page: `/landing` (GET)

---

### **Sidekiq**
1. **Sidekiq Web UI**:
   - Access Sidekiq dashboard: `/sidekiq` (GET)

---

### **Summary of URLs**
| **URL**                              | **HTTP Method** | **Controller#Action**           |
|--------------------------------------|-----------------|---------------------------------|
| `/users/sign_up`                     | GET             | `users/registrations#new`       |
| `/users`                             | POST            | `users/registrations#create`    |
| `/users/sign_in`                     | GET             | `users/sessions#new`            |
| `/users/sign_in`                     | POST            | `users/sessions#create`         |
| `/users/sign_out`                    | DELETE          | `users/sessions#destroy`        |
| `/posts`                             | GET             | `posts#index`                   |
| `/posts`                             | POST            | `posts#create`                  |
| `/posts/:id`                         | GET             | `posts#show`                    |
| `/posts/:id/edit`                    | GET             | `posts#edit`                    |
| `/posts/:id`                         | PATCH/PUT       | `posts#update`                  |
| `/posts/:id`                         | DELETE          | `posts#destroy`                 |
| `/posts/:post_id/comments`           | POST            | `comments#create`               |
| `/posts/:post_id/comments/:id`       | DELETE          | `comments#destroy`              |
| `/posts/:post_id/likes`              | POST            | `likes#create`                  |
| `/posts/:post_id/likes/:id`          | DELETE          | `likes#destroy`                 |
| `/comments/:comment_id/likes`        | POST            | `likes#create`                  |
| `/comments/:comment_id/likes/:id`    | DELETE          | `likes#destroy`                 |
| `/profile`                           | GET             | `users#profile`                 |
| `/reports`                           | GET             | `reports#index`                 |
| `/reports/download_report`           | GET             | `reports#download_report`       |
| `/manage_users`                      | GET             | `manage_users#index`            |
| `/manage_users`                      | POST            | `manage_users#create`           |
| `/manage_users/:id/toggle_status`    | PATCH           | `manage_users#toggle_status`    |
| `/manage_users/upload`               | GET             | `manage_users#upload`           |
| `/manage_users/upload_users`         | POST            | `manage_users#upload_users`     |
| `/`                                 | GET             | `home#index`                    |
| `/landing`                           | GET             | `home#landing`                  |
| `/sidekiq`                           | GET             | `Sidekiq::Web`                  |

---

This table provides a clear overview of all the URLs, their corresponding HTTP methods, and the controller actions they map to. Let me know if you need further clarification!




Your unit tests for `UsersController` are structured using **RSpec** and **FactoryBot**, and they are validating the functionality of different actions in the controller. Here’s a detailed breakdown of how your unit testing works:

---

## **1. Testing Setup**
### **RSpec Configuration**
- `RSpec.describe UsersController, type: :controller do`  
  → This tells RSpec that you are testing a Rails controller.
- `let(:user) { create(:user) }`  
  → Defines a **regular user** using FactoryBot.
- `let(:admin) { create(:user, :admin) }`  
  → Defines an **admin user** using a FactoryBot trait (`:admin`).

---

## **2. Testing the `#index` Action**
The `index` action lists all users.  

### **Context: When the user is logged in**
- `before { sign_in user }`  
  → Simulates a logged-in user using Devise’s `sign_in` helper.

#### **Test 1: Ensuring a successful response**
```ruby
it 'returns a successful response' do
  get :index
  expect(response).to be_successful
end
```
- `get :index` → Simulates an HTTP `GET` request to the `index` action.
- `expect(response).to be_successful` → Ensures that the request is successful (HTTP 200 OK).

#### **Test 2: Ensuring `@users` is assigned correctly**
```ruby
it 'assigns @users' do
  users = create_list(:user, 3)
  get :index
  expect(assigns(:users)).to match_array([user] + users)
end
```
- `create_list(:user, 3)` → Creates 3 new users.
- `expect(assigns(:users)).to match_array([user] + users)`  
  → Checks if `@users` contains both the logged-in user and the newly created users.

### **Context: When the user is NOT logged in**
```ruby
it 'redirects to login page' do
  get :index
  expect(response).to redirect_to(new_user_session_path)
end
```
- `get :index` → Sends a request without signing in a user.
- `expect(response).to redirect_to(new_user_session_path)`  
  → Ensures that unauthenticated users are redirected to the login page.

---

## **3. Testing the `#show` Action**
The `show` action displays details of a specific user.

### **Context: When the user is logged in**
#### **Test 1: Ensuring a successful response**
```ruby
it 'returns a successful response' do
  get :show, params: { id: user.id }
  expect(response).to be_successful
end
```
- `get :show, params: { id: user.id }`  
  → Simulates an HTTP `GET` request for a specific user's profile.
- `expect(response).to be_successful`  
  → Ensures that the response is successful.

#### **Test 2: Ensuring the correct user is assigned**
```ruby
it 'assigns the requested user to @user' do
  get :show, params: { id: user.id }
  expect(assigns(:user)).to eq(user)
end
```
- `expect(assigns(:user)).to eq(user)`  
  → Ensures that `@user` in the controller matches the user in the request.

### **Context: When the user is NOT logged in**
```ruby
it 'redirects to login page' do
  get :show, params: { id: user.id }
  expect(response).to redirect_to(new_user_session_path)
end
```
- Similar to the `index` test, but checks for `show`.

---

## **4. How FactoryBot Works**
FactoryBot simplifies test data creation. Your `user` factory looks like this:

```ruby
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:phone_number) { |n| "123456789#{n}" }
    first_name { 'John' }
    last_name { 'Doe' }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end
  end
end
```
- **`sequence(:email)`** ensures unique emails like `user1@example.com`, `user2@example.com`.
- **`trait :admin`** assigns the `admin` role after creating a user.

---

## **5. Devise Authentication in Tests**
- `sign_in user` → Logs in a user.
- `sign_out user` → Logs out the user.
- `expect(response).to redirect_to(new_user_session_path)`  
  → Ensures Devise redirects unauthenticated users.

---

## **Summary**
✅ Ensures `index` lists users correctly.  
✅ Ensures `show` displays user details properly.  
✅ Validates access control (redirects unauthorized users).  
✅ Uses FactoryBot to create test data efficiently.  

Let me know if you need more explanation! 🚀



