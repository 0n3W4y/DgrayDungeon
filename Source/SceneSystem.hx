package;

import openfl.display.Sprite;

import Scene;

typedef SceneSystemConfig = 
{
	var Parent:Game;
	var GraphicsSprite:Sprite;
}

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;

	
	public function new( config.SceneSystemConfig ):Void
	{
		this._scenesSprite = config.GraphicsSprite;
		this._parent = config.Parent;
	}

	public function init():String
	{	
		if( this._parent == null )
			return 'Error in SceneSystem.init. Parent is "$this._parent"';

		if( this._scenesSprite == null )
			return 'Error in SceneSystem.init. Sprite is "$this._scenesSprite"';
		this._activeScene = null;
		this._scenesArray = new Array<Scene>();
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

	public function fastSwitchSceneTo( scene:Scene ):Void // fast switch between scenes, hide active and show scene; 
	{													//Использовать для перемещения между сценой города и выбором данжа.
		if( this._activeScene != null )
			this.hideScene( this._activeScene );

		this._activeScene = scene;
		this.showScene( scene );
	}

	public function changeSceneTo( scene:Scene ):Void //full undraw active scene, and draw new scene;
	{
		//TODO: Loader;

		if( this._activeScene != null )
			this.undrawScene( this._activeScene );

		this._activeScene = scene;
		this.drawScene( scene );
	}

	public function drawUiForScene( scene:Scene ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		var sceneId:GeneratorSystem.ID = scene.get( "id" );
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

		var sceneId:GeneratorSystem.ID = scene.get( "id" );
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

	public function prepareScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		switch( name )
		{
			case "startScene": this._prepareStartScene( scene );
			case "cityScene": this._prepareCityScene( scene );
			default: throw 'Error in SceneSystem.drawScene. Scene with name "$name" can not to be draw, no function for it.';
		}
	}

	public function prepareUiForScene( scene:Scene ):Void
	{

	}

	public function drawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var prepared:String = scene.get( "prepared" );
		if( prepared == "unprepared" )
			throw 'Error in SceneSystem.drawScene. Scene with name: "$name" is "$prepared"';

		this._scenesSprite.addChild( scene.get( "sprite" ) );
		this._parent.getSystem( "ui" ).show();
	}

	public function undrawScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.removeChild( sprite );
		this._parent.getSystem( "ui" ).hide();
		this.undrawUiForScene( scene );
		scene.changePrepareStatus( "unprepared" );
	}

	public function drawLoader():Void
	{

	}

	public function undrawLoader():Void
	{

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

	public function createScene( dpeloyId:SceneDeployID ):Array<Dynamic>
	{
		var config = this._sceneDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.createScene. Deploy ID: '" + deployId + "' doesn't exist in SceneDeploy data" ];

		var id:Game.ID = this._createId();
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForScene:SceneConfig =
		{
			ID: id,
			Name: config.name,
			DeployID: DeployID( config.deployId ),
			GraphicsSprite: sprite
		};
		var scene = new Scene( configForScene );
		var err:String = scene.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.createScene. $err' ];

		this._scenesArray.push( scene );
	}

	public function createScene( deployId:Int ):Array<Dynamic>
	{
		// окна не будут добавлены на сцену, так как они являются частью Интерфейса пользователя.
		var configWindow:Array<Int> = config.window;
		if( configWindow != null ) // Внутри Window есть чайлды в виде button. создаются в функции создании окна.
		{
			for( i in 0...configWindow.length )
			{
				var windowDeployId:Int = configWindow[ i ];
				var createWindow:Array<Dynamic> = this.createWindow( windowDeployId );
				var window:Window = createWindow[ 0 ];
				var windowError:String = createWindow[ 1 ];
				if( windowError != null )
					return [ null, 'Error in GeneratorSystem.createScene. $windowError' ];

				scene.addChild( window );
			}
		}

		var configBuilding:Array<Int> = config.building;
		if( configBuilding != null )
		{
			for( j in 0...configBuilding.length )
			{
				var buildingDeployId:Int = configBuilding[ j ];
				var createBuilding:Array<Dynamic> = this.createBuilding( buildingDeployId );
				var building:Building = createBuilding[ 0 ];
				var buildingError:String = createBuilding[ 1 ];
				if( buildingError != null )
					return [ null, 'Error in GeneratorSystem.createScene. $buildingError' ];

				scene.addChild( building );
			}
		}

		return [ scene, null ];
	}

	//PRIVATE

	private function _prepareStartScene( scene:Scene ):Void
	{
		this.drawUiForScene( scene );
		scene.changePrepareStatus( "prepared" );
	}

	private function _prepareCityScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		var buildingsArray:Array<Building> = scene.getChilds( "building" );
		for( i in 0...buildingsArray.length )
		{
			var building:Building = buildingsArray[ i ];
			var buildingSprite:Sprite = building.get( "sprite" );
			sprite.addChild( buildingSprite );
			var name:String = building.get( "name" );
			switch( name )
			{
				case "recruit":
				{
					//DO heroes in slots + start timer to rebuild heroes in it;
					var slots:Int = building.get( "maxSlots" );

				} 
				default : throw 'Error in SceneSystem._prepareCityScene. Building with name: "$name" no action assigned.';
			}
		}


		this._scenesSprite.addChild( sprite );
		this.drawUiForScene( scene );
		scene.changePrepareStatus( "prepared" );
	}

	private function _checkSceneIfExist( scene:Scene ):Int
	{
		for( i in 0...this._scenesArray.length )
		{
			if( scene.get( "id" ).match( this._scenesArray[ i ].get( "id" ) ) )
				return i;
		}
		return null;
	}
}