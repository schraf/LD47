package en;

class LocalPlayerJammer extends Jammer {
  var ca: dn.heaps.Controller.ControllerAccess;

  public function new(team: Team, x: Int, y: Int) {
    super(team, x, y);
    controlledByLocalPlayer = true;
    ca = Main.ME.controller.createAccess("player");
  }

  override function dispose() {
    super.dispose();
    ca.dispose();
  }

  override function update() {
    super.update();

    var dir = level.getTrackDirection(cx, cy);

    if (ca.isDown(AXIS_LEFT_Y_POS) && dir != TrackDirection.Down) {
      dy -= Const.BASE_PLAYER_SPEED * tmod;
    }

    if (ca.isDown(AXIS_LEFT_Y_NEG) && dir != TrackDirection.Up) {
      dy += Const.BASE_PLAYER_SPEED * tmod;
    }

    if (ca.isDown(AXIS_LEFT_X_POS) && dir != TrackDirection.Left) {
      dx += Const.BASE_PLAYER_SPEED * tmod;
    }

    if (ca.isDown(AXIS_LEFT_X_NEG) && dir != TrackDirection.Right) {
      dx -= Const.BASE_PLAYER_SPEED * tmod;
    }
  }
}