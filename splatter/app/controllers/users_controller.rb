class UsersController < ApplicationController
  before_filter :set_headers
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    db = UserRepository.new(Riak::Client.new)
    @user = db.find(params[:id])

    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new
    @user.email = params[:email]
    @user.name = params[:name]
    @user.password = params[:password]
    @user.blurb = params[:blurb]

    db = UserRepository.new(Riak::Client.new)
    if db.save(@user)
      render json: @user, status: :created, location: @user
    else
      render json: "error", status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(user_params(params[:user]))
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  # GET /users/splatts/[:id]
  def splatts
    db = UserRepository.new(Riak::Client.new)    
    @user = db.find(params[:id])
    db = SplattsRepository.new(Riak::Client.new, @user)

    render json: db.all
  end  

  # GET /users/follows/[:id]
  def show_follows
    @user = User.find(params[:id])

    render json: @user.follows
  end

  # GET /users/followers/[:id]
  def show_followers
    @user = User.find(params[:id])

    render json: @user.followers
  end

  # POST /users/follows
  def add_follows
    db = UserRepository.new(Riak::Client.new)
    @follower = db.find(params[:id])
    @followed = db.find(params[:follows_id])

    if @db.follow(@follower, @followed)
      head :no_content
    else
      render json: "error saving follow relationship" , status: :unprocessable_entity
    end
  end

  # DELETE /users/follows/1/2
  def delete_follows
    @user = User.find(params[:id])
    @follows = User.find(params[:follows_id])

    if @user.follows.delete(@follows)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # GET /users/splatts-feed/1
  def splatts_feed
    @feed = Splatt.find_by_sql("SELECT splatts.body, splatts.user_id, splatts.created_at FROM splatts JOIN follows ON follows.followed_id=splatts.user_id WHERE follows.follower_id=#{params[:id]} ORDER BY created_at DESC")

    render json: @feed
  end

 private
  def user_params(params)
   params.permit( :email, :password, :name, :blurb)
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
