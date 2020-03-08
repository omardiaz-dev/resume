require 'json2table' # if you've installed the gem

class SearchesController < ApplicationController

	def parse(hash, iteration=0 )
		    iteration += 1
		    output = ""
		    hash.each do |key, value|

		        if value.is_a?(Hash)
		            output += "<div class='entry' style='margin-left:#{iteration}em'> <span style='font-size:#{250 - iteration*20}%'>#{key}: </span><br>"
		            output += parse(value,iteration)
		            output += "</div>"
		        elsif value.is_a?(Array)
		            output += "<div class='entry' style='margin-left:#{iteration}em'> <span style='font-size:#{250 - iteration*20}%'>#{key}: </span><br>"
		            value.each do |value|
		                if value.is_a?(String) then
		                    output += "<div style='margin-left:#{iteration}em'>#{value} </div>"
		                else
		                    output += parse(value,iteration-1)
		                end
		            end
		            output += "</div>"

		        else
		            output += "<div class='entry' style='margin-left:#{iteration}em'> <span style='font-weight: bold'>#{key}: </span>#{value}</div>"
		        end
		    end
		    return output
	end


	def getTable(hash, iteration=0 )
		
		output = ""
		if iteration >= 1
			output += "<tr hiddenByFilter=0>"
		end
		
		print iteration

		hash.each do |key, value|
=begin
			if value.is_a?(Array)
				value.each do |value|
					if value.is_a?(String) then
						output +="<td class='col1'>#{value}</td>"
					else
						output += getTable(value,iteration-1)
					end 
				end
			end
=end

			if value.is_a?(Hash)	
				output +="<td>#{key}</td><td>#{value}</td>"
			elsif value.is_a?(Array)
				value.each do |value|
					if value.is_a?(String) then
						if iteration = 0
							output += "<tr hiddenByFilter=0>"
						end
						output +="<td class='col1'>#{value}</td>"
					else
						output += getTable(value,iteration+1)
					end 
				end
			else
				output +="<td>#{value}</td>"
			end 


		end

		if iteration >= 1
			output += "</tr>"
		end 
		iteration += 1
		return output
	end



  	def new
  	end

	def show
	  	search_term = params['q'].capitalize;
	  	resp="";
	  	status = "";
	  	strTable ="";



	  	response = RestClient.get "https://api.collection.cooperhewitt.org/rest/?method=api.test.echo&access_token=fc945ba1757142fcdc093eeb88bbc96e"
		json = JSON.parse response
		
		if json != nil
	   		status = json["stat"]
	   		resp=json["stat"];
		else
	   		@jsonString = "null"
	   		return
		end

		table_options = {
					table_style: "border: 1px solid black; max-width: 600px;",
				    table_class: "table table-striped table-hover table-condensed table-bordered",
					table_attributes: "border=1"
				}
		
		if status="ok"
			if search_term == "" 
				print search_term
				response = RestClient.get "https://api.collection.cooperhewitt.org/rest/?method=cooperhewitt.shop.items.getList&access_token=fc945ba1757142fcdc093eeb88bbc96e&page=1&per_page=100"
				json = JSON.parse response
				@jsonString = json
 				json2table =  Json2table::get_html_table(json, table_options)
				#render html: json2table.html_safe
				@jsonString = json2table.html_safe
			
    			#Customizable table
    			#begin
    			strTable = "<table id='table' class='table table-striped table-hover table-condensed table-bordered' style='border: 1px solid black; max-width: 600px;'><tr><th>Id</th><th>Brand Id</th><th>status_id</th><th>name</th><th>Images</th><th>shop_url</th><th>brand</th></tr>"
    			strTable +=getTable(json)
    			strTable += "</table>"
    			@jsonString =  strTable
    			
    			

			elsif search_term != "" 
				print search_term
				strURL="https://api.collection.cooperhewitt.org/rest/?method=cooperhewitt.shop.items.getImages&access_token=fc945ba1757142fcdc093eeb88bbc96e&shop_item_id=" + search_term
			    response = RestClient.get strURL
			    RestClient.log = 'stderr'
			    json = JSON.parse response
			    status = json["stat"]
			    if status="ok"
			    	begin
			    		json2table =  Json2table::get_html_table(json, table_options)
			    		@jsonString = json2table.html_safe
			    	 rescue Exception => e
    					puts "JSON2TABLE:: Input not a valid JSON, provide valid JSON object"    #puts e.message
					    throw e
  					end
					#render html: json2table.html_safe
			    end
			end
		end


		

	end
	


end
