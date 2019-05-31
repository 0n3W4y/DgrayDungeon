package;

import openfl.display.Bitmap;
import openfl.Assets;

class GraphicsSystem
{
	private var _parent:Game;
	

	public function new( parent:Game ):Void
	{
		_parent = parent; 
	}

	public function drawScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImaheURL();
		var backgroundBitmapData = new Bitmap( backgroundURL );
		scene.addChild( backgroundBitmapData );
		this._parent.getMainSprite().addChild( scene );
	}

	public function undrawScene( scene: Scene ):Void
	{

	}
}