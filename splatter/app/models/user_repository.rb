class UserRepository
  BUCKET = 'users'

  # Set up connection to the Riak db
  def initialize(client)
    @client = client
  end

  def all
    keys = @client.bucket(BUCKET).keys
    riak_list = @client.bucket(BUCKET).get_many(keys)

    results = []
    riak_list.values.each do |user_obj|
      user = User.new
      user.email = user_obj.data['email']
      user.name = user_obj.data['name']
      user.password = user_obj.data['password']
      user.blurb = user_obj.data['blurb']
      user.follows = user_obj.data['follows']
      user.followers = user_obj.data['followers']
      results.push(user)
    end
    results
  end

  def delete(user)
    users = @client.bucket(BUCKET)
    key = user.email
    
    if users.exists?(key)
      users.delete(key)
    end
  end

  def find(key)
    riak_obj = @client.bucket(BUCKET)[key]
    user = User.new
    user.email = riak_obj.data['email']
    user.name = riak_obj.data['name']
    user.password = riak_obj.data['password']
    user.blurb = riak_obj.data['blurb']
    user.follows = riak_obj.data['follows']
    user.followers - riak_obj.data['followers']
    user
  end

  def save(user)
    users = @client.bucket(BUCKET)
    key = user.email

    unless users.exists?(key)
      riak_obj = users.new(key)
      riak_obj.data = user
      riak_obj.content_type = 'application/json'
      riak_obj.store
    end
  end

  def update(user)
    users = @client.bucket(BUCKET)
    key = user.email
    
    if users.exists?(key)
      riak_obj = users.new(key)
      riak_obj.data = user
      riak_obj.content_type = 'application/json'
      riak_obj.store
    end
  end

  def follow(follower, followed)
    if follower.follows
      follower.follows << followed.email
    else
      follower.followed = [followed.email]
    end

    if followed.followers
      followed.followers << follower.email
    else
      followed.followers = [follower.email]
    end

    update(followed)
    update(follower)
  end

  def unfollow(follower, followed)
    if follower.follows
      follower.follows.delete(followed.email)
    end

    if followed.followers
      followed.followers.delete(follower.email)
    end

    update(followed)
    update(follower)      
  end
end
