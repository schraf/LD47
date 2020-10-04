package en;

class AIJammer extends Jammer {
	public function new(team: Team, x: Int, y: Int) {
		super(team, x, y);
		spr.set(Assets.tiles, "jammerB");
	}

	override function update (){
		super.update();

		if (cd.has("bandage") || cd.has("frozen"))
			return;

		switch (trackDir) {
			case Down:
				dy += speed * tmod;

			case Up:
				dy -= speed * tmod;

			case Left:
				dx -= speed * tmod;

			case Right:
				dx += speed * tmod;

			default:
		}

		randomAttack();
	}
}
