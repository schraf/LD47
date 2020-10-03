package en;

class Player extends Entity {
  public var team: Team;
  public var role: PlayerRole;
  var lastDir: TrackDirection;

  public var trackDir(get,never) : TrackDirection; inline function get_trackDir() return level.getTrackDirection(cx, cy);

  public function new (_team: Team, _role: PlayerRole, x: Int, y: Int) {
    super(x, y);
    team = _team;
    role = _role;
    lastDir = TrackDirection.Invalid;
  }

  function checkEntityCollision () {
    for (entity in Entity.ALL) {
      if (entity != this && entity.is(Player)) {
        if (distPx(entity) < Const.PLAYER_HALF_WIDTH) {
          if (centerX < entity.centerX) {
            bdx -= Const.PLAYER_BUMP * Math.max(dx, 0.1);
          } else {
            bdx += Const.PLAYER_BUMP * Math.max(dx, 0.1);
          }

          if (centerY < entity.centerY) {
            bdy -= Const.PLAYER_BUMP * Math.max(dy, 0.1);
          } else {
            bdy += Const.PLAYER_BUMP * Math.max(dy, 0.1);
          }
        }
      }
    }
  }

  function onFinishedLap () {
  }

  function checkFinishedLap () {
    if (trackDir != lastDir && lastDir == TrackDirection.Up) {
      onFinishedLap();
    }
  }

  override function update () {
    super.update();
    checkEntityCollision();
    checkFinishedLap();
    lastDir = trackDir;
  }
}
