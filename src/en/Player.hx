package en;

class Player extends Entity {
	public var team: Team;
	public var role: PlayerRole;
	var lastDir: TrackDirection;
	var nearbyPlayer: Array<Player>;
	var nearbyItems: Array<Item>;
	var stamina: Float;
	var sweatSpr: HSprite;
	var boostSpr: HSprite;
	var bandageSpr: HSprite;
	var frozenSpr: HSprite;

	public var trackDir(get,never) : TrackDirection; inline function get_trackDir() return level.getTrackDirection(cx, cy);

	public var speed(get,never): Float; inline function get_speed() {
		var mod = 1.0;

		if (cd.has("boost")) {
			mod += Const.PLAYER_BOOST_MOD;
		}

		return mod * Const.BASE_PLAYER_SPEED;
	}

	public function new (_team: Team, _role: PlayerRole, x: Int, y: Int) {
		super(x, y);
		team = _team;
		role = _role;
		stamina = 1.0;
		lastDir = TrackDirection.Invalid;
		nearbyPlayer = new Array<Player>();
		nearbyItems = new Array<Item>();
		sweatSpr = new HSprite(Assets.tiles, "fxSweat");
		boostSpr = new HSprite(Assets.tiles, "fxImpact0");
		bandageSpr = new HSprite(Assets.tiles, "fxBandage");
		frozenSpr = new HSprite(Assets.tiles, "fxFreeze");

		sweatSpr.setPosition(0.15*Const.GRID, -0.9*Const.GRID);
		bandageSpr.setPosition(-0.25*Const.GRID, -0.9*Const.GRID);

		boostSpr.setPosition(-0.8*Const.GRID, -0.3*Const.GRID);
		boostSpr.scale(0.5);
		boostSpr.alpha = 0.7;

		frozenSpr.setPosition(-0.25*Const.GRID, -Const.GRID);
		frozenSpr.alpha = 0.6;

		Entity.PLAYERS.push(this);
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

	override function dispose () {
    super.dispose();
    Entity.PLAYERS.remove(this);
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
					if (entity.cd.has("invisible"))
						continue;

					nearbyPlayer.push(entity.as(Player));
				} else if (entity.is(Item)) {
					nearbyItems.push(entity.as(Item));
				}
			}
		}
	}

	public function freeze (s: Float) {
		if (frozenSpr.parent == null)
			spr.addChild(frozenSpr);

		cancelVelocities();

		cd.setS("frozen", s, function () frozenSpr.remove());
	}

	public function addBandage (s: Float) {
		if (bandageSpr.parent == null)
			spr.addChild(bandageSpr);

		cancelVelocities();

		cd.setS("bandage", s, function () bandageSpr.remove());
	}

	public function removeStamina (amount: Float): Bool {
		if (stamina < amount) {
			if (!cd.has("sweat")) {
				spr.addChild(sweatSpr);
				cd.setS("sweat", 0.5, function () sweatSpr.remove());
			}

			return false;
		}

		stamina -= amount;
		return true;
	}

	function boost (): Bool {
		if (cd.has("boost") || !removeStamina(Const.PLAYER_BOOST_STAM)) {
			return false;
		}

		spr.addChild(boostSpr);
		cd.setS("boost", Const.PLAYER_BOOST_CD, function () boostSpr.remove());
		return true;
	}

	function shove (): Bool {
		if (cd.has("shove")) {
			return false;
		}

		var closestPlayer: Null<Player> = null;
		var closestDist: Float = 0.0;

		for (player in nearbyPlayer) {
			if (player.team != team) {
				var dist = distPx(player);

				if (closestPlayer == null || dist < closestDist) {
					closestDist = dist;
					closestPlayer = player;
				}
			}
		}

		if (closestPlayer != null && closestDist <= Const.PLAYER_SHOVE_DIST*Const.GRID && removeStamina(Const.PLAYER_SHOVE_STAM)) {
			cd.setS("shove", Const.PLAYER_SHOVE_CD);
			fx.shove(this, closestPlayer);
			var dx = (closestPlayer.centerX - centerX) / closestDist;
			var dy = (closestPlayer.centerY - centerY) / closestDist;
			closestPlayer.bump(dx * Const.PLAYER_SHOVE_PWR, dy * Const.PLAYER_SHOVE_PWR);
			return true;
		}

		return false;
	}

	function randomAttack () {
		if (cd.has("attack"))
			return;

		if (role == PlayerRole.Jammer && !cd.has("boost") && boost()) {
			cd.setS("attack", Const.PLAYER_AI_ATTACK_CD);
			return;
		}

		if (!cd.has("shove") && shove()) {
			cd.setS("attack", Const.PLAYER_AI_ATTACK_CD);
			return;
		}
	}

	override function update () {
		super.update();
		updateNearbyEntities();
		checkEntityCollision();

		if (!cd.has("bandage") && !cd.has("frozen"))
			stamina = Math.min(stamina + Const.PLAYER_STAM_REGEN, 1.0);

		set_dir(dxTotal < 0.0 ? -1 : 1);

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
