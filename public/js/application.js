function Player(name) {
  this.name = name;
  this.id = $('#'+this.name+'_strip');
  this.counter = 0;
  this.finish_time = null;
  
  this.findBox = function() {
    return this.id.children('td[class="active"]');
  };

  this.move = function() {
    var currentBox = this.findBox();
    var nextBox = this.findBox().next();
    currentBox.removeAttr('class');
    nextBox.attr('class','active');
  };

  this.play = function() {
    this.move();
    this.counter++;
    if (this.counter == this.id.children().length - 1) {
      this.finish_time = new Date().getTime();
      this.play = null;
    };
  };
}

$(document).ready(function () {
  alert("Click OK to start game!");
  var start_time = new Date().getTime();

  var player1 = new Player('player1');
  var player2 = new Player('player2');

  $(document).on('keyup', function(event) {
    if ( event.which == 81 ) {
      player1.play();
    }
    else if ( event.which == 80 ) {
      player2.play();
    }

    if (player1.finish_time && player2.finish_time) {
      var player1_finish_time = player1.finish_time - start_time;
      var player2_finish_time = player2.finish_time - start_time;
      $('#player1_time').attr('value', player1_finish_time);
      $('#player2_time').attr('value', player2_finish_time);
      $('#finish-button').click();
    }
  });

  $('#game-form').on('submit', function(event) {
    event.preventDefault();

    $.ajax({
      type: 'post',
      url: '/store-stats',
      data: $(this).serialize()
    });
  });
});
