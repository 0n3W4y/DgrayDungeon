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

		var entitySystem = this._parent.getSystem( "entity" );
		for( key in Reflect.fields( value ) )
		{
			if( key == "backgroundImageURL" )
				continue;

			var listEntities = Reflect.getProperty( value, key );
			this._parent.getSystem( "entity" ).createEntitiesForScene(  scene, key, listEntities );
		};

		if( sceneName == "cityScene" )
		{
			var building:Entity = null;
			var buildingsArray:Array<Dynamic> = scene.getEntities( "object" ).buildings;
			for( i in 0...buildingsArray.length )
			{
				var obj:Entity = buildingsArray[ i ];
				if( obj.get( "name" ) == "recruits" )
				{
					building = obj;
					break;
				}
			}
			var slots = building.getComponent( "inventory" ).getCurrentSlots();

			//fill hero list with names of hero in config file ( data.json from entitysystem );
			var heroList:Array<String> = this._parent.getSystem( "entity" ).getHeroList();
			

			for( i in 0...slots )
			{
				var randomHeroNum = Math.floor( Math.random()*( heroList.length ) ); // heroList.length - 1 + 1 ;
				var heroName = heroList[ randomHeroNum ];
				var rarityNum = Math.floor( Math.random()*100 ); // 0 - 65%, 1 - 20%, 2 - 10%, 3 - 5%
				var rarity:String = "common"; //0;
				if( rarityNum < 10 )
					rarity = "rare"; //2
				else if( rarityNum >= 75 && rarityNum < 95 )
					rarity = "uncommon"; //1;
				else if( rarityNum >= 95 )
					rarity = "legendary"; //3
				var params = { "rarity": rarity };
				var hero = this._parent.getSystem( "entity" ).createEntity( "hero", heroName, params );

				// do this without check, because we have 1-st start and we have 4 slots at all.
				building.getComponent( "inventory" ).setItemInSlot( hero, null ); 		
			}
			//trace ( building.getComponent( "inventory" ).getInventory() );
		}
				
		this._addScene( scene );
		return scene;
	}

	private function _createDungeonChooseScene( sceneName:String ):Scene
	{
		var id = this._createId();
		var scene = new Scene( this, id, sceneName );
		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}


	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		for( key in Reflect.fields( this._scenesArray ) )
		{
			Reflect.getProperty( this._scenesArray, key ).update( time ); // update all scenes;
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
			case "startScene", "cityScene", "chooseDungeonScene": return this._createStartScene( sceneName );
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