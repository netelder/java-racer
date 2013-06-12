function Board() {}

Board.prototype.populate = function(players, track_length) {
  players.forEach(function(player) {
    $('.racer_table').append('<tr id=' + player.initials + '>');
    $('#' + player.initials).append('<td class="active"></td>');
    for (var i=1; i < track_length; i++) {
      $('#' + player.initials).append('<td></td>');
    }
    $('#' + player.initials).append('<p> ' + player.initials + ': ' + String.fromCharCode(player.key) + ' </p>');
  });
};

Board.prototype.render = function(players) {
  players.forEach(function(player) {
    $('#' + player.initials).find('td').removeClass('active');
    $('#' + player.initials).find('td:nth-child(' + player.position + ')').addClass('active');
  });
};

function Game(game_id) {
  var track_length = null;
  var start_time = null;
  var players = [];
  var board = new Board();

  this.initialize = function() {
    $.ajax({
      type: 'get',
      url: '/ajax/' + game_id
    }).done(function(response) {
      var game_data = $.parseJSON(response);
      var all_player_data = game_data['all_player_data'];
      track_length = game_data['track_length'];
      create_players(all_player_data);
      board.populate(players, track_length);
    });
  };

  create_players = function(player_list) {
    player_list.forEach(function(player_data) {
      players.push(new Player(player_data));
    });
  };

  this.start = function() {
    start_time = new Date().getTime();
  };

  this.onKeyUp = function(key) {
    players.forEach(function(player) {
      if (player.key == key) {
        if (checkGameOver(player.move())) {
          $(document).unbind("keyup");
          player.finish_time = new Date().getTime() - start_time;
          end(player);
        }
      }
    });
    board.render(players);
  };

  checkGameOver = function(position) {
    return (position >= track_length);
  };

  end = function(player) {
    $.ajax({
      type: 'post',
      url: '/ajax/' + game_id,
      data: player
    });
  };
}

function Player(player_data) {
  this.initials = player_data[0];
  this.key = player_data[1];
  this.position = 1;
  this.finish_time = null;
}

Player.prototype.move = function() {
  this.position++;
  return this.position;
};

$(document).ready(function() {
  var game_id = window.location.pathname.split('/')[2];
  var game = new Game(game_id);
  game.initialize();
  game.start();

  $(document).on('keyup', function(event) {
    game.onKeyUp(event.which);
  });
});


