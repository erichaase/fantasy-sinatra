require 'open-uri'
require 'json'
require './box_score_entry'

class BoxScore
  attr_reader :bses, :min

  BS_URI = "http://scores.espn.go.com/nba/gamecast12/master?xhr=1&gameId=%s&lang=en&init=true&setType=true&confId=null"

  def initialize (gid)
    json = JSON.parse(open(BS_URI % gid.to_s).read.scan(/[[:print:]]/).join)

    bses = json['gamecast']['stats']['player']['home'][0...-1] + json['gamecast']['stats']['player']['away'][0...-1]
    @bses = []
    bses.each { |bse| @bses << BoxScoreEntry.new(self, bse) }

    @min = "#{json['gamecast']['current']['gameState']}, #{json['gamecast']['current']['period']}, #{json['gamecast']['current']['clock']}"
  end
end
