require 'open-uri'
require 'json'
require './box_score_entry'

class BoxScore
  attr_reader :gid, :bses, :min

  BS_URI = "http://scores.espn.go.com/nba/gamecast12/master?xhr=1&gameId=%s&lang=en&init=true&setType=true&confId=null"

  def initialize (gid)
    @gid = gid
    @bses = []

    json = JSON.parse(open(BS_URI % gid.to_s).read.scan(/[[:print:]]/).join)
    bses = json['gamecast']['stats']['player']['home'][0...-1] + json['gamecast']['stats']['player']['away'][0...-1]
    bses.each { |bse| @bses << BoxScoreEntry.new(self, bse) }
    @state = json['gamecast']['current']['gameState'].strip.downcase

    period = json['gamecast']['current']['period']
    case period
    when String
      period = period.strip.to_i
    when Fixnum
    else
      period = 0
    end

    if period < 2
      @min = 0
    else
      @min = (period - 1) * 12
    end

    clock = json['gamecast']['current']['clock'].strip
    case clock
    when /^\d+:/
      @min += 12 - clock[/^\d+/].to_i
    when /^\d+\./, /^:/
      @min += 12
    end
  end

  def live?
    @state == "live"
  end
end
