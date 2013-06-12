$(document).ready(function() {
  var player_counter = 3
  $('#add-player').on('click', function(event) {
    event.preventDefault();
    $('#player-list').append(
      '<li><input class="player-field" type="text" name="players[' + 
      player_counter + ']" placeholder="Player ' + player_counter + '"></li>');
    player_counter++;
  });
});










































