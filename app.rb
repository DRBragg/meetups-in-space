require 'sinatra'
require 'faker'
require 'pry'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end


end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.all.order(:name)
  erb :'meetups/index'
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  erb :'meetups/show'
end

get '/rsvp/:id' do
  if current_user
    rsvp = Rsvp.new(user: current_user, meetup: Meetup.find(params[:id]))

    if rsvp.save
      flash[:notice] = "You RSVP'd"
    end
  else
    flash[:notice] = "You must be signed in to RSVP"
  end

  redirect "/meetups/#{params[:id]}"
end

get '/unrsvp/:id' do
  Rsvp.where("user_id = ? AND meetup_id = ?", current_user.id, params[:id]).delete_all

  flash[:notice] = "You unRSVP'd"

  redirect "/meetups/#{params[:id]}"
end

get '/create' do
  @meetup = Meetup.new
  erb :create
end

post '/create' do
  @meetup = Meetup.new(params[:meetup])

  if current_user.nil?
    flash[:notice] = "You must be signed in to create a Meetup"
    erb :create
  else
    @meetup.creator_id = current_user.id

    if @meetup.save
      flash[:notice] = "New Meetup Created"
      redirect "/meetups/#{@meetup.id}"
    else
      erb :create
    end
end
end

get '/meetups/:id/edit' do
  @meetup = Meetup.find(params[:id])
  if current_user.id != @meetup.creator_id
    flash[:notice] = "You are not the owener of this Meetup"
    redirect "/meetups/#{@meetup.id}"
  else
    erb :edit
  end
end

post '/meetups/:id/edit' do
  @meetup = Meetup.find(params[:id])

  if @meetup.update(params[:meetup])
    flash[:notice] = "Meetup updated"
    redirect "/meetups/#{@meetup.id}"
  else
    erb :edit
  end
end
