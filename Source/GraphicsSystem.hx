package;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;


class GraphicsSystem
{
	private var _parent:Game;


	private function _drawStartScene( scene:Scene ):Void
	{
		//add bacground on scene;
		if( scene.getGraphicsInstance() == null )
		{
			var backgroundURL = scene.getBackgroundImageURL();
			var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
			scene.setGraphicsInstance( bitmap );
			scene.addChild( bitmap );
		}
		else
		{
			scene.addChild( scene.getGraphicsInstance() );
		}

		//add UI objects to ui;

		var sortFunction = function( a, b )
		{
			if( a.getComponent( "graphics" ).getQueue() > b.getComponent( "graphics" ).getQueue() )
				return 1;
			else if( a.getComponent( "graphics" ).getQueue() < b.getComponent( "graphics" ).getQueue() )
				return -1;
			else
				return 0;
		}

		var sceneUiEntities:Dynamic = scene.getUiEntities();
		var windowsContainer:Array<Entity> = sceneUiEntities.windows;
		var buttonsContainer:Array<Entity> = sceneUiEntities.buttons;
		// sort this to add childs into right queue;
		windowsContainer.sort( sortFunction );
		buttonsContainer.sort( sortFunction );

		//first draw windows;
		for( i in 0...windowsContainer.length )
		{
			var window = windowsContainer[ i ];
			this._parent.getSystem( "ui" ).addWindow( window );
		}

		//second draw buttons;
		for( j in 0...buttonsContainer.length )
		{
			var button = buttonsContainer[ j ];
			this._parent.getSystem( "ui" ).addButton( button );
		}
		
		this._parent.getMainSprite().addChild( scene );
	}

	private function _undrawStartScene( scene:Scene ):Void
	{
		// when we goto CityScene - we no need this scene on this game.
		var sceneUiEntities:Dynamic = scene.getUiEntities();
		var windowsContainer:Array<Entity> = sceneUiEntities.windows;
		var buttonsContainer:Array<Entity> = sceneUiEntities.buttons;

		for( i in 0...windowsContainer.length )
		{
			var window = windowsContainer[ i ];
			this._parent.getSystem( "ui" ).removeUiObject( window );
		}

		//second draw buttons;
		for( j in 0...buttonsContainer.length )
		{
			var button = buttonsContainer[ j ];
			this._parent.getSystem( "ui" ).removeUiObject( button );
		}

		this._parent.getMainSprite().removeChild( scene );
	}

	private function _drawCityScene( scene:Scene ):Void
	{

	}

	private function _undrawCityScene( scene:Scene ):Void
	{

	}
	

	public function new( parent:Game ):Void
	{
		_parent = parent;
	}

	public function drawScene( scene:Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._drawStartScene( scene );
			case "cityScene": this._drawCityScene( scene );
			default: trace( "Can't draw scene with name: " + sceneName + "." );
		}
	}

	public function undrawScene( scene: Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._undrawStartScene( scene );
			case "cityScene": this._undrawCityScene( scene );
			default: trace( "Can't sraw scene with name: " + sceneName + "." );
		}
	}

	public function hideScene( scene:Scene ):Void
	{
		scene.visible = false;
	}

	public function showScene( scene:Scene ):Void
	{
		scene.visible = true;
	}
}