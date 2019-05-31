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

	public function addGraphicsForScene( scene:Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._addGgraphicsForStartScene( scene );
			default: trace( "Error in GraphicsSystem.addGraphicsForScene, scene name: " + sceneName + " not available or scene not defined." );
		}
	}

	public function drawScene( scene:Scene ):Void
	{

	}
}