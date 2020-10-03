package en;

class AIJammer extends Jammer {
  public function new(team: Team, x: Int, y: Int) {
    super(team, x, y);
    spr.set(Assets.tiles, "jammerB");
  }

  override function update (){
    super.update();

    switch (trackDir) {
      case Down:
        dy += Const.BASE_PLAYER_SPEED * tmod;

      case Up:
        dy -= Const.BASE_PLAYER_SPEED * tmod;

      case Left:
        dx -= Const.BASE_PLAYER_SPEED * tmod;

      case Right:
        dx += Const.BASE_PLAYER_SPEED * tmod;

      default:
    }
  }
}
