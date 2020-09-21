Fabricator(:user) do
  email "test@example.com"
  password_digest "password"
  role :admin
end