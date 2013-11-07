require 'nokogiri'
require 'open-uri'
require 'json'

class Player
  GL_URI = "http://espn.go.com/nba/player/gamelog/_/id/%s/"

  def initialize (pid)
    @pid   = pid
    @games = []

    doc = Nokogiri::HTML(open(GL_URI % pid.to_s).read)
    header = doc.css("table.tablehead tr.stathead").first
    row = header.next
    while row['class'] != 'stathead'
      if row['class'][/(oddrow|evenrow)\s+team/]
        tds = row.children
        stats = {
          :date => tds[0].inner_html.strip[/[\d\/]+$/],
          :min  => tds[3].inner_html.strip.to_i,
          :fgm  => tds[4].inner_html.strip[/^\d+/].to_i,
          :fga  => tds[4].inner_html.strip[/\d+$/].to_i,
          :tpm  => tds[6].inner_html.strip[/^\d+/].to_i,
          :tpa  => tds[6].inner_html.strip[/\d+$/].to_i,
          :ftm  => tds[8].inner_html.strip[/^\d+/].to_i,
          :fta  => tds[8].inner_html.strip[/\d+$/].to_i,
          :reb  => tds[10].inner_html.strip.to_i,
          :ast  => tds[11].inner_html.strip.to_i,
          :blk  => tds[12].inner_html.strip.to_i,
          :stl  => tds[13].inner_html.strip.to_i,
          :pf   => tds[14].inner_html.strip.to_i,
          :to   => tds[15].inner_html.strip.to_i,
          :pts  => tds[16].inner_html.strip.to_i
        }
        @games << stats
      end
      row = row.next
    end

    @games.each do |g|
      fgp = g[:fga] == 0 ? 0 : (g[:fgm].to_f / g[:fga].to_f - 0.464) * (g[:fga].to_f / 20.1) * 97.6
      ftp = g[:fta] == 0 ? 0 : (g[:ftm].to_f / g[:fta].to_f - 0.790) * (g[:fta].to_f / 11.7) * 78.1
      tpm = (g[:tpm] - 0.9 ) * 3.5
      pts = (g[:pts] - 15.6) * 0.5
      reb = (g[:reb] - 5.6 ) * 0.9
      ast = (g[:ast] - 3.7 ) * 1.1
      stl = (g[:stl] - 1.1 ) * 6.4
      blk = (g[:blk] - 0.6 ) * 4.9
      to  = (g[:to]  - 2.0 ) * -3.4
      g[:rating] = (fgp + ftp + tpm + pts + reb + ast + stl + blk + to)
    end
  end

  def d3_data
    games = []
    @games.each do |game|
      games << {
        "date"    => game[:date],
        "minutes" => game[:min],
        "rating"  => game[:rating],
      }
    end
    games.to_json
  end
end

=begin

Example HTML snippet:

<tr class="oddrow team-46-8">
  <td>Tue 11/5</td>
  <td><ul class="game-schedule"><li class="game-location">@ </li><li class="team-logo-small logo-nba-small nba-small-8"><a href="http://espn.go.com/nba/team/_/name/det/detroit-pistons"></a></li><li class="team-name"><a href="http://espn.go.com/nba/team/_/name/det/detroit-pistons">DET</a></li></ul></td>
  <td><span class="greenfont">W</span> <a href="/nba/boxscore?id=400488926">99-91</a></td>
  <td style="text-align:right;">41</td>
  <td style="text-align:right;">12-18</td>
  <td style="text-align:right;">.667</td>
  <td style="text-align:right;">4-8</td>
  <td style="text-align:right;">.500</td>
  <td style="text-align:right;">3-3</td>
  <td style="text-align:right;">1.000</td>
  <td style="text-align:right;">10</td>
  <td style="text-align:right;">4</td>
  <td style="text-align:right;">0</td>
  <td style="text-align:right;">4</td>
  <td style="text-align:right;">1</td>
  <td style="text-align:right;">4</td>
  <td style="text-align:right;">31</td>
</tr>

=end
