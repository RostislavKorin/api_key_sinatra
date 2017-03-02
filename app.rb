require 'rubygems'
require 'sinatra'
require 'rest-client'
require 'json'


  get "/" do
    erb :home
  end

  post '/request' do
    @shop_json = RestClient.get("https://demo.shop2market.com/api/v1/shops.json", {"X-Api-Key" => params[:api_key]})
    @shop = JSON.parse(@shop_json)

    @user_json = RestClient.get("https://demo.shop2market.com/api/v1/current_user.json", {"X-Api-Key" => params[:api_key]})
    @user = JSON.parse(@user_json)

    @publishers = {}
    @shop.each do |shop|
     publishers_json = RestClient.get("https://demo.shop2market.com/api/v1/shops/#{shop["id"]}/publishers.json", {"X-Api-Key" => params[:api_key]})
     @publishers[shop["id"]] = JSON.parse(publishers_json)
    end

     erb :output
  end
