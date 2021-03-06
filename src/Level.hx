
class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return 32;
	public var hei(get,never) : Int; inline function get_hei() return 16;

	var invalidated = true;
	var gridLayer: led.Layer_IntGrid_AutoLayer;
	var dirLayer: led.Layer_IntGrid;
	var tilesLayer: led.Layer_Tiles;
	public var itemSpawners: Array<CPoint> = [];
	public var teleportLocations: Array<CPoint> = [];

	public function new(parent: dn.Process, ctx: h2d.Layers) {
		super(parent);
		createRootInLayers(ctx, Const.DP_BG);
	}

	public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
	public inline function coordId(cx,cy) return cx + cy*wid;

	public function loadTrack() {
		var tracks = new Tracks();
		var trackLayers = tracks.all_levels.Track0;
		var entities = trackLayers.l_Entities;
		dirLayer = trackLayers.l_Direction;
		gridLayer = trackLayers.l_Track;
		tilesLayer = trackLayers.l_Tiles;

		for (spawner in entities.all_Spawner) {
			var role = spawner.f_Role;
			var team = spawner.f_Team;

			if (role == Enums.PlayerRole.Jammer) {
				if (team == Enums.Team.A) {
					new en.LocalPlayerJammer(team, spawner.cx, spawner.cy);
				} else {
					new en.AIJammer(team, spawner.cx, spawner.cy);
				}
			} else {
				new en.Blocker(team, spawner.cx, spawner.cy);
			}
		}

		for (score in entities.all_Score) {
			new en.Score(score.f_Team, score.cx, score.cy);
		}

		for (itemSpawner in entities.all_ItemSpawner) {
			itemSpawners.push(new CPoint(itemSpawner.cx, itemSpawner.cy));
		}

		for (teleportLocation in entities.all_TeleportLocations) {
			teleportLocations.push(new CPoint(teleportLocation.cx, teleportLocation.cy));
		}

		invalidated = true;
	}

	public function isCollision (cx: Int, cy: Int): Bool {
		return gridLayer.getInt(cx, cy) == 0;
	}

	public function getTrackDirection (cx: Int, cy: Int): Enums.TrackDirection {
		switch (dirLayer.getInt(cx, cy)) {
			case 1: return Enums.TrackDirection.Down;
			case 2: return Enums.TrackDirection.Left;
			case 3: return Enums.TrackDirection.Right;
			case 4: return Enums.TrackDirection.Up;
		}

		return Enums.TrackDirection.Invalid;
	}

	public function render() {
		root.removeChildren();

		if (gridLayer != null) {
			for (autoTile in gridLayer.autoTiles) {
				var tile = Assets.levelTiles[autoTile.tileId];
				var bitmap = new h2d.Bitmap(tile, root);
				bitmap.setPosition(autoTile.renderX, autoTile.renderY);
			}
		}

		if (tilesLayer != null) {
			for(cx in 0...wid) {
				for(cy in 0...hei) {
					if (tilesLayer.hasTileAt(cx, cy)) {
						var tile = Assets.levelTiles[tilesLayer.getTileIdAt(cx, cy)];
						var bitmap = new h2d.Bitmap(tile, root);
						bitmap.setPosition(cx*Const.GRID, cy*Const.GRID);
					}
				}
			}
		}
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}