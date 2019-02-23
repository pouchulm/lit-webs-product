require 'bundler'
require 'dotenv'
Bundler.require
require './app'
require './app.rb'

Dotenv.load

Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUD_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']

  config.secure = true
  config.cdn_subdomain = true
end


run Sinatra::Application
