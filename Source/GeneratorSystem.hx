package;

import Player;
import Window;
import Button;
import Hero;
import Building;
import Scene;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;


class GeneratorSystem
{
	private var _nextId:Int;
	private var _parent:Game;

	private var _itemDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _windowDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buttonDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _heroDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buildingDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _sceneDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _playerDeploy:Map<Int, Dynamic>;

	//private var _heroNames:Dynamic; // { "m": [ "Alex"], "w": [ "Stella" ]};
	//private var _heroSurnames:Dynamic; // [ "Goldrich", "Duckman" ];


	public inline function new( config:Dynamic ):Void
	{
		this._nextId = 0;
		this._parent = config.parent;
		this._sceneDeploy = config.sceneDeploy;
		this._buildingDeploy = config.buildingDeploy;
		this._windowDeploy = config.windowDeploy;
		this._buttonDeploy = config.buttonDeploy;
		this._heroDeploy = config.heroDeploy;
		this._itemDeploy = config.itemDeploy;
		this._playerDeploy = config.playerDeploy;
	}

	public function init():String
	{		
		if( this._parent == null )
			return  'Error in GeneratorSystem.init. Parent is:"$this._parent"';
		
		if( this._sceneDeploy == null || !this._sceneDeploy.exists( 1000 ) )
			return 'Error in GeneratorSystem.init. Scene deploy is not valid';
		
		
		if( this._buildingDeploy == null )
			return 'Error in GeneratorSystem.init. Building deploy is not valid';
		
		
		if( this._windowDeploy == null )
			return 'Error in GeneratorSystem.init. Window deploy is not valid';
		
		
		if( this._buttonDeploy == null )
			return 'Error in GeneratorSystem.init. Button deploy is not valid';
		
		
		if( this._heroDeploy == null )
			return 'Error in GeneratorSystem.init. Hero deploy is not valid';
		
		
		if( this._itemDeploy == null )
			return 'Error in GeneratorSystem.init. Item deploy is not valid';
		
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function createPlayer( deployId:Int, name:String ):Array<Dynamic>
	{
		var config:Dynamic = this._playerDeploy.get( deployId );
		if( config == null )
			return [ null, 'Error in GeneratorSystem.createPlayer. Deploy ID: "$deployId" does not exist in PlayerDeploy data' ];

		var id:ID = this._createId();
		var configForPlayer:PlayerConfig =
		{
			ID: id,
			Name: name,
			DeployID: DeployID( config.deployId ),
			MaxHeroSlots: config.maxHeroSlots,
			MoneyAmount: { Amount: config.moneyAmount }
		};

		var player:Player = new Player( configForPlayer );
		var err:String = player.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.createPlayer. $err' ];

		return [ player, null ];
	}

	public function generateHero( heroType:String, heroRarity:String ):Array<Dynamic>
	{
		return [];
	}

	public function createHero():Array<Dynamic>
	{
		return [];
	}

	public function createBuilding( deployId:Int ):Array<Dynamic>
	{
		var config = this._buildingDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.createBuilding. Deploy ID: '" + deployId + "' doesn't exist in BuildingDeploy data" ];

		var id:ID = this._createId();
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var buildingConfig:BuildingConfig =
		{
			ID: id,
			DeployID: DeployID( config.deployId ),
			Name: config.name,
			GraphicsSprite: sprite,
			UpgradeLevel: config.upgradeLevel,
			NextUpgradeId: config.nextUpgradeId,
			CanUpgradeLevel: config.canUpgradeLevel,
			UpgradePrice: { Amount: config.moneyAmount },
			HeroStorageSlotsMax: config.heroStorageSlotsMax

		};
		var building:Building = new Building( buildingConfig );
		var err:String = building.init();
		if( err !=null )
			return [ null, 'Error in GeneratorSystem.createBuilding. $err' ];

		
		return [ building, null ];
	}

	public function generateItem( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function createScene( deployId:Int ):Array<Dynamic>
	{
		var config = this._sceneDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.createScene. Deploy ID: '" + deployId + "' doesn't exist in SceneDeploy data" ];

		var id:ID = this._createId();
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

	

	public function generateHeroesForBuildingRecruits( building ):Void
	{
		var slots:Int = building.get( "maxSlots" );
		var upgradeLevel:Int = building.get( "upgradeLevel" );
		var heroRares:Array<String>;
		switch( upgradeLevel )
		{
			case 1: heroRares = [ "uncommon" ];
			case 2: heroRares = [ "uncommon", "common"  ];
			case 3: heroRares = [ "uncommon", "common", "rare" ];
			case 4: heroRares = [ "uncommon", "common", "rare", "legendary" ];
			default: throw 'Error in GeneratorSystem.generateHeroesForBuildingRecruits. UpgradeLevel for building "Recruits" is wrong!';
		}
		for( i in 0...slots )
		{
			var index:Int = Math.floor( Math.random() * heroRares.length );
			var heroRarity:String = heroRares[ index ];
			var createHero:Array<Dynamic> = this.generateHero( "random", heroRarity );
			var err:String = createHero[ 1 ];
			var hero:Hero = createHero[ 0 ];
			if( err != null )
				throw 'Error in GeneratorSystem.generateHeroesForBuildingRecruits. $err';

			building.addChild( hero ); // Никакой проверки.
		}
	}





	// PRIVATE


	
	

/*
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
		var scene:Scene = new Scene( this, id, "chooseDungeonScene" );
		var entitySystem:EntitySystem = this._parent.getSystem( "entity" );

		var config:Dynamic = Reflect.getProperty( this._config, "chooseDungeonScene" );
		if( config == null )
			trace( "Error in SceneSystem._screateCityScene, scene not found in config container." );

		scene.setBackgroundImageURL( config.backgroundImageURL );

		var windowsArray:Array<String> = config.window;
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

		//TODO: CONFIG;
		this._addScene( scene );
		return scene;
	}

*/
}