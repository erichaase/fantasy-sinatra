require 'open-uri'
require 'date'
require 'json'
require_relative 'box_score'

class ScoreBoard
  SB_URI  = "http://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?lang=en&region=us&calendartype=blacklist&limit=100&dates=%s"

  def initialize (d=nil)
    date = d ? Date.new(2000 + d[0,2].to_i, d[2,2].to_i, d[4,2].to_i) : Date.today

    gids = []
    while gids.empty?
      json = JSON.parse(open(SB_URI % date.strftime("%Y%m%d")).read.scan(/[[:print:]]/).join)
      gids = json['events'].select { |e| e['status']['type']['state'] != 'pre' }.map { |e| e['id'].to_i }.uniq
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
