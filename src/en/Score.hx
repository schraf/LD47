package en;

class Score extends Entity {
  public var team: Team;
  public var score: Int;
  public var flow: h2d.Flow;

  public function new (_team: Team, x: Int, y: Int) {
    super(x, y);
    team = _team;
    score = 0;
    flow = new h2d.Flow();
    xr = 0.0;
    yr = 0.0;
    entityVisible = false;

    flow.addChild(new HSprite(Assets.tiles, "num0"));
    flow.addChild(new HSprite(Assets.tiles, "num0"));
    flow.addChild(new HSprite(Assets.tiles, "num0"));
    flow.reverse = true;

    Game.ME.scroller.add(flow, Const.DP_MAIN);

    setPixelOff(5, 3);

    Entity.SCORES[team] = this;
  }

  override function postUpdate () {
    super.postUpdate();
    flow.x = spr.x;
    flow.y = spr.y;
  }

  public function onScore () {
    score++;
    var d0 = score % 10;
    var d1 = Math.floor((score % 100) / 10);
    var d2 = Math.floor(score / 100);

    Std.downcast(flow.getChildAt(0), HSprite).set('num${d0}');
    Std.downcast(flow.getChildAt(1), HSprite).set('num${d1}');
    Std.downcast(flow.getChildAt(2), HSprite).set('num${d2}');
    Assets.SFX.score(1);
  }
}
