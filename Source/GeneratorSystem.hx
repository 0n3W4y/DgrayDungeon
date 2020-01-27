package;

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


	public function new( config:Dynamic ):Void
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

	public function generatePlayer( deployId:Int, name:String ):Array<Dynamic>
	{
		var config:Dynamic = this._playerDeploy.get( deployId );
		if( config == null )
			return [ null, 'Error in GeneratorSystem.generatePlayer. Deploy ID: "$deployId" does not exist in PlayerDeploy data' ];

		var id:Int = this._createId();
		var configForPlayer:Dynamic = 
		{
			"id": id,
			"name": name,
			"deployId": deployId,
			"maxHeroSlots": config.maxHeroSlots,
			"moneyAmount": config.moneyAmount
		}

		var player:Player = new Player( configForPlayer );
		var err:String = player.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.generatePlayer. $err' ];

		return [ player, null ];
	}

	public function generateHero( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateBuilding( deployId:Int ):Array<Dynamic>
	{
		var config = this._buildingDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.generateBuilding. Deploy ID: '" + deployId + "' doesn't exist in BuildingDeploy data" ];

		var id = this._createId();
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var buildingConfig:Dynamic = 
		{
			"id": id,
			"name": config.name,
			"deployId": config.deployId,
			"sprite": sprite,
			"upgradeLevel": config.upgradeLevel,
			"nextUpgradeId": config.nextUpgradeId,
			"canUpgradeLevel": config.canUpgradeLevel,
			"upgradePriceMoney": config.upgradePriceMoney,
			"containerSlots": config.containerSlots,
			"containerSlotsMax": config.containerSlotsMax
		};

		var building:Building = new Building( buildingConfig );
		var err:String = building.init();
		if( err !=null )
			return [ null, 'Error in GeneratorSystem.generateBuilding. $err' ];

		
		return [ building, null ];
	}

	public function generateItem( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateScene( deployId:Int ):Array<Dynamic>
	{
		var config = this._sceneDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.generateScene. Deploy ID: '" + deployId + "' doesn't exist in SceneDeploy data" ];

		var id = this._createId();
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForScene:Dynamic = 
		{
			"id": id,
			"name": config.name,
			"deployId": deployId,
			"sprite": sprite
		}
		var scene = new Scene( configForScene );
		var err:String = scene.init();
		if( err !=null )
			return [ null, 'Error in GeneratorSystem.generateScene. $err' ];

		// окна не будут добавлены на сцену, так как они являются частью Интерфейса пользователя.
		var configWindow:Array<Int> = config.window;
		if( configWindow != null ) // Внутри Window есть чайлды в виде button. создаются в функции создании окна.
		{
			for( i in 0...configWindow.length )
			{
				var windowDeployId:Int = configWindow[ i ];
				var createWindow:Array<Dynamic> = this.generateWindow( windowDeployId );
				var window:Window = createWindow[ 0 ];
				var windowError:String = createWindow[ 1 ];
				if( windowError != null )
					return [ null, 'Error in GeneratorSystem.generateScene. $windowError' ];

				scene.addChild( window );
			}
		}

		var configBuilding:Array<Int> = config.building;
		if( configBuilding != null )
		{
			for( j in 0...configBuilding.length )
			{
				var buildingDeployId:Int = configBuilding[ j ];
				var createBuilding:Array<Dynamic> = this.generateBuilding( buildingDeployId );
				var building:Building = createBuilding[ 0 ];
				var buildingError:String = createBuilding[ 1 ];
				if( buildingError != null )
					return [ null, 'Error in GeneratorSystem.generateScene. $buildingError' ];

				scene.addChild( building );
			}
		}

		return [ scene, null ];
	}

	public function generateWindow( deployId:Int ):Array<Dynamic>
	{
		var config:Dynamic = this._windowDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.generateWindow. Deploy ID: '" + deployId + "' doesn't exist in WindowDeploy data" ];

		
		var id:Int = this._createId();
		var sprite:Sprite = new Sprite();
		sprite.x = config.x;
		sprite.y = config.y;

		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );		

		var configForWindow:Dynamic = 
		{
			"id": id,
			"name": config.name,
			"deployId": deployId,
			"sprite": sprite,
			"alwaysActive": config.alwaysActive
		}
		var window:Window = new Window( configForWindow );
		var err:String = window.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.generateWindow. $err' ];

		if( config.button != null )
		{
			for( i in 0...config.button.length )
			{
				var buttonDeployId:Int = config.button[ i ];
				var createButton:Array<Dynamic> = this.generateButton( buttonDeployId );
				var button:Button = createButton[ 0 ];
				var bErr:String = createButton[ 1 ];
				if( bErr != null )
					return [ null, 'Error in GeneratorSystem.generateWindow. $bErr' ];
				window.addChild( button );
				var buttonSprite:Sprite = button.get( "sprite" );
				sprite.addChild( buttonSprite );
			}
		}

		return [ window, null ];
	}

	public function generateButton( deployId:Int ):Array<Dynamic>
	{
		var config:Dynamic = this._buttonDeploy.get( deployId );
		if( config == null )
			return [ null, 'Error in GeneratorSystem.generateButton. Deploy ID: "$deployId" does not exist in ButtonDeploy data' ];

		
		var id:Int = this._createId();
		var sprite:Sprite = new Sprite();
		sprite.x = config.x;
		sprite.y = config.y;

		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForButton:Dynamic = 
		{
			"id": id,
			"name": config.name,
			"deployId": deployId,
			"sprite": sprite
		}
		var button:Button = new Button( configForButton );
		var err:String = button.init();
		if( err != null )
			return [ null , 'Error in GeneratorSystem.generateButton. $err' ];

		return [ button, null ];
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
			var index:Int = Math.floor( Math.random() * heroRares.length )
			var heroRarity:String = heroRares[ index ];
			var createHero:Array<Dynamic> = this.generateHero( "random", heroRarity, "random" );
			var err:String = createHero[ 1 ];
			var hero:Hero = createHero[ 0 ];
			if( err != null )
				throw 'Error in GeneratorSystem.generateHeroesForBuildingRecruits. $err';

			building.addChild( hero ); // Никакой проверки.
		}
	}





	// PRIVATE


	private function _createGraphicsSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap;

		if( config.imageNormalURL != null )
		{
			bitmap = this._createBitmap( config.imageNormalURL, config.imageNormalX, config.imageNormalY );
			sprite.addChild( bitmap );
		}

		if( config.imageHoverURL != null )
		{
			bitmap = this._createBitmap( config.imageHoverURL, config.imageHoverX, config.imageHoverY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		if( config.imagePushURL != null )
		{
			bitmap = this._createBitmap( config.imagePushURL, config.imagePushX, config.imagePushY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		// TODO: Portrait for button hero, Level for button hero.

		return sprite;
	}
	private function _createBitmap( url:String, x:Float, y:Float ):Bitmap
	{
		var bitmap:Bitmap = new Bitmap( Assets.getBitmapData( url ) );
		bitmap.x = x;
		bitmap.y = y;
		return bitmap;
	}

	private function _createTextSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var text:TextField;
		var textConfig:Dynamic = 
		{
			"text": null,
			"size": null,
			"color": null,
			"width": null,
			"height": null,
			"x": null,
			"y": null,
			"align": null
		};

		if( config.firstText != null )
		{
			textConfig.text = config.firstText;
			textConfig.size = config.firstTextSize;
			textConfig.color = config.firstTextColor;
			textConfig.width = config.firstTextWidth;
			textConfig.height = config.firstTextHeight;
			textConfig.x = config.firstTextX;
			textConfig.y = config.firstTextY;
			textConfig.align = config.firstTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		if( config.secondText != null )
		{
			textConfig.text = config.secondText;
			textConfig.size = config.secondTextSize;
			textConfig.color = config.secondTextColor;
			textConfig.width = config.secondTextWidth;
			textConfig.height = config.secondTextHeight;
			textConfig.x = config.secondTextX;
			textConfig.y = config.secondTextY;
			textConfig.align = config.secondTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		return sprite;
	}

	private function _createText( text:Dynamic ):TextField
	{
        var txt:TextField = new TextField();

        var align:Dynamic = null;
        switch( text.align )
        {
        	case "left": align = TextFormatAlign.LEFT;
        	case "right": align = TextFormatAlign.RIGHT;
        	case "center": align = TextFormatAlign.CENTER;
        	default: throw( "Error in GeneratorSystem._createText. Wrong align: " + text.align + "; text: " + text.text );
        }

        var textFormat:TextFormat = new TextFormat();
        textFormat.font = "Verdana";
        textFormat.size = text.size;
        textFormat.color = text.color;        
        textFormat.align = align;

        txt.defaultTextFormat = textFormat;
        txt.visible = true;
        txt.selectable = false;
        txt.text = text.text;
        txt.width = text.width;
        txt.height = text.height;
        txt.x = text.x;
        txt.y = text.y;

        if( text.text == null || text.width == null || text.height == null || text.x == null || text.y == null || text.size == null || text.color == null )
        	throw( "Some errors in GeneratorSystem._createText. In config some values is NULL. Text: " + text.text );

        return txt;
	}

	private function _createId():Int
	{
		var result:Int = this._nextId;
		this._nextId++;
		return result;
	}

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