class Const {
	public static var FPS = 60;
	public static var FIXED_FPS = 30;
	public static var AUTO_SCALE_TARGET_WID = 512; // -1 to disable auto-scaling on width
	public static var AUTO_SCALE_TARGET_HEI = -1; // -1 to disable auto-scaling on height
	public static var SCALE = 1.0; // ignored if auto-scaling
	public static var UI_SCALE = 1.0;
	public static var GRID = 16;

	public static var BASE_PLAYER_SPEED = 0.04;
	public static var PLAYER_WALL_BUMP = 0.18;
	public static var PLAYER_BUMP = 0.18;
	public static var PLAYER_HALF_WIDTH = 8;
	public static var PLAYER_NEARBY_DIST = 4;
	public static var PLAYER_SEP_MOD = 0.01;
	public static var PLAYER_COH_MOD = 0.006;
	public static var PLAYER_AGN_MOD = 0.005;
	public static var PLAYER_ADV_MOD = 0.5;
	public static var PLAYER_RND_MOD = 0.01;
	public static var PLAYER_SHOVE_DIST = 2.0;
	public static var PLAYER_SHOVE_STAM = 0.5;
	public static var PLAYER_SHOVE_CD = 0.5;
	public static var PLAYER_SHOVE_PWR = 0.3;
	public static var PLAYER_AI_ATTACK_CD = 0.5;
	public static var PLAYER_BOOST_MOD = 0.4;
	public static var PLAYER_BOOST_CD = 1.0;
	public static var PLAYER_BOOST_STAM = 1.0;
	public static var PLAYER_STAM_REGEN = 0.005;
	public static var ITEM_SPAWN_TIMER = 12.0;
	public static var ITEM_SPAWN_RND = 3.0;
	public static var ITEM_PICKUP_DIST = 1.0;
	public static var ITEM_SPEEDBOOST_MOD = 5.0;
	public static var ITEM_EXPLOSION_PWR = 1.0;
	public static var ITEM_INVISIBLE_TIME = 4.0;
	public static var ITEM_TRAP_TIME = 3.0;
	public static var ITEM_FREEZE_TIME = 3.0;

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
