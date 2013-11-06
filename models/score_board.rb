require 'open-uri'
require 'date'
require_relative 'box_score'

class ScoreBoard
  SB_URI  = "http://scores.espn.go.com/nba/scoreboard?date=%s"
  GIDS_RE = %r|/nba/boxscore\?gameId=(\d+)|

  def initialize (d=nil)
    date = d ? Date.new(2000 + d[0,2].to_i, d[2,2].to_i, d[4,2].to_i) : Date.today

    gids = []
    while gids.empty?
      url  = SB_URI % date.strftime("%Y%m%d")
      gids = open(url).read.scan(GIDS_RE).map { |gid| gid[0].strip.to_i }.uniq
      date -= 1
    end

    @bss = []
    gids.each { |gid| @bss << BoxScore.new(gid) }
  end

  def bses
    x = []
    @bss.each { |bs| bs.bses.each { |bse| x << bse if bse.played? } }
    x.sort
  end
end
