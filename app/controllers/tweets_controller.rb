class TweetsController < ApplicationController
  before_action :authenticate_user, only: [:destroy]
 
  def index
    @tweets = Tweet.order(created_at: :desc)
    render json: {
      tweets: @tweets.map do |tweet|
        {
          id: tweet.id,
          username: tweet.user.username,
          message: tweet.message
        }
      end
    }
  end

  def index_by_user
    user = User.find_by(username: params[:username])

    if user
      @tweets = user.tweets
      render json: {
        tweets: @tweets.map do |tweet|
          {
            id: tweet.id,
            username: tweet.user.username,
            message: tweet.message
          }
        end
      }
    else
      render json: { tweets: [] }
    end
  end

  def create
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      user = session.user
      @tweet = user.tweets.new(tweet_params)

      if @tweet.save
        render json: { 
          tweet: {
          username: user.username,
          message: @tweet.message
        }
      }
      else
        render json: { success: false }
      end
    else
      render json: { success: false }
    end
  end

  def destroy
    @tweet = Tweet.find_by(id: params[:id])

    if @tweet&.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  private

  def authenticate_user
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)

    unless session
      render json: { success: false }
    end
  end

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
