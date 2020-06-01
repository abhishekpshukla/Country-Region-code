# THE CODE IS BELOW TO GENERATE A COUNTRY REGION CODE...
# THE OUTPUT WILL BE country_code, region_code, region_name
# NEED A carmen GEM - https://github.com/carmen-ruby/carmen 'gem install carmen'

require 'carmen'
require 'json'
require 'csv'


class CountryCode
	include Carmen
	
	attr_reader :countries
	def initialize
		@countries = Carmen::Country.all
	end

	def perform
		countries_json = []

		@countries.each do |country|
			country.subregions.each do |sub_region|
				countries_json << generate_json(country, sub_region)
			end 
		end
		generate_json_file(countries_json)
		generate_csv(countries_json)
	end

	private

	def generate_json(country, sub_region)
		{
			country_code: country.alpha_2_code,
			region_code: sub_region.code,
			region_name: sub_region.name
		}
	end

	def generate_json_file(countries_json)
		File.open("countries_region_code.json","w") do |f|
		  f.write(countries_json.to_json)
		end
	end

	def generate_csv(countries_json)
		CSV.open("countries_region_code.csv", "w",  write_headers: true, headers: ["country_code","region_code","region_name"]) do |csv|
		  JSON.parse(File.open("countries_region_code.json").read).each do |hash|
		    csv << hash.values
		  end
		end
	end

end

country_code = CountryCode.new
country_code.perform