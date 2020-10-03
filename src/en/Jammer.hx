package en;

class Jammer extends Player {
  public function new (team: Team, x: Int, y: Int) {
    super(team, PlayerRole.Jammer, x, y);
  }
}