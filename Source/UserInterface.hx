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

	public function addButton( button:Entity ):Void
	{
		var data = new Bitmap( button.getComponent( "graphics" ).getUrl( 0 ) );
		var sprite = new Sprite();
		sprite.addChild( data );

		sprite.x = button.getComponent( "graphics" ).getCoordinates().x;
		sprite.y = button.getComponent( "graphics" ).getCoordinates().y;
		this._parent.getSystem( "event" ).addEventListener( sprite, "MOUSE_DOWN" );
		addChild( sprite );
		

	}

	public function addWindow():Void
	{

	}
}