class BoxScoreEntry
  def initialize (json)
    @id             = json['id'].to_i
    @fname          = json['firstName']
    @lname          = json['lastName']
    @positionAbbrev = json['positionAbbrev']
    @jersey         = json['jersey'].to_i
    @active         = json['active']
    @isStarter      = json['isStarter']
    @fgm            = json['fg'][/^\d+/].to_i
    @fga            = json['fg'][/\d+$/].to_i
    @ftm            = json['ft'][/^\d+/].to_i
    @fta            = json['ft'][/\d+$/].to_i
    @tpm            = json['threept'][/^\d+/].to_i
    @tpa            = json['threept'][/\d+$/].to_i
    @reb            = json['rebounds'].to_i
    @ast            = json['assists'].to_i
    @stl            = json['steals'].to_i
    @fouls          = json['fouls'].to_i
    @pts            = json['points'].to_i
    @min            = json['minutes'].to_i
    @blk            = json['blocks'].to_i
    @to             = json['turnovers'].to_i
    @plusMinus      = json['plusMinus'].to_i

    @r = {}
    if (json['fg'][/\s*-\s*/])
      @r['TOT'] = -99.0
    else
      @r['FGP'] = @fga == 0 ? 0 : (@fgm.to_f / @fga.to_f - 0.464) * (@fga.to_f / 20.1) * 97.6
      @r['FTP'] = @fta == 0 ? 0 : (@ftm.to_f / @fta.to_f - 0.790) * (@fta.to_f / 11.7) * 78.1
      @r['3PM'] = (@tpm - 0.9 ) * 3.5
      @r['PTS'] = (@pts - 15.6) * 0.5
      @r['REB'] = (@reb - 5.6 ) * 0.9
      @r['AST'] = (@ast - 3.7 ) * 1.1
      @r['STL'] = (@stl - 1.1 ) * 6.4
      @r['BLK'] = (@blk - 0.6 ) * 4.9
      @r['TO']  = (@to  - 2.0 ) * -3.4
      @r['TOT'] = @r['FGP'] + @r['FTP'] + @r['3PM'] + @r['PTS'] + @r['REB'] + @r['AST'] + @r['STL'] + @r['BLK'] + @r['TO']
    end
  end

  def rating
    @r['TOT']
  end

  def <=> (x)
    x.rating <=> self.rating
  end

  def to_s
    "%5.1f  %-24s  %4.1f  %5s  %5s  %5s  %8s  %8s" % [
      @r['TOT'],
      "#{@fname} #{@lname}",
      @min,
      "#{@fgm}-#{@fga}",
      "#{@ftm}-#{@fta}",
      "#{@tpm}-#{@tpa}",
      "#{@pts}-#{@reb}-#{@ast}",
      "#{@stl}-#{@blk}-#{@to}"]
  end

  def to_html
    output =  ""
    output << "\t<tr>\n"
    output << "\t\t<td>%s</td>\n"   % "#{@fname} #{@lname}"
    output << "\t\t<td>%d</td>\n"   % @min
    output << "\t\t<td>%s</td>\n"   % "#{@fgm}-#{@fga}"
    output << "\t\t<td>%s</td>\n"   % "#{@ftm}-#{@fta}"
    output << "\t\t<td>%s</td>\n"   % "#{@tpm}-#{@tpa}"
    output << "\t\t<td>%d</td>\n"   % @pts
    output << "\t\t<td>%d</td>\n"   % @reb
    output << "\t\t<td>%d</td>\n"   % @ast
    output << "\t\t<td>%d</td>\n"   % @stl
    output << "\t\t<td>%d</td>\n"   % @blk
    output << "\t\t<td>%d</td>\n"   % @to
    output << %Q`\t\t<td><a target="_blank" href="http://basketball.fantasysports.yahoo.com/nba/86590/playersearch?&search=%s">yahoo</a></td>\n` % "#{@fname}%20#{@lname}"
    output << "\t\t<td>%.1f</td>\n" % @r['TOT']
    output << "\t</tr>\n"
  end
end
