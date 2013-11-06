require 'sinatra'
require_relative 'models/score_board'

get '/' do
  redirect '/ratings'
end

get '/ratings' do
  @bses = ScoreBoard.new.bses
  erb :ratings
end

get '/ratings/:date' do
  date = params[:date].strip
  raise "Invalid date URL: '#{date}'" if not date[/^1[34]\d{4}$/]
  @bses = ScoreBoard.new(date).bses
  erb :ratings
end

get '/players/:pid' do
  pid = params[:pid].strip
  raise "Invalid pid URL: '#{pid}'" if not pid[/^\d+$/]
  pid = pid.to_i
  @ds_minutes = ''
  @ds_ratings = ''
  erb :players
end
