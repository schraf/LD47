package en;

class Item extends Entity {
  public var type: ItemType;
  public var spawner: Int;

  public function new (_type: ItemType, _spawner: Int, x: Int, y: Int) {
    super(x, y);
    type = _type;
    spawner = _spawner;
    yr = 0.5;

    switch (type) {
      case SpeedBoost: spr.set("itemBoot");
      case Teleport: spr.set("itemTeleport");
      case Explosion: spr.set("itemTNT");
      case Invisibility: spr.set("itemInvisible");
      case SpeedTrap: spr.set("itemTrap");
    }

    Entity.ITEMS.push(this);
  }

  override function dispose () {
    super.dispose();

    for (i in 0...Entity.ITEMS.length) {
      if (Entity.ITEMS[i].uid == uid) {
        Entity.ITEMS.splice(i, 1);
        break;
      }
    }
  }
}
