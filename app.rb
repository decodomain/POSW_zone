require 'sinatra'
require 'json'

before do
  content_type 'application/json'
end

get '/zones/:zip_code' do
  zip_code = params['zip_code']
  if zip_code && zip_code =~ /^\d{5}$/
    zone = ZipDatabase.database[params['zip_code']]
    if zone 
      return zone.to_json
    else
      return {"error" => "zip code not found"}.to_json
    end
  else
    status 500
    body '{"error" => "zip code must be 5 digits"}'
  end
end

not_found do 
  status 404
  body '{"error" => "resource not found"}'
end

error do 
  {"error" => env['sinatra.error'].message}.to_json
end

class ZipDatabase
  def self.database
    @@database ||= self.get_database
  end

  def self.get_database
    JSON.parse(File.read(File.dirname(__FILE__) + '/zone_file.json'))
  end
end