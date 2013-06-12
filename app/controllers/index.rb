require 'json'

get '/' do
  erb :index
end

post '/' do
  game = Game.create(track_length: params[:track_length])
  params[:players].each do |player|
    next if player[1] == ""
    game.players << Player.find_or_create_by_initials(player[1])
  end
  redirect "/games/#{game.id}"
end

get '/games/:id' do
  @game = Game.find(params[:id])
  # @track_length = @game.track_length
  # @player1 = @game.players[0]
  # @player2 = @game.players[1]
  erb :game
end

get '/games/:id/stats' do
  game = Game.find(params[:id])
  game_stats = GamesPlayer.where('game_id = ?', game.id)
  game_stats.each do |player|
    if player[:time]
      @player = Player.find(player[:player_id]) 
      @time = player[:time].to_f / 1000
    end
  end
  erb :game_stats
end

get '/ajax/:id' do
  game = Game.find(params[:id])
  track_length = game[:track_length]
  keys = [81, 80, 90, 77, 87, 79, 88, 78]

  player_data = []
  game.players.each_with_index do |player, index|
    player_data << [player[:initials], keys[index]]
  end

  data = { all_player_data: player_data,
           track_length: track_length}
  data.to_json
end

post '/ajax/:id' do
  p "--------------#{params[:initials]}"
  player = Player.find_by_initials(params[:initials])
  p player
  player_stats = GamesPlayer.where('game_id = ? and player_id = ?', params[:id], player.id)[0]
  p player_stats
  player_stats.time = params[:finish_time]
  player_stats.save
end
