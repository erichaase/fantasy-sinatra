require 'open-uri'
require 'date'
require './box_score'

class ScoreBoard
  attr_reader :bss

  SB_URI  = "http://scores.espn.go.com/nba/scoreboard?date=%s"
  GIDS_RE = %r|/nba/boxscore\?gameId=(\d+)|

  def initialize (date)
    date = date ? Date.new(2000 + date[0,2].to_i, date[2,2].to_i, date[4,2].to_i) : Date.today

    gids = []
    while gids.empty?
      url = SB_URI % date.strftime("%Y%m%d")
      gids = open(url).read.scan(GIDS_RE).map { |gid| gid[0].strip.to_i }.uniq
      date -= 1
    end

    @bss = []
    gids.each { |gid| bss << BoxScore.new(gid) }
  end
end
