require 'rest-client'
require 'json'

class TestController < ApplicationController
  def index
  		response = RestClient.get('https://pokeapi.co/api/v2/pokemon/2')
		results = JSON.parse(response.to_str)
		name = results['forms'][0]['name']
		puts "El nombre del pokemon es: #{name}"
		@name = name;
		@results = results;
  end
end
