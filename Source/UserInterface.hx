package;

import openfl.display.Sprite;
import openfl.display.Bitmap;

class UserInterface extends Sprite
{
	private var _parent:Game;


	public function new( parent:Game ):Void
	{
		super();
		this._parent = parent;
	}

	public function addButton( button:Entity, x:Int, y:Int ):Void
	{
		var data = new Bitmap( button.getComponent( "graphics" ).getUrl( 0 ) );
		addChild( data );
		data.x = x;
		data.y = y;
	}

	public function addWindow():Void
	{

	}
}