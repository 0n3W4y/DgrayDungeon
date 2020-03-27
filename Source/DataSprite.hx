package;

import openfl.display.Sprite;

typedef DataSpriteConfig =
{
	var ID:Dynamic;
	var Name:String;
}

class DataSprite extends Sprite
{
	public var sId:Dynamic;
	public var sName:String;

	public function new( config:DataSpriteConfig ):Void
	{
		super();
		this.sId = config.ID;
		this.sName = config.Name;
	}
}
