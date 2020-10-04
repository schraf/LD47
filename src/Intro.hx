
class Intro extends dn.Process {
	public static var ME : Intro;
	public var ca : dn.heaps.Controller.ControllerAccess;
	var img : h2d.Bitmap;
	var screens : Array<hxd.res.Image> = [hxd.Res.intro4, hxd.Res.intro1, hxd.Res.intro2, hxd.Res.intro3, hxd.Res.intro5];
	var screenIdx : Int;

	public function new() {
		super(Main.ME);
		ME = this;
		ca = Main.ME.controller.createAccess("intro");
		createRootInLayers(Main.ME.root, Const.DP_UI);

		img = new h2d.Bitmap(root);

		loadScreen(screenIdx++);
		dn.Process.resizeAll();
	}

	function loadScreen(id: Int) {
		img.tile = screens[id].toTile();
		cd.setMs("locked", 500);
	}

	override function onDispose() {
		super.onDispose();
		ca.dispose();
	}

	override function onResize() {
		super.onResize();
		var sx = M.ceil(w()/img.tile.width);
		var sy = M.ceil(h()/img.tile.height);
		var s = Math.min(sx, sy);
		img.setScale(s);
		img.x = ( w()*0.5 - img.tile.width*s*0.5 );
		img.y = ( h()*0.5 - img.tile.height*s*0.5 );
	}

	override function update() {
		super.update();

		if (cd.has("locked"))
			return;

		if (ca.isKeyboardPressed(hxd.Key.ESCAPE))
			hxd.System.exit();

		if (ca.startPressed() || ca.selectPressed() ||
				ca.aPressed() || ca.bPressed() || ca.xPressed() || ca.yPressed() ||
				ca.isKeyboardPressed(hxd.Key.SPACE) || ca.isKeyboardPressed(hxd.Key.ENTER)) {

			if (screenIdx >= screens.length) {
				Main.ME.startGame();
				destroy();
				return;
			}

			loadScreen(screenIdx++);
		}
	}
}
