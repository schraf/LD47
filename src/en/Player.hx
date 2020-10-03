package en;

import haxe.display.Display.Package;

class Player extends Entity {
	public var team: Team;
	public var role: PlayerRole;
	var lastDir: TrackDirection;
	var nearbyPlayer: Array<Player>;
	var nearbyItems: Array<Item>;

	public var trackDir(get,never) : TrackDirection; inline function get_trackDir() return level.getTrackDirection(cx, cy);

	public function new (_team: Team, _role: PlayerRole, x: Int, y: Int) {
		super(x, y);
		team = _team;
		role = _role;
		lastDir = TrackDirection.Invalid;
		nearbyPlayer = new Array<Player>();
		nearbyItems = new Array<Item>();
	}

	function isInFrontOf (p: Player) {
		if (trackDir == p.trackDir) {
			switch (trackDir) {
				case Down:
					return footY > p.footY;
				case Up:
					return footY < p.footY;
				case Left:
					return footX < p.footX;
				case Right:
					return footX > p.footX;
				default:
					return false;
			}
		}

		if (trackDir == Left && p.trackDir == Up)
			return true;

		if (trackDir == Down && p.trackDir == Left)
			return true;

		if (trackDir == Right && p.trackDir == Down)
			return true;

		if (trackDir == Up && trackDir == Right)
			return true;

		return false;
	}

	function checkEntityCollision () {
		for (entity in Entity.ALL) {
			if (entity != this && entity.is(Player)) {
				if (distPx(entity) < Const.PLAYER_HALF_WIDTH) {
					if (centerX < entity.centerX) {
						bdx -= Const.PLAYER_BUMP * Math.max(dx, 0.1);
					} else {
						bdx += Const.PLAYER_BUMP * Math.max(dx, 0.1);
					}

					if (centerY < entity.centerY) {
						bdy -= Const.PLAYER_BUMP * Math.max(dy, 0.1);
					} else {
						bdy += Const.PLAYER_BUMP * Math.max(dy, 0.1);
					}
				}
			}
		}
	}

	function onFinishedLap () {
	}

	function updateNearbyEntities () {
		nearbyPlayer.resize(0);
		nearbyItems.resize(0);

		for (entity in Entity.ALL) {
			if (entity != this && distCase(entity) <= Const.PLAYER_NEARBY_DIST) {
				if (entity.is(Player)) {
					nearbyPlayer.push(entity.as(Player));
				} else if (entity.is(Item)) {
					nearbyItems.push(entity.as(Item));
				}
			}
		}
	}

	override function update () {
		super.update();
		updateNearbyEntities();
		checkEntityCollision();

		if (lastDir == Invalid)
			lastDir = trackDir;

		switch (trackDir) {
			case Left:
				if (lastDir == Up) {
					lastDir = Left;
					onFinishedLap();
				}

			case Down:
				if (lastDir == Left)
					lastDir = Down;

			case Right:
				if (lastDir == Down)
					lastDir = Right;

			case Up:
				if (lastDir == Right)
					lastDir = Up;

			default:
		}
	}
}
