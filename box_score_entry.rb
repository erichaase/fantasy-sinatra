class BoxScoreEntry
  def initialize (bs, json)
    @bs             = bs
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

    # TODO verify calculation of ratings
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

  def played?
    @min > 0
  end

  def rating
    @r['TOT']
  end

  def <=> (x)
    x.rating <=> self.rating
  end

  def to_html
    if ENV['PLAYERS'] && (ENV['PLAYERS'].split(/\s*,\s*/).map { |id| id.to_i }.include? (@id))
      data_theme = "e"
    elsif @r['TOT'] >= 0
      data_theme = "b"
    else
      data_theme = "a"
    end

    # TODO add rating as a count bubble: http://www.intelligrape.com/blog/2012/10/18/setting-count-bubble-in-jquery-mobile-accordian-head/
    # TODO include parent box score (for minutes played and game log link)

    fname = @fname.gsub(/\s/, '%20')
    lname = @lname.gsub(/\s/, '%20')
    output = <<END
		<div data-role="collapsible" data-theme="#{data_theme}" data-content-theme="#{data_theme}">
			<h3>#{@fname} #{@lname} [#{@r['TOT'].to_i}] #{@bs.live? ? "<" : "["}#{@min}/#{@bs.min}#{@bs.live? ? ">" : "]"}</h3>
			<ul data-role="listview" data-inset="false" data-theme="d">
				<li>#{@fgm}-#{@fga} #{@ftm}-#{@fta} #{@tpm}-#{@tpa}, #{@pts}-#{@reb}-#{@ast}, #{@stl}-#{@blk}-#{@to}</li>
				<li><a href="#">Profile</a></li>
				<li><a target="_blank" href="http://basketball.fantasysports.yahoo.com/nba/86590/playersearch?&amp;search=#{fname}%20#{lname}">Yahoo Search</a></li>
				<li><a target="_blank" href="http://espn.go.com/nba/player/gamelog/_/id/#{@id}/">Game Log</a></li>
				<li><a href="#">Box Score</a></li>
				<li><a href="#">Depth Chart</a></li>
				<li><a target="_blank" href="http://www.rotoworld.com/content/playersearch.aspx?searchname=#{lname},%20#{fname}">Rotoworld</a></li>
			</ul>
		</div>
END
  end
end
