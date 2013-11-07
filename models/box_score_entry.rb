class BoxScoreEntry
  attr_reader :bs, :pid, :fname, :lname, :min, :fgm, :fga, :ftm, :fta, :tpm, :tpa, :pts, :reb, :ast, :stl, :blk, :to

  def initialize (bs, json)
    @bs    = bs
    @pid   = json['id'].to_i
    @fname = json['firstName'].strip
    @lname = json['lastName'].strip
    @min   = json['minutes'].to_i
    @fgm   = json['fg'][/^\d+/].to_i
    @fga   = json['fg'][/\d+$/].to_i
    @ftm   = json['ft'][/^\d+/].to_i
    @fta   = json['ft'][/\d+$/].to_i
    @tpm   = json['threept'][/^\d+/].to_i
    @tpa   = json['threept'][/\d+$/].to_i
    @pts   = json['points'].to_i
    @reb   = json['rebounds'].to_i
    @ast   = json['assists'].to_i
    @stl   = json['steals'].to_i
    @blk   = json['blocks'].to_i
    @to    = json['turnovers'].to_i
    # others: json['active'], json['fouls'], json['isStarter'], json['jersey'], json['plusMinus'], json['positionAbbrev']
  end

  def played?
    @min > 0
  end

  def <=> (o)
    o.rating <=> self.rating
  end

  def rating
    if played?
      fgp = @fga == 0 ? 0 : (@fgm.to_f / @fga.to_f - 0.464) * (@fga.to_f / 20.1) * 97.6
      ftp = @fta == 0 ? 0 : (@ftm.to_f / @fta.to_f - 0.790) * (@fta.to_f / 11.7) * 78.1
      tpm = (@tpm - 0.9 ) * 3.5
      pts = (@pts - 15.6) * 0.5
      reb = (@reb - 5.6 ) * 0.9
      ast = (@ast - 3.7 ) * 1.1
      stl = (@stl - 1.1 ) * 6.4
      blk = (@blk - 0.6 ) * 4.9
      to  = (@to  - 2.0 ) * -3.4
      fgp + ftp + tpm + pts + reb + ast + stl + blk + to
    else
      -100.00
    end
  end
end
