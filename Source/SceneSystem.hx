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

	private function _createStartScene():Scene //startgame screen;
	{
		var entitySystem:EntitySystem = this._parent.getSystem( "entity" );
		var id = this._createId();
		var scene = new Scene( this, id, "startScene" );

		var config:Dynamic = Reflect.getProperty( this._config, "startScene" );
		if( config == null )
			trace( "Error in SceneSystem._screateStartScene, scene 'startScene' not found in config container." );
		
		scene.setBackgroundImageURL( config.backgroundImageURL );

		//create window
		var windowsArray:Array<String> =  config.window;
		for( i in 0...windowsArray.length )
		{
			var window:Entity = entitySystem.createEntity( "window", windowsArray[ i ], null );
			entitySystem.addEntityToScene( window, scene );
		}

		var buttonArray:Array<String> = config.button;

		for( j in 0...buttonArray.length )
		{
			var button:Entity = entitySystem.createEntity( "button", buttonArray[ j ], null );
			entitySystem.addEntityToScene( button, scene );
		}
		
		this._addScene( scene );
		return scene;
	}

	private function _createCityScene():Scene
	{
		var entitySystem:EntitySystem = this._parent.getSystem( "entity" );
		var id = this._createId();
		var scene = new Scene( this, id, "cityScene" );
		var recruitBuilding:Entity = null; // building with name "recruit"

		var config:Dynamic = Reflect.getProperty( this._config, "cityScene" );
		if( config == null )
			trace( "Error in SceneSystem._screateCityScene, scene not found in config container." );

		scene.setBackgroundImageURL( config.backgroundImageURL );
		
		// create all buildings.
		var buildingsArray:Array<Dynamic> = config.building;
		for( k in 0...buildingsArray.length )
		{
			var building:Entity = entitySystem.createEntity( "building", buildingsArray[ k ], null );
			entitySystem.addEntityToScene( building, scene );
			switch( buildingsArray[ k ] )
			{
				case "recruits":
				{
					recruitBuilding = building;
					var inventoryBuilding:Dynamic = building.getComponent( "inventory" ); //component inventory;
					var slots = inventoryBuilding.getCurrentSlots();

					for( i in 0...slots )
					{
						entitySystem.createHeroRecruitWithButton( scene, building );
					}
					//TODO: set timer to next change heroes in recruit building;
				}
				case "storage":
				{
					trace( "Storage works" );
				}
				case "inn":
				{
					
				}
			}
		}

		var windowsArray:Array<String> = config.window;
		//var windowConfig:Dynamic = this._parent.getSystem( "entity" ).getConfig().window;
		for( i in 0...windowsArray.length )
		{
			var window:Entity = entitySystem.createEntity( "window", windowsArray[ i ], null );
			entitySystem.addEntityToScene( window, scene );
		}

		var buttonArray:Array<String> = config.button;
		for( j in 0...buttonArray.length )
		{
			var newButton:String = buttonArray[ j ];
			if( newButton == "recruitWindowHeroButton" )
			{
				var slots:Int = recruitBuilding.getComponent( "inventory" ).getMaxSlots(); //choose max slots for max buttons in recruit window ( building );
				for( i in 0...slots )
				{
					var heroButton:Entity = entitySystem.createEntity( "button", newButton, null );
					entitySystem.addEntityToScene( heroButton, scene );
				}
			}
			else
			{
				var button:Entity = entitySystem.createEntity( "button", newButton, null );
				entitySystem.addEntityToScene( button, scene );
			}			
		}	
		//trace ( building.getComponent( "inventory" ).getInventory() );
		this._addScene( scene );
		return scene;
	}

	private function _createChooseDungeonScene():Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, "schooSeDungeonScene" );
		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}

	private function _createDungeonEasy( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}

	private function _createdungeonMedium( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}

	private function _createDungeonHard( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}

	private function _createDungeonNightmare( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}


	

	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._scenesArray = new Array<Scene>();
		this._config = params;
	}

	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		for( key in Reflect.fields( this._scenesArray ) )
		{
			Reflect.getProperty( this._scenesArray, key ).update( time ); // update all scenes;
		}
	}

	public function createScene( sceneName:String ):Scene
	{
		switch( sceneName )
		{
			case "startScene": return this._createStartScene();
			case "cityScene": return this._createCityScene();
			case "chooseDungeonScene": return this._createChooseDungeonScene();
			case "dungeonEasy" : return this._createDungeonEasy( sceneName );
			case "dungeonMedium": return this._createdungeonMedium( sceneName );
			case "dungeonHard": return this._createDungeonHard( sceneName );
			case "dungeonNightmare": return this._createDungeonNightmare( sceneName );
			default: trace( "Error in SceneSystem.createScene, scene name can't be: " + sceneName + "." );
		}
		return null;
	}

	public function removeScene( scene:Scene ):Void
	{
		var sceneId = scene.getId();
		for( i in 0...this._scenesArray.length )
		{
			if( this._scenesArray[ i ].getId() == sceneId )
			{
				this._scenesArray.splice( i, 1 );
				break;
			}
		}
	}

	public function doActiveScene( scene:Scene ):Void // kill active scene;
	{
		if( this._activeScene != null )
		{
			this._activeScene.unDraw(); //remove scene;
			this.removeScene( this._activeScene );
			this._activeScene = null;
			
		}
		this._activeScene = scene;
		this._activeScene.draw();
	}

	public function switchScene( scene:Scene ):Void // this only hide active scene.
	{
		if( this._activeScene != null )
		{
			this._activeScene.hide(); //hide scene;
			this._activeScene = null;
		}

		this._activeScene = scene;
		this._activeScene.show();
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
			var sceneName = this._scenesArray[ i ].getName();
			if( sceneName == name )
				return this._scenesArray[ i ];
		}
		return null;
	}
}