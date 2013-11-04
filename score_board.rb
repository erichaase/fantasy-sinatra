require 'open-uri'
require './box_score'

class ScoreBoard
  attr_reader :bss

  SB_URI  = "http://scores.espn.go.com/nba/scoreboard"
  GIDS_RE = %r|/nba/boxscore\?gameId=(\d+)|

  def initialize (date)
    url = date ? SB_URI + "?date=20#{date}" : SB_URI
    gids = open(url).read.scan(GIDS_RE).map { |gid| gid[0].strip.to_i }.uniq

    @bss = []
    gids.each { |gid| bss << BoxScore.new(gid) }
  end
end
