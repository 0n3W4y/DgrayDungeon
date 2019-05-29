package;

import openfl.display.Bitmap;
import openfl.Assets;

class GraphicsSystem
{
	private var _parent:Game;

	private function _addGgraphicsForStartScene( scene:Scene ):Void
	{
		//TODO: Url from data;
		var bitmapData = Assets.getBitmapData( "assets/background_game.png" );
		var bitmap = new Bitmap( bitmapData );
		scene.setBackgoundGraphics( bitmap );
	}

	public function new( parent:Game ):Void
	{
		_parent = parent; 
	}

	public function addGraphicsForScene( scene:Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._addGgraphicsForStartScene( scene );
			default: trace( "Error in GraphicsSystem.addGraphicsForScene, scene name: " + sceneName + " not available or scene not defined." );
		}
	}
}