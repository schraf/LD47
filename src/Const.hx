class Const {
	public static var FPS = 60;
	public static var FIXED_FPS = 30;
	public static var AUTO_SCALE_TARGET_WID = -1; // -1 to disable auto-scaling on width
	public static var AUTO_SCALE_TARGET_HEI = -1; // -1 to disable auto-scaling on height
	public static var SCALE = 3.0; // ignored if auto-scaling
	public static var UI_SCALE = 1.0;
	public static var GRID = 16;

	public static var BASE_PLAYER_SPEED = 0.04;
	public static var PLAYER_WALL_BUMP = 0.18;
	public static var PLAYER_BUMP = 0.18;
	public static var PLAYER_HALF_WIDTH = 8;
	public static var PLAYER_NEARBY_DIST = 3;
	public static var PLAYER_SEP_MOD = 0.01;
	public static var PLAYER_COH_MOD = 0.006;
	public static var PLAYER_AGN_MOD = 0.005;
	public static var PLAYER_ADV_MOD = 0.2;
	public static var PLAYER_RND_MOD = 0.001;

	static var _uniq = 0;
	public static var NEXT_UNIQ(get,never) : Int; static inline function get_NEXT_UNIQ() return _uniq++;
	public static var INFINITE = 999999;

	static var _inc = 0;
	public static var DP_BG = _inc++;
	public static var DP_FX_BG = _inc++;
	public static var DP_MAIN = _inc++;
	public static var DP_FRONT = _inc++;
	public static var DP_FX_FRONT = _inc++;
	public static var DP_TOP = _inc++;
	public static var DP_UI = _inc++;
}
