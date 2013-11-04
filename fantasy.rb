require 'sinatra'
require './score_board'

get '/' do
  if params.size > 0
    url = '/ratings?'
    params.keys.each do |param|
      if url == '/ratings?'
        url << "#{param}=#{params[param]}"
      else
        url << "&#{param}=#{params[param]}"
      end
    end
  else
    url = '/ratings'
  end

  redirect url
end

get '/ratings' do
  bses = []
  ScoreBoard.new(params['date']).bss.each { |bs| bs.bses.each { |bse| bses << bse } }
  bses.sort!

  output = <<END
<!doctype html>
<html>
	<head>
		<title>NBA Player Rater</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.css" />
		<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
		<script src="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.js"></script>
	</head>
	<body><div data-role="page"><div data-role="content"><div data-role="collapsible-set" data-inset="false">
END

  bses.each { |bse| output << bse.to_html }

  output << <<END
	</div></div></div></body>
</html>
END
end
