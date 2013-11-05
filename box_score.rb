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

    @state = json['gamecast']['current']['gameState'].strip.downcase

    period = json['gamecast']['current']['period']
    case period
    when String
      period = period.strip.to_i
    when Fixnum
      period = period
    else
      period = 0
    end

    case period
    when 0
      @min = 0
    else
      @min = (period - 1) * 12
    end

    clock = json['gamecast']['current']['clock']
    case clock
    when /^\s*\d+:/
      @min += 12 - clock.scan(/^\s*(\d+):/)[0][0].to_i
    when /^\s*\d+\./
      @min += 12
    end
  end

  def live?
    @state == "live"
  end
end
