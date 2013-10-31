require 'open-uri'
require './box_score'

class ScoreBoard
  attr_reader :bss

  # TODO change data parameter to argument
  SB_URI  = "http://scores.espn.go.com/nba/scoreboard"
  GIDS_RE = %r|/nba/boxscore\?gameId=(\d+)|

  def initialize
    gids = open(SB_URI).read.scan(GIDS_RE).map { |gid| gid[0].strip.to_i }
    gids.uniq!

    @bss = []
    gids.each { |gid| bss << BoxScore.new(gid) }
  end
end
