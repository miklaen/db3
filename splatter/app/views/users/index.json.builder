json.users @users do |user|
  json.name @user.name
  json.email @user.email
  json.blurb @user.blurb
end
