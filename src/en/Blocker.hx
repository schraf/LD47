package en;

class Blocker extends Player {
  public function new (team: Team, x: Int, y: Int) {
    super(team, PlayerRole.Blocker, x, y);
  }
}
