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
    var dir = level.getTrackDirection(cx, cy);

    for (entity in Entity.ALL) {
      if (entity != this && entity.is(Player)) {
        var player = entity.as(Player);

        if (player.team != team && player.role == PlayerRole.Blocker) {
          if (passed.contains(player) || distCase(player) > 8)
            continue;

          switch (dir) {
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
  }

  override function onFinishedLap() {
    super.onFinishedLap();
    passed = new Array<Player>();
  }

  override function update () {
    super.update();
    checkPassBlocker();
  }
}
