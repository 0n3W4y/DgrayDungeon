package;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _activeScene:Scene;
	private var _config:Dynamic;

	private var _nextId:Int = 0;

	private function _createId():Int
	{
		var id = _nextId;
		_nextId++;
		return id;
	}

	private function _addScene( scene:Scene ):Void
	{
		this._scenesArray.push( scene );
	}

	private function _createStartScene( sceneName:String, id:Int ):Scene //startgame screen;
	{
		var scene = new Scene( this, id, sceneName );
		var value = null;
		for( field in Reflect.fields( this._config) )
		{
			if( field == sceneName )
				value = Reflect.getProperty( this._config, field );
			else
				trace( "Error in SceneSystem._screateStartScene, scenen name: " + sceneName + " not found in config containg." );
		}
		var config = value;
		scene.setBackgroundImageURL( config.backgroundImageURL );

		for( key in Reflect.fields( this._config.buttons ) )
		{
			var configButton = Reflect.getProperty( this._config.buttons, key );
			var button = this._parent.getSystem( "entity" ).createEntity( "button", key, configButton );
			scene.addEntity( "button", button );
		}

		this._addScene( scene );
		return scene;
	}

	private function _createCityScene( sceneName:String, id:Int ):Scene
	{
		var scene = new Scene( this, id, sceneName );
		//CONFIG;
		this._addScene( scene );
		return scene;
	}

	private function _createDungeonChooseScene( sceneName:String, id:Int ):Scene
	{
		var scene = new Scene( this, id, sceneName );
		//CONFIG;
		this._addScene( scene );
		return scene;
	}



	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._scenesArray = [];
	}

	public function createScene( sceneName:String ):Scene
	{
		switch( sceneName )
		{
			case "startScene": return this._createStartScene( sceneName );
			case "cityScene": return this._createCityScene( sceneName );
			case "dungeonChooseScene": return this._createDungeonChooseScene( sceneName );
			default: trace( "Error in SceneSystem.createScene, scene name can't be: " + sceneName + "." );
		}
		return null;
	}

	public function removeScene( scene:Scene ):Void
	{

	}

	public function doActiveScene( scene:Scene ):Void
	{
		if( this._activeScene != null )
		{
			this._parent.getMainSprite().removeChild( this._activeScene );
			this._activeScene.unDraw();
			
		}

		this._activeScene = scene;
		this._parent.getMainSprite().addChild( this._activeScene );
		this._activeScene.draw();
	}

	public function getParent():Game
	{
		return this._parent;
	}
}