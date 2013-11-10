require 'sinatra'
require_relative 'models/score_board'
require_relative 'models/player'

get '/' do
  erb ""
end

get '/ratings' do
  @navid = :today
  @bses = ScoreBoard.new.bses
  erb "ratings.html".to_sym
end

get '/ratings/:date' do
  date = params[:date].strip
  raise "Invalid date URL: '#{date}'" if not date[/^1[34]\d{4}$/]

  @bses = ScoreBoard.new(date).bses
  erb "ratings.html".to_sym
end

get '/players/:pid' do
  pid = params[:pid].strip
  raise "Invalid pid URL: '#{pid}'" if not pid[/^\d+$/]

  @d3_data = Player.new(pid.to_i).d3_data
  erb "players.html".to_sym, :layout => false
end
