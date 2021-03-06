package en;

class AIJammer extends Jammer {
	public function new(team: Team, x: Int, y: Int) {
		super(team, x, y);
	}

	override function update (){
		if (ui.Console.ME.hasFlag("disableai"))
			return;

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
