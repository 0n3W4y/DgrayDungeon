package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;

class GeneratorSystem
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _nextId:Int;
	private var _parent:Game;

	private var _itemDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _windowDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buttonDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _heroDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buildingDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _sceneDeploy:Map<Int, Dynamic>; // Map [id]: {};

	private var _heroNames:Dynamic; // { "m": [ "Alex"], "w": [ "Stella" ]};
	private var _heroSurnames:Dynamic; // [ "Goldrich", "Duckman" ];


	public function new()
	{

	}

	public function preInit():String
	{
		this._nextId = 0;
		this._preInited = true;
		return "ok";
	}

	public function init( parent:Game, sceneDeploy:Map<Int, Dynamic>, buildingDeploy:Map<Int, Dynamic>, windowDeploy:Map<Int, Dynamic>, buttonDeploy:Map<Int, Dynamic>, heroDeploy:Map<Int, Dynamic>, itemDeploy:Map<Int, Dynamic> ):String
	{
		if( !this._preInited )
			return "Error in GeneratorSystem.init. Pre init is FALSE";

		this._parent = parent;
		if( this._parent == null )
			return  "Error in GeneratorSystem.preInit. Parent is NULL";
		
		//TODO: == null && !this.sceneDeploy.exist( 1000 ); // проверка на наличие нужного DeployId в этом объекте

		this._sceneDeploy = sceneDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. SceneDeploy is NULL";
		
		this._buildingDeploy = buildingDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. BuildingDeploy is NULL";
		
		this._windowDeploy = windowDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. WindowDeploy is NULL";
		
		this._buttonDeploy = buttonDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. ButtonDeploy is NULL";
		
		this._heroDeploy = heroDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. HeroDeploy is NULL";
		
		this._itemDeploy = itemDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. ItemDeploy is NULL";
		
		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in GeneratorSystem.postInit. Init is FALSE";

		this._postInited = true;
		return "ok";
	}

	public function generateHero( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateBuilding( deployId:Int ):Array<Dynamic>
	{
		return [];
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
		var scene = new Scene();

		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var err = scene.init( id, config.name, deployId, sprite );
		if( err != "ok" )
			return [ null, 'Error in GeneratorSystem.generateScene. $err' ];

		if( config.window != null ) // Внутри Window есть чайлды в виде button. создаются в функции создании окна.
		{
			for( i in 0...config.window.length )
			{
				var windowDeployId:Int = config.window[ i ];
				var createWindow:Array<Dynamic> = this.generateWindow( windowDeployId );
				var window:Window = createWindow[ 0 ];
				var windowError:String = createWindow[ 1 ];
				if( windowError != null )
					return [ null, 'Error in GeneratorSystem.generateScene. $windowError' ];

				var wErr = scene.addChild( window );
				if( wErr != "ok" ) // Window Error
					return [ null, 'Error in GeneratorSystem.generateScene. $wErr' ];

			}
		}

		return [ scene, null ];
	}

	public function generateWindow( deployId:Int ):Array<Dynamic>
	{
		var config:Dynamic = this._windowDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.generateWindow. Deploy ID: '" + deployId + "' doesn't exist in WindowDeploy data" ];

		var window:Window = new Window();
		var id:Int = this._createId();
		var sprite:Sprite = new Sprite();
		sprite.x = config.x;
		sprite.y = config.y;

		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );		

		var err:String = window.init( id, config.name, config.deployId, sprite );
		if( err != "ok" )
			return [ null, err ];

		if( config.button != null )
		{
			for( i in 0...config.button.length )
			{
				var buttonDeployId:Int = config.button[ i ];
				var createButton:Array<Dynamic> = this.generateButton( buttonDeployId );
				var button:Button = createButton[ 0 ];
				var buttonError:String = createButton[ 1 ];
				if( buttonError != null )
					return [ null, 'Error in GeneratorSystem.generateWindow. $buttonError' ];
				var bErr:String = window.addChild( button );
				if( bErr != "ok" ) // Button Error
					return [ null, 'Error in GeneratorSystem.generateWindow. $bErr' ];
			}
		}

		return [ window, null ];
	}

	public function generateButton( deployId:Int ):Array<Dynamic>
	{
		var config:Dynamic = this._buttonDeploy.get( deployId );
		if( config == null )
			return [ null, 'Error in GeneratorSystem.generateButton. Deploy ID: "$deployId" does not exist in ButtonDeploy data' ];

		var button:Button = new Button();
		var id:Int = this._createId();
		var sprite:Sprite = new Sprite();
		sprite.x = config.x;
		sprite.y = config.y;

		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var err:String = button.init( id, config.name, config.deployId, sprite );
		if( err != "ok" )
			return [ null, err ];

		return [ button, null ];
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
        	default: trace( "Error in GeneratorSystem._createText. Wrong align: " + text.align + "; text: " + text.text );
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
        	trace( "Some errors in GeneratorSystem._createText. In config some values is NULL. Text: " + text.text );

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