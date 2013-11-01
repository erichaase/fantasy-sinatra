require 'sinatra'
require './score_board'

get '/' do
  bses = []
  ScoreBoard.new.bss.each { |bs| bs.bses.each { |bse| bses << bse } }
  bses.sort!

  # TODO use %{ to build string instead (http://stackoverflow.com/questions/1552598/building-multi-line-strings-programatically-in-ruby)
  output =  ""
  output << "<html><head><title>NBA Fantasy Player Rater</title></head><body><table border=\"1\">\n"
  output << "\t<tr>\n"
  output << "\t\t<td>Name</td>\n"
  output << "\t\t<td>MIN</td>\n"
  output << "\t\t<td>FG</td>\n"
  output << "\t\t<td>FT</td>\n"
  output << "\t\t<td>3PT</td>\n"
  output << "\t\t<td>PTS</td>\n"
  output << "\t\t<td>REB</td>\n"
  output << "\t\t<td>AST</td>\n"
  output << "\t\t<td>STL</td>\n"
  output << "\t\t<td>BLK</td>\n"
  output << "\t\t<td>TO</td>\n"
  output << "\t\t<td>Yahoo</td>\n"
  output << "\t\t<td>R</td>\n"
  output << "\t</tr>\n"
  bses.each { |bse| output << bse.to_html + "\n" }
  output << "</table></body></html>\n"
end
