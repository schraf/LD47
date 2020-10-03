
class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return 32;
	public var hei(get,never) : Int; inline function get_hei() return 16;

	var invalidated = true;
	var track: led.Layer_IntGrid_AutoLayer;
	var trackDir: led.Layer_IntGrid;
	var trackTiles: led.Layer_Tiles;

	public function new() {
		super(Game.ME);
		createRootInLayers(Game.ME.scroller, Const.DP_BG);
	}

	public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
	public inline function coordId(cx,cy) return cx + cy*wid;

	public function loadTrack() {
		var tracks = new Tracks();
		var trackLayers = tracks.all_levels.Track0;
		var entities = trackLayers.l_Entities;
		trackDir = trackLayers.l_Direction;
		track = trackLayers.l_Track;
		trackTiles = trackLayers.l_Tiles;

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

		invalidated = true;
	}

	public function isCollision (cx: Int, cy: Int): Bool {
		return track.getInt(cx, cy) == 0;
	}

	public function getTrackDirection (cx: Int, cy: Int): Enums.TrackDirection {
		switch (trackDir.getInt(cx, cy)) {
			case 1: return Enums.TrackDirection.Down;
			case 2: return Enums.TrackDirection.Left;
			case 3: return Enums.TrackDirection.Right;
			case 4: return Enums.TrackDirection.Up;
		}

		return Enums.TrackDirection.Invalid;
	}

	public function render() {
		root.removeChildren();

		for (autoTile in track.autoTiles) {
			var tile = Assets.levelTiles[autoTile.tileId];
			var bitmap = new h2d.Bitmap(tile, root);
			bitmap.setPosition(autoTile.renderX, autoTile.renderY);
		}

		for(cx in 0...wid)
			for(cy in 0...hei) {
				if (trackTiles.hasTileAt(cx, cy)) {
					var tile = Assets.levelTiles[trackTiles.getTileIdAt(cx, cy)];
					var bitmap = new h2d.Bitmap(tile, root);
					bitmap.setPosition(cx*Const.GRID, cy*Const.GRID);
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