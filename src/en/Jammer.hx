package en;

class Jammer extends Player {
  var passed: Array<Player>;
  var score: Int;

  public function new (team: Team, x: Int, y: Int) {
    super(team, PlayerRole.Jammer, x, y);
    score = 0;
    passed = new Array<Player>();
  }

  function onPassedBlocker (blocker: Player) {
    passed.push(blocker);
    score++;
    debug(score);
  }

  function checkPassBlocker () {
    // TODO: there is a bug somewhere here

    for (player in nearbyPlayer) {
      if (player.team != team && player.role == PlayerRole.Blocker) {
        if (passed.contains(player))
          continue;

        switch (trackDir) {
          case Down:
            if (footY > player.footY) {
              onPassedBlocker(player);
            }

          case Up:
            if (footY < player.footY) {
              onPassedBlocker(player);
            }

          case Left:
            if (footX < player.footX) {
              onPassedBlocker(player);
            }

          case Right:
            if (footX > player.footX) {
              onPassedBlocker(player);
            }

          default:
        }
      }
    }
  }

  override function onFinishedLap() {
    super.onFinishedLap();
    passed.resize(0);
  }

  override function update () {
    super.update();
    checkPassBlocker();
  }
}
