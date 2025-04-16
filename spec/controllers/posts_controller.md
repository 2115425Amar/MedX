### **Explanation of the Test Suite for `PostsController`**

Test suite ensures that the `PostsController` behaves correctly for different users and post conditions.
---

## **1. Test Setup**
- **FactoryBot Definitions**
  - The test uses `FactoryBot` to create `User` and `Post` objects.
  - The `post` factory has traits:
    - `:private` - makes a post private (`public: false`).

- **Test Variables (`let`)**
  - `user` → The main test user.
  - `other_user` → Another user for testing unauthorized access.
  - `post_obj` → A public post created by `user`.
  - `private_post` → A private post created by `user`.

- **`before { sign_in user }`**
  - Ensures that the `user` is signed in before each test, using Devise's `sign_in` helper.

---

## **2. Testing `index` Action (`GET #index`)**
- **Purpose:** Check if the `index` action loads successfully.
- **Test:**  
  ```ruby
  it 'returns a successful response' do
    get :index
    expect(response).to be_successful
  end
  ```
  - Sends a GET request to `index`.
  - Verifies that the response is **successful (`200 OK`)**.

---

## **3. Testing `show` Action (`GET #show`)**
- **Purpose:** Ensure different users can (or cannot) access posts based on their visibility.

### ** Public Post (Accessible to All)**
```ruby
it 'returns a successful response' do
  get :show, params: { id: post_obj.id }
  expect(response).to be_successful
end
```
- Sends a GET request for a **public post**.
- Ensures that the response is **successful**.

### ** Private Post (Accessible to Owner)**
```ruby
it 'returns a successful response' do
  get :show, params: { id: private_post.id }
  expect(response).to be_successful
end
```
- The **owner** requests their private post.
- Ensures a **successful response**.

### ** Private Post (Blocked for Non-Owner)**
```ruby
before { sign_in other_user }

it 'redirects to posts index' do
  get :show, params: { id: private_post.id }
  expect(response).to redirect_to(posts_path)
end
```
- Signs in `other_user`.
- Requests a private post that **does not belong** to `other_user`.
- Expectation: Redirects to `posts_path`.

---

## **4. Testing `create` Action (`POST #create`)**
- **Purpose:** Ensure post creation works correctly.

### ** Valid Post Creation**
```ruby
it 'creates a new post' do
  expect {
    post :create, params: { post: attributes_for(:post) }
  }.to change(Post, :count).by(1)
end
```
- Sends a `POST` request with **valid post attributes**.
- Ensures a new post is **successfully created**.

### ** Invalid Post Creation**
```ruby
it 'does not create a new post' do
  expect {
    post :create, params: { post: attributes_for(:post, description: '') }
  }.not_to change(Post, :count)
end
```
- Sends a `POST` request with an **empty description**.
- Ensures that **no new post is created**.

---

## **5. Testing `update` Action (`PATCH #update`)**
- **Purpose:** Ensure a user can **update their own posts**.

### ** Owner Updates Post Successfully**
```ruby
it 'updates the post' do
  patch :update, params: { id: post_obj.id, post: { description: 'Updated' } }
  expect(post_obj.reload.description).to eq('Updated')
end
```
- Sends a `PATCH` request to update the post's `description`.
- Verifies that **the post is updated**.

---

## **6. Testing `destroy` Action (`DELETE #destroy`)**
- **Purpose:** Ensure users **can (or cannot) delete posts**.

### ** Owner Can Delete Post**
```ruby
it 'deletes the post' do
  post_to_delete = create(:post, user: user)
  expect {
    delete :destroy, params: { id: post_to_delete.id }
  }.to change(Post, :count).by(-1)
end
```
- Creates a **new post**.
- Sends a `DELETE` request.
- Ensures the **post count decreases** (i.e., post is deleted).

### ** Non-Owner Cannot Delete Post**
```ruby
before do 
  sign_in other_user
  @post = create(:post, user: user)
end

it 'does not delete the post' do
  expect {
    delete :destroy, params: { id: @post.id }
  }.not_to change(Post, :count)
end
```
- **Signs in a different user** (`other_user`).
- Attempts to delete `user`’s post.
- Ensures that the **post is not deleted**.

---

## **Summary of How the Tests Work**
| Action     | Scenario                               | Expected Result |
|------------|----------------------------------------|-----------------|
| **Index**  | Any logged-in user                    | ✅ Loads successfully |
| **Show**   | Public post                           | ✅ Loads successfully |
|            | Private post (owner)                  | ✅ Loads successfully |
|            | Private post (not owner)              | ❌ Redirects to `posts_path` |
| **Create** | Valid attributes                      | ✅ Creates post |
|            | Invalid attributes (empty description) | ❌ Does not create post |
| **Update** | Owner updates description             | ✅ Updates successfully |
| **Destroy** | Owner deletes post                    | ✅ Post deleted |
|            | Non-owner tries to delete             | ❌ Post is NOT deleted |

---

## **Why This Test Suite Is Effective**
1. **Covers all key actions** (`index`, `show`, `create`, `update`, `destroy`).  
2. **Tests different user roles** (owner vs. non-owner).  
3. **Ensures proper authorization** (only owners can update/delete).  
4. **Verifies validation rules** (empty descriptions not allowed).  

