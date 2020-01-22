package;

import openfl.display.Sprite;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	
	public function new():Void
	{

	}

	public function init( parent:Game, sprite:Sprite ):String
	{	
		this._parent = parent;
		if( parent == null )
			return 'Error in SceneSystem.init. Parent is "$parent"';

		this._scenesSprite = sprite;
		if( sprite == null )
			return 'Error in SceneSystem.init. Sprite is "$sprite"';

		this._scenesArray = new Array<Scene>();
		this._activeScene = null;
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

	public function addScene( scene:Scene ):String
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check != null )
			return 'Error in SceneSystem.addScene. Scene with name "$name" already in.';

		this._scenesArray.push( scene );
		return null;
	}

	public function removeScene( scene:Scene ):Array<Dynamic>
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check == null )
			return [ null, 'Error in SceneSystem.addScene. Scene with name "$name" does not exist.' ];

		var sceneToReturn:Scene = this._scenesArray[ check ];
		this._scenesArray.splice( check, 1 );
		return [ sceneToReturn, null ];
	}

	public function switchSceneTo( scene:Scene ):Void // this only hide active scene.
	{
		if( this._activeScene != null )
			this.hideScene( this._activeScene );

		this._activeScene = scene;
		this.showScene( scene );
	}

	public function changeSceneTo( scene:Scene ):Void //full undraw active scene, and draw new scene;
	{

	}

	public function drawUiForScene( scene:Scene ):Void
	{
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		var ui:UserInterface = this._parent.getSystem( "ui" );
		for( i in 0...windows.length )
		{
			var err:String = ui.addUiObject( windows[ i ] );
			if( err != null )
				throw 'Error in SceneSystem.drawUiForScene. $err';
		}
	}

	public function undrawUiForScene( scene:Scene ):Void
	{
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		var ui:UserInterface = this._parent.getSystem( "ui" );
		for( i in 0...windows.length )
		{
			var err:String = ui.removeUiObject( windows[ i ] );
			if( err != null )
				throw 'Error in SceneSystem.undrawUiForScene. $err';
		}
	}

	public function showScene( scene:Scene ):Void
	{
		scene.get( "sprite" ).visible = true;
	}

	public function hideScene( scene:Scene ):Void
	{
		scene.get( "sprite" ).visible = false;
	}

	public function drawScene( scene:Scene ):String
	{
		var sceneSprite:Sprite = scene.get( "sprite" );

		return 'ok';
	}

	public function undrawScene( scene:Scene ):String
	{
		return 'ok';
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

	//PRIVATE

	private function _drawStartingScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.addChild( sprite );
		this.drawUiForScene( scene );
	}

	private function _checkSceneIfExist( scene:Scene ):Int
	{
		for( i in 0...this._scenesArray.length )
		{
			var sceneId = this._scenesArray[ i ].get( "id" );
			if( sceneId == id )
				return i;
		}
		return null;
	}
}