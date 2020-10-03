import en.LocalPlayerJammer;
import en.Blocker;
import en.Jammer;
import en.Player;
import h2d.Bitmap;

class Level extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

	public var wid(get,never) : Int; inline function get_wid() return 16;
	public var hei(get,never) : Int; inline function get_hei() return 16;

	var invalidated = true;
	var track: led.Layer_IntGrid_AutoLayer;

	public function new() {
		super(Game.ME);
		createRootInLayers(Game.ME.scroller, Const.DP_BG);
		loadTrack();
	}

	public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
	public inline function coordId(cx,cy) return cx + cy*wid;

	public function loadTrack() {
		var tracks = new Tracks();
		var trackLayers = tracks.all_levels.Track0;
		var entities = trackLayers.l_Entities;
		track = trackLayers.l_Track;

		for (spawner in entities.all_Spawner) {
			var role = spawner.f_Role;
			var team = spawner.f_Team;

			if (role == Enums.PlayerRole.Jammer) {
				if (team == Enums.Team.A) {
					new LocalPlayerJammer(team, spawner.cx, spawner.cy);
				} else {
					new Jammer(team, spawner.cx, spawner.cy);
				}
			} else {
				new Blocker(team, spawner.cx, spawner.cy);
			}
		}

		invalidated = true;
	}

	public function isCollision (cx: Int, cy: Int): Bool {
		return track.getInt(cx, cy) == 0;
	}

	public function getTrackDirection (cx: Int, cy: Int): Enums.TrackDirection {
		switch (track.getInt(cx, cy)) {
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
	}

	override function postUpdate() {
		super.postUpdate();

		if( invalidated ) {
			invalidated = false;
			render();
		}
	}
}