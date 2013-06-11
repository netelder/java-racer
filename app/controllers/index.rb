# display stats on page
# crate stats page
# button for play again with different players (redirect to '/')

get '/' do
  erb :index
end

post '/' do
  player1 = Player.find_or_create_by_initials(params[:player1])
  player2 = Player.find_or_create_by_initials(params[:player2])
  if player1.valid? && player2.valid?
    game = Game.create 
    game.players << [ player1, player2 ]
    redirect "/game/#{game.id}"
  else
    redirect '/'
  end
end

get '/game/:id' do
  @game = Game.find(params[:id])
  @player1 = @game.players[0]
  @player2 = @game.players[1]
  erb :game
end

post '/store-stats' do
  player1 = Player.find_by_initials(params[:player1_initials])
  player2 = Player.find_by_initials(params[:player2_initials])
  player1_winner = params[:player1_time] < params[:player2_time] ? 1 : 0
  player2_winner = params[:player1_time] > params[:player2_time] ? 1 : 0
  
  player1_stats = GamesPlayer.where('game_id = ? and player_id = ?', params[:game_id], player1.id)[0]
  player2_stats = GamesPlayer.where('game_id = ? and player_id = ?', params[:game_id], player2.id)[0]

  if (player1_stats.time == nil) && (player2_stats.time == nil)
    player1_stats.time = params[:player1_time]
    player1_stats.winner = player1_winner
    player1_stats.save
    
    player2_stats.time = params[:player2_time]
    player2_stats.winner = player2_winner
    player2_stats.save
  end
end

get '/game/:id/stats' do
  game = Game.find(params[:id])
  @player1 = game.players[0]
  @player2 = game.players[1]
  stats = GamesPlayer.where('game_id = ?', game.id)
  @player1_time = stats[0].time
  @player2_time = stats[1].time
  @winner = stats[0].winner == 1 ? @player1 : @player2
  @loser = stats[0].winner == 1 ? @player2 : @player1
  erb :game_stats
end
