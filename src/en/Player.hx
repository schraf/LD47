package en;

class Player extends Entity {
  public var team: Team;
  public var role: PlayerRole;
  public var controlledByLocalPlayer: Bool;

  public function new (_team: Team, _role: PlayerRole, x: Int, y: Int) {
    super(x, y);
    controlledByLocalPlayer = false;
    team = _team;
    role = _role;

    if (team == Enums.Team.A) {
      debug(role == Enums.PlayerRole.Jammer ? 'J' : 'B', 0x0000ff);
    } else {
      debug(role == Enums.PlayerRole.Jammer ? 'J' : 'B', 0xff0000);
    }
  }
}
