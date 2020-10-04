package ui;

class Hud extends dn.Process {
	public var game(get,never) : Game; inline function get_game() return Game.ME;
	public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;
	public var level(get,never) : Level; inline function get_level() return Game.ME.level;

	var flow : h2d.Flow;
	var bg: h2d.Bitmap;
	var invalidated = true;

	public function new() {
		super(Game.ME);

		createRootInLayers(game.root, Const.DP_UI);
		root.filter = new h2d.filter.ColorMatrix(); // force pixel perfect rendering
		bg = new h2d.Bitmap(h2d.Tile.fromColor(0x0, 1, 1, 0.6), root);
		flow = new h2d.Flow(root);

		bg.visible = false;
	}

	override function onResize() {
		super.onResize();
		root.setScale(Const.UI_SCALE);
		flow.x = M.ceil( w()/Const.UI_SCALE*0.5 );
		flow.y = M.ceil( h()/Const.UI_SCALE*0.5 );
		bg.scaleX = w()*Const.UI_SCALE;
		bg.scaleY = h()*Const.UI_SCALE;
	}

	public inline function invalidate() invalidated = true;

	function render() {
		if (Game.ME.cd.has("starttime")) {
			if (flow.numChildren == 0) {
				bg.visible = true;
				var text = new h2d.Text(Assets.fontLarge);
				text.textAlign = h2d.Text.Align.Center;
				flow.addChild(text);
			}

			var text = Std.downcast(flow.getChildAt(0), h2d.Text);
			text.text = Std.string(Math.floor(Game.ME.cd.getS("starttime")));

			invalidate();
		} else if (flow.numChildren != 0) {
			flow.removeChildren();
			bg.visible = false;
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
