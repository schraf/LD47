package en;

class Blocker extends Player {
	public function new (team: Team, x: Int, y: Int) {
		super(team, PlayerRole.Blocker, x, y);
		var animName = 'blocker${team == Team.A ? 'A' : 'B'}';
		spr.anim.registerStateAnim(animName+'.idle', 0, 0.07);
		spr.anim.registerStateAnim(animName+'.walk', 1, 0.2, function() return (dx != 0 || dy != 0));
	}

	override function update () {
		super.update();

		if (cd.has("bandage") || cd.has("frozen"))
			return;

		var nearJammer = false;

		// flocking beharior with other blockers
		for (player in nearbyPlayer) {
			if (player.team == team && player.role == PlayerRole.Blocker) {
				var d = distCase(player);

				// separation
				if (d < 1.0) {
					dx += Const.PLAYER_SEP_MOD * (player.footX - footX) * speed * tmod;
					dy -= Const.PLAYER_SEP_MOD * (player.footY - footY) * speed * tmod;
				}

				// cohesion
				if (d > Const.PLAYER_NEARBY_DIST * 0.75) {
					dx -= Const.PLAYER_COH_MOD * (player.footX - footX) * speed * tmod;
					dy += Const.PLAYER_COH_MOD * (player.footY - footY) * speed * tmod;
				}

				// alignment
				dx += player.dx * Const.PLAYER_AGN_MOD * tmod;
				dy += player.dy * Const.PLAYER_AGN_MOD * tmod;
			}
		}

		// attacking the jammer
		for (player in nearbyPlayer) {
			if (player.team != team && player.role == PlayerRole.Jammer) {
				if (player.isInFrontOf(this)) {
					switch (trackDir) {
						case Down: dy = 0.0;
						case Up: dy = 0.0;
						case Left: dx = 0.0;
						case Right: dx = 0.0;
						default:
					}
				} else {
					if (trackDir == Left || trackDir == Right) {
						if (footY < player.footY) {
							dy += speed * 0.5 * tmod;
						} else {
							dy -= speed * 0.5 * tmod;
						}
					} else {
						if (footX < player.footX) {
							dx += speed * 0.5 * tmod;
						} else {
							dx -= speed * 0.5 * tmod;
						}
					}
				}

				nearJammer = true;
				break;
			}
		}

		if (!nearJammer) {
			switch (trackDir) {
				case Down:
				dy += Const.PLAYER_ADV_MOD * speed * tmod;
				dx += rnd(0.0, Const.PLAYER_RND_MOD, true) * speed * tmod;

				case Up:
				dy -= Const.PLAYER_ADV_MOD * speed * tmod;
				dx += rnd(0.0, Const.PLAYER_RND_MOD, true) * speed * tmod;

				case Left:
				dx -= Const.PLAYER_ADV_MOD * speed * tmod;
				dy += rnd(0.0, Const.PLAYER_RND_MOD, true) * speed * tmod;

				case Right:
				dx += Const.PLAYER_ADV_MOD * speed * tmod;
				dy += rnd(0.0, Const.PLAYER_RND_MOD, true) * speed * tmod;

				default:
			}
		}

		randomAttack();
	}
}
