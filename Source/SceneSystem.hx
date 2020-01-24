package;

import openfl.display.Sprite;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;
	private var _inited:Bool;
	private var _postInited:Bool;

	
	public function new( parent:Game, sprite:Sprite ):Void
	{
		this._inited = false;
		this._postInited = false;
		this._activeScene = null;
		this._scenesArray = new Array<Scene>();
		this._scenesSprite = sprite;
		this._parent = parent;
	}

	public function init():String
	{	
		if( this._parent == null )
			return 'Error in SceneSystem.init. Parent is "$this._parent"';

		if( this._scenesSprite == null )
			return 'Error in SceneSystem.init. Sprite is "$this._scenesSprite"';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		for( i in 0...this._scenesArray.length )
		{
			this._scenesArray[ i ].update( time );
		}
	}

	public function addScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check != null )
			throw 'Error in SceneSystem.addScene. Scene with name "$name" already in.';

		this._scenesArray.push( scene );
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

	public function fastSwitchSceneTo( scene:Scene ):Void // fast switch between scenes, hide active and show scene; Использовать для перемещения между сценой города и выбором данжа.
	{
		if( this._activeScene != null )
			this.hideScene( this._activeScene );

		this._activeScene = scene;
		this.showScene( scene );
	}

	public function changeSceneTo( scene:Scene ):Void //full undraw active scene, and draw new scene;
	{
		//TODO: First we must draw loader scene;

		if( this._activeScene != null )
			this.undrawScene( this._activeScene );

		this._activeScene = scene;
		if( scene.get( "drawed" ) == "drawed" )
			this.showScene( scene ); // если true, значит сцена уже отрисована была до этого, но скрыта. по этому показываем ее.
		else
			this.drawScene( scene );

	}

	public function drawUiForScene( scene:Scene ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		var sceneId:Int = scene.get( "id" );
		if( windows == null )
			throw 'Error in SceneSystem.drawUiForScene. Scene does not have any widnows.';
		
		for( i in 0...windows.length )
		{
			var window:Window = windows[ i ];
			ui.addUiObject( windows[ i ], sceneId );
		}

	}

	public function undrawUiForScene( scene:Scene ):Void
	{
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		var ui:UserInterface = this._parent.getSystem( "ui" );

		var sceneId:Int = scene.get( "id" );
		for( i in 0...windows.length )
		{
			var window:Window = windows[ i ];
			ui.removeUiObject( windows[ i ], sceneId );
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

	public function drawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		switch( name )
		{
			case "startScene": this._drawStartScene( scene );
			case "cityScene": this._drawCityScene( scene );
			default: throw 'Error in SceneSystem.drawScene. Scene with name "$name" can not to be draw, no function for it.';
		}
	}

	public function undrawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		switch( name )
		{
			case "startScene": this._undrawStartScene( scene );
			case "cityScene": this._undrawCityScene( scene );
			default: throw 'Error in SceneSystem.drawScene. Scene with name "$name" can not to be draw, no function for it.';
		}
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

	private function _drawStartScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.addChild( sprite );
		this.drawUiForScene( scene );
		scene.changeDrawStatus( "drawed" );
	}

	private function _undrawStartScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.removeChild( sprite );
		this.undrawUiForScene( scene );
		scene.changeDrawStatus( "undrawed" );
	}

	private function _drawCityScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.addChild( sprite );
		this..drawUiForScene( scene );
		scene.changeDrawStatus( "drawed" );
	}

	private function _undrawCityScene( scene:Scene ):Void
	{

	}

	private function _checkSceneIfExist( scene:Scene ):Int
	{
		var id:Int = scene.get( "id" );
		for( i in 0...this._scenesArray.length )
		{
			if( this._scenesArray[ i ].get( "id" ) == id )
				return i;
		}
		return null;
	}
}