package;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _activeScene:Scene;

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
		this._addScene( scene );
		this._parent.getSystem( "graphics" ).addGraphicsForScene( scene );
		this._parent.getSystem( "entity" ).createEntity( "button", "startGame" );
		//TODO: Create buttons, add buttons, create graphics dor buttons.
		return scene;
	}



	public function new( parent:Game ):Void
	{
		this._parent = parent;
		this._scenesArray = [];
	}

	public function createScene( sceneName:String ):Scene
	{
		var id = _createId();
		switch( sceneName )
		{
			case "startScene": return this._createStartScene( sceneName, id );
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