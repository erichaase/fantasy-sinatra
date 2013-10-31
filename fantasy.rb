require 'sinatra'
require './score_board'

get '/' do
  bses = []
  ScoreBoard.new.bss.each { |bs| bs.bses.each { |bse| bses << bse } }
  bses.sort!

  output = ''
  bses.each { |bse| output += bse.to_s + "\n" }
  output
end
