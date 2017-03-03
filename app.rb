require 'rubygems'
require 'sinatra'
require 'rest-client'
require 'json'
require 'haml'


  get "/" do
    haml :home
  end

  post '/get_json' do
    @shop_json = RestClient.get("https://demo.shop2market.com/api/v1/shops.json", {"X-Api-Key" => params[:api_key]})
    @shop = JSON.parse(@shop_json)

    @user_json = RestClient.get("https://demo.shop2market.com/api/v1/current_user.json", {"X-Api-Key" => params[:api_key]})
    @user = JSON.parse(@user_json)

    @publishers = {}
    @shop.each do |shop|
     publishers_json = RestClient.get("https://demo.shop2market.com/api/v1/shops/#{shop["id"]}/publishers.json", {"X-Api-Key" => params[:api_key]})
     @publishers[shop["id"]] = JSON.parse(publishers_json)
    end
     haml :output
  end

  post '/post_json' do
      headers = {"X-Api-Key" => params[:api_key], content_type: :json, accept: :json}
      @products_json = RestClient.post("https://demo.shop2market.com/api/v1/shops/#{params[:shop_id]}/shop_products/batch",
                                          [{"shop_code": "#{params[:hop_code]}",
                                            "variant_id": "#{params[:variant_id]}",
                                            "deeplink": "#{params[:deeplink]}",
                                            "product_name": "#{params[:name]}",
                                            "selling_price": params[:priceinctax],
                                            "selling_price_ex": params[:pricenotax],
                                            "picture_link": "#{params[:picturelink]}"}].to_json, headers) { |response, request, result|
                                                                                                            case response.code
                                                                                                            when 200, 201, 202, 203, 204
                                                                                                              haml :created_products
                                                                                                            else
                                                                                                              haml :wasnt_created
                                                                                                            end
                                                                                                          }


    end
