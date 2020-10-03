package en;

class Blocker extends Player {
  public function new (team: Team, x: Int, y: Int) {
    super(team, PlayerRole.Blocker, x, y);
  }

  override function update () {
    super.update();
    // TODO: make sure they stay in set range of each other
  }
}
