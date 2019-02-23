require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'open-uri'
require 'net/http'
require 'json'
require 'rubygems'
require 'sinatra/json'


enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end


get '/' do
  @posts = Post.all.order('updated_at DESC')
  erb :index
end


get '/signup' do
  erb :sign_up
end

get '/search' do
  erb :search
end

get '/home' do
  @user_posts = Post.where(user_id: current_user).order('updated_at DESC')
  erb :home
end

get '/posts/:id/edit' do
  @post =Post.find(params[:id])
  erb :edit
end

post '/posts/:id/edit' do
  post = Post.find(params[:id])
  post.comment = CGI.escape_html(params[:updated_comment])
  post.save
  redirect '/home'
end


post '/posts/:id/delete' do
  post = Post.find(params[:id])
  post.destroy
  redirect '/home'
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end

post '/signup' do
  user = User.create(
    name: params[:name],
    password: params[:password],
    icon_url: "",
    password_confirmation: params[:password_confirmation]
  )

  if params[:file]
    tempfile = params[:file][:tempfile]
    filename = params[:file][:filename]
    uploadfile =  Cloudinary::Uploader.upload(tempfile.path)
    new_user = User.last
    new_user.update_attribute(:icon_url, uploadfile['url'])
  end


  if user.persisted?
    session[:user] = user.id
    redirect '/search'
  end
  redirect '/'
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
    redirect '/search'
  end
  redirect '/'
end

get '/search' do
  erb :search
end

post '/search' do
  keyword = params[:keyword]
  uri = URI("https://itunes.apple.com/search")
  uri.query = URI.encode_www_form({term: keyword, country: "JP", media: "music", limit: 10})
  res = Net::HTTP.get_response(uri)
  returned_json = JSON.parse(res.body)
  @musics = returned_json["results"]

  erb :search

end

post '/new' do
  current_user.posts.create(
    artwork_url: params[:artwork_url],
    artist_name: params[:artist_name],
    collection_name:  params[:collection_name],
    track_name: params[:track_name],
    preview_url: params[:preview_url],
    comment: params[:comment],
    user_id: current_user.id
  )
  redirect '/home'
end
