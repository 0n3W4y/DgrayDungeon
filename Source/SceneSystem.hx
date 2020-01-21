package;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _activeScene:Scene;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;


	public function addScene( scene:Scene ):Void
	{
		if( !this.isSceneAlreadyCreated( scene.get( "id" ) ) )
			this._scenesArray.push( scene );
	}

	
	public function new():Void
	{

	}

	public function init():String
	{
		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in SceneSystem.postInit. Init is FALSE";

		this._postInited = true;
		return "ok";
	}

	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		for( i in 0...this._scenesArray.length )
		{
			this._scenesArray[ i ].update( time );
		}
	}

	public function removeScene( scene:Scene ):Void
	{
		var sceneId = scene.get( "id" );
		for( i in 0...this._scenesArray.length )
		{
			if( this._scenesArray[ i ].get( "id" )== sceneId )
			{
				this._scenesArray.splice( i, 1 );
				break;
			}
		}
	}

	public function switchSceneTo( scene:Scene ):Scene // this only hide active scene.
	{
		return null;	
	}

	public function getParent():Game
	{
		return this._parent;
	}

	public function getActiveScene():Scene
	{
		return this._activeScene;
	}

	public function getScene( name:String ):Scene
	{
		for( i in 0...this._scenesArray.length )
		{
			var sceneName = this._scenesArray[ i ].get( "name" );
			if( sceneName == name )
				return this._scenesArray[ i ];
		}
		return null;
	}

	public function isSceneAlreadyCreated( id:String ):Bool
	{
		for( i in 0...this._scenesArray.length )
		{
			var sceneId = this._scenesArray[ i ].get( "id" );
			if( sceneId == id )
				return true;
		}
		return false;
	}
}