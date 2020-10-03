package en;

import led.Entity;

class Jammer extends Player {
	var passed: Array<Player>;

	public function new (team: Team, x: Int, y: Int) {
		super(team, PlayerRole.Jammer, x, y);
		passed = new Array<Player>();
	}

	function onPassedBlocker (blocker: Player) {
		passed.push(blocker);
		Entity.SCORES[team].onScore();
	}

	function checkPassBlocker () {
		// TODO: there is a bug somewhere here

		for (player in nearbyPlayer) {
			if (player.team != team && player.role == PlayerRole.Blocker) {
				if (passed.contains(player))
					continue;

				switch (trackDir) {
					case Down:
					if (footY > player.footY) {
						onPassedBlocker(player);
					}

					case Up:
					if (footY < player.footY) {
						onPassedBlocker(player);
					}

					case Left:
					if (footX < player.footX) {
						onPassedBlocker(player);
					}

					case Right:
					if (footX > player.footX) {
						onPassedBlocker(player);
					}

					default:
				}
			}
		}
	}

	function onPickedUp (type: ItemType) {
		switch (type) {
			case SpeedBoost:
				dx *= Const.ITEM_SPEEDBOOST_MOD;
				dy *= Const.ITEM_SPEEDBOOST_MOD;
				Assets.SFX.boost(1);

			case Teleport:
				fx.smoke(this);
				var idx = irnd(0, level.teleportLocations.length-1);
				var loc = level.teleportLocations[idx];
				setPosCase(loc.cx, loc.cy);
				cancelVelocities();
				Assets.SFX.teleport(1);

			case Explosion:
				fx.flashBangS(0xffffff, 0.9);
				Assets.SFX.explosion(1);
				for (player in nearbyPlayer) {
					var d = distPx(player);
					var dx = dy = 0.0;

					if (d > 0.0) {
						dx = (player.centerX - centerX) / d;
						dy = (player.centerY - centerY) / d;
					} else {
						dx = rnd(0.3, 0.6, true);
						dy = rnd(0.3, 0.6, true);
					}

					player.bump(dx * Const.ITEM_EXPLOSION_PWR, dy * Const.ITEM_EXPLOSION_PWR);
				}

			case Invisibility:
				spr.alpha = 0.5;
				cd.setS("invisible", Const.ITEM_INVISIBLE_TIME, function () spr.alpha = 1.0);
				Assets.SFX.invisible(1);

			case SpeedTrap:
				addBandage(Const.ITEM_TRAP_TIME);
				Assets.SFX.trap(1);
		}
	}

	function tryPickupItems() {
		for (item in Entity.ITEMS) {
			if (distCase(item) <= Const.ITEM_PICKUP_DIST) {
				onPickedUp(item.type);
				item.destroy();
			}
		}
	}

	override function onFinishedLap() {
		super.onFinishedLap();
		passed.resize(0);
	}

	override function update () {
		super.update();
		checkPassBlocker();
		tryPickupItems();
	}
}
