package en;

class LocalPlayerJammer extends Jammer {
  var ca: dn.heaps.Controller.ControllerAccess;

  public function new(team: Team, x: Int, y: Int) {
    super(team, x, y);
    ca = Main.ME.controller.createAccess("player");
    Game.ME.camera.trackTarget(this, true);
  }

  override function dispose() {
    super.dispose();
    ca.dispose();
  }

  override function update() {
    super.update();

    if (cd.has("bandage") || cd.has("frozen"))
      return;

    var dir = level.getTrackDirection(cx, cy);

    if (ca.isDown(AXIS_LEFT_Y_POS) && dir != TrackDirection.Down) {
      dy -= speed * tmod;
    }

    if (ca.isDown(AXIS_LEFT_Y_NEG) && dir != TrackDirection.Up) {
      dy += speed * tmod;
    }

    if (ca.isDown(AXIS_LEFT_X_POS) && dir != TrackDirection.Left) {
      dx += speed * tmod;
    }

    if (ca.isDown(AXIS_LEFT_X_NEG) && dir != TrackDirection.Right) {
      dx -= speed * tmod;
    }

    if (ca.isPressed(X)) {
      shove();
    }

    if (ca.isPressed(A)) {
      boost();
    }

    if (ca.isDown(Y)) {
      debug('${pretty(dx)} ${pretty(dy)}');
    } else {
      debug();
    }
  }
}