package;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _activeScene:Scene;
	private var _config:Dynamic;

	private var _nextId:Int = 0;

	private function _createId():String
	{
		var id = this._nextId + "";
		this._nextId++;
		return id;
	}

	private function _addScene( scene:Scene ):Void
	{
		this._scenesArray.push( scene );
	}

	private function _createStartScene( sceneName:String ):Scene //startgame screen;
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		var value = null;

		for( field in Reflect.fields( this._config ) )
		{
			if( field == sceneName )
			{
				value = Reflect.getProperty( this._config, field );
				break;	
			}
		}

		if( value == null )
			trace( "Error in SceneSystem._screateStartScene, scene name: " + sceneName + " not found in config container." );
		
		scene.setBackgroundImageURL( value.backgroundImageURL );
		
		for( key in Reflect.fields( value.windows ) )
		{
			var configWindow = Reflect.getProperty( value.windows, key );
			var window = this._parent.getSystem( "entity" ).createEntity( "window", key, configWindow );
			scene.addEntity( window );
		}

		for( field in Reflect.fields( value.buttons ) )
		{
			var configButton = Reflect.getProperty( value.buttons, field );
			var button = this._parent.getSystem( "entity" ).createEntity( "button", field, configButton );
			scene.addEntity( button );
		}
		this._addScene( scene );
		return scene;
	}

	private function _createCityScene( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//CONFIG;
		this._addScene( scene );
		return scene;
	}

	private function _createDungeonChooseScene( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//CONFIG;
		this._addScene( scene );
		return scene;
	}


	public function update( time:Float ):Void
	{
		for( key in Reflect.fields( this._scenesArray ) )
		{
			Reflect.getProperty( this._scenesArray, key ).update( time );
		}
	}

	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._scenesArray = new Array<Scene>();
		this._config = params;
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
			this._activeScene.unDraw();
			this._activeScene = null;
			
		}

		this._activeScene = scene;
		this._activeScene.draw();
	}

	public function getParent():Game
	{
		return this._parent;
	}
}