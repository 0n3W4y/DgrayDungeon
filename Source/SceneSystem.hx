package;

import haxe.EnumTools;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import Scene;
import Building;
import Window;

typedef SceneSystemConfig =
{
	var Parent:Game;
	var GraphicsSprite:Sprite;
}

typedef SceneEvent = 
{
	var SceneID:SceneID;
	var SceneEventName:String;
	var SceneEventTime:Float;
	var SceneEventCurrentTime:Float;
}

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;
	private var _sceneAfterLoader:Scene;

	private var _sceneEvents:Array<SceneEvent>;


	public function new( config:SceneSystemConfig ):Void
	{
		this._scenesSprite = config.GraphicsSprite;
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = 'Error in SceneSystem.init';

		if( this._parent == null )
			throw '$error. $err Parent is null';

		if( this._scenesSprite == null )
			throw '$error. $err. Sprite is null';

		this._activeScene = null;
		this._scenesArray = new Array<Scene>();
		this._sceneEvents = new Array<SceneEvent>();
	}

	public function postInit():String
	{
		return null;
	}

	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		this._updateSceneEvents( time );
	}

	public function addScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneByDeployId( scene.get( "deployId" ));
		if( check != null )
			throw 'Error in SceneSystem.addScene. Scene with name "$name" already in.';

		this._scenesArray.push( scene );
	}

	public function removeScene( scene:Scene ):Scene
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneByDeployId( scene.get( "deployId" ));
		if( check == null )
			throw 'Error in SceneSystem.addScene. Scene with name "$name" does not exist.';

		this._undrawUiForScene( scene );
		this._destroyUiForScene( scene );
		this._scenesArray.splice( check, 1 );
		return scene;
	}

	public function changeSceneTo( scene:Scene ):Void //full undraw active scene, and draw new scene;
	{
		var sceneName:String = scene.get( "name" );
		switch( sceneName )
		{
			case "startScene": this._changeSceneToStartScene( scene );
			case "cityScene": this._changeSceneToCityScene( scene );
			case "chooseDungeonScene": this._changeSceneToChooseDungeonScene( scene );
			default: throw 'Error in SceneSystem.changeSceneTo. Can not change scene to "$sceneName"';
		}
	}

	public function createSceneEvent( sceneId:SceneID, eventType:String, time:Float ):Void
	{
		switch( eventType )
		{
			case "reviewScene": this._sceneEvents.push({ SceneID: sceneId, SceneEventName: eventType, SceneEventTime: time, SceneEventCurrentTime: time });
			case "showScene": this._sceneEvents.push({ SceneID:sceneId, SceneEventName: eventType, SceneEventTime: time, SceneEventCurrentTime: time });
			case "hideScene": this._sceneEvents.push({ SceneID:sceneId, SceneEventName: eventType, SceneEventTime: time, SceneEventCurrentTime: time });
			case "checkShowLoader": this._sceneEvents.push({ SceneID:sceneId, SceneEventName: eventType, SceneEventTime: time, SceneEventCurrentTime: time });
			case "undrawSceneWithHide": this._sceneEvents.push({ SceneID:sceneId, SceneEventName: eventType, SceneEventTime: time, SceneEventCurrentTime: time });
			default: throw 'Error in SceneSystem.createSceneEvent. can not create "$eventType"';
		}
	}

	public function removeSceneEvent( sceneId:SceneID, eventType:String ):Void
	{
		for( i in 0...this._sceneEvents.length )
		{
			var event:SceneEvent = this._sceneEvents[ i ];
			if( event.SceneEventName == eventType && haxe.EnumTools.EnumValueTools.equals( sceneId, event.SceneID ))
			{
				this._sceneEvents.splice( i, 1 );
				return;
			}
		}
	}

	public function showScene( scene:Scene ):Void
	{
		this.createSceneEvent( scene.get( "id" ), "showScene", 1000 );
		//scene.get( "sprite" ).visible = true;
	}

	public function hideScene( scene:Scene ):Void
	{
		this.createSceneEvent( scene.get( "id" ), "hideScene", 1000 );
		//scene.get( "sprite" ).visible = false;
	}

	public function undrawSceneWithHide( scene:Scene ):Void
	{
		this.createSceneEvent( scene.get( "id" ), "undrawSceneWithHide", 1000 );
	}

	public function getParent():Game
	{
		return this._parent;
	}

	public function getActiveScene():Scene
	{
		return this._activeScene;
	}

	public function getSceneByName( name:String ):Scene
	{
		for( i in 0...this._scenesArray.length )
		{
			var sceneName:String = this._scenesArray[ i ].get( "name" );
			if( sceneName == name )
				return this._scenesArray[ i ];
		}
		return null;
	}

	public function getSceneById( id:SceneID ):Scene
	{
		for( i in 0...this._scenesArray.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( id, this._scenesArray[ i ].get( "id" )))
				return this._scenesArray[ i ];
		}
		return null;
	}

	public function createScene( deployId:Int ):Scene
	{
		var sceneDeployId:SceneDeployID = SceneDeployID( deployId );
		var config = this._parent.getSystem( "deploy" ).getScene( sceneDeployId );
		if( config == null )
			throw 'Error in SceneSystem.createScene. Deploy ID: "$deployId + " does not exist in SceneDeploy data';

		var id:SceneID = SceneID( this._parent.createId() );
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForScene:SceneConfig =
		{
			ID: id,
			Name: config.name,
			DeployID: sceneDeployId,
			GraphicsSprite: sprite
		};
		var scene = new Scene( configForScene );
		scene.init( 'Error in SceneSystem.createScene. Error in Scene.init' );

		var configWindow:Array<Int> = config.window;
		if( configWindow != null ) // Внутри Window есть чайлды в виде button. создаются в функции создании окна.
		{
			var ui:UserInterface = this._parent.getSystem( "ui" );
			for( i in 0...configWindow.length )
			{
				ui.createWindow( configWindow[ i ] );
			}
		}

		var configBuilding:Array<Int> = config.building;
		if( configBuilding != null )
		{
			for( j in 0...configBuilding.length )
			{
				var building:Building = this.createBuilding( configBuilding[ j ] );
				scene.addChild( building );
				this.prepareBuilding( building );
			}
		}

		this._scenesArray.push( scene );
		return scene;
	}

	public function createBuilding( deployId:Int ):Building
    {
    	var buildingDeployId:BuildingDeployID = BuildingDeployID( deployId );
        var config = this._parent.getSystem( "deploy" ).getBuilding( buildingDeployId );
        if( config == null )
            throw 'Error in SceneSystem.createBuilding. Deploy ID: $deployId doesnt exist';

        var id:BuildingID = BuildingID( this._parent.createId() );
        var sprite:Sprite = new DataSprite({ ID: id, Name: config.name });
		sprite.x = config.x;
		sprite.y = config.y;
        var graphicsSprite:Sprite = this._createGraphicsSprite( config );
        sprite.addChild( graphicsSprite );
        var textSprite:Sprite = this._createTextSprite( config );
        sprite.addChild( textSprite );
				textSprite.visible = false;

        var moneyInt:Int = config.moneyAmount;
        var money:Player.Money = moneyInt;
        var buildingConfig:BuildingConfig =
        {
            ID: id,
            DeployID: buildingDeployId,
            Name: config.name,
            GraphicsSprite: sprite,
            UpgradeLevel: config.upgradeLevel,
            NextUpgradeId: config.nextUpgradeId,
            CanUpgradeLevel: config.canUpgradeLevel,
            UpgradePrice: money,
            HeroStorageSlotsMax: config.heroStorageSlotsMax,
            ItemStorageSlotsMax: config.itemStorageSlotsMax

        };
        var building:Building = new Building( buildingConfig );
        building.init( 'Error in SceneSystem.createBuilding. Building.init' );

        return building;
    }

    public function prepareBuilding( building:Building ):Void
    {
		var state:State = this._parent.getSystem( "state" );
    	var name:String = building.get( "name" );
    	switch( name )
    	{
    		case "recruits": state.generateHeroesForBuilding( building );
    		case "hospital": {};
    		case "fontain": {};
    		case "inn": {};
    		case "tavern": {};
    		case "blacksmith": {};
    		case "merchant": state.generateItemsForBuilding( building );
    		case "graveyard": {};
    		case "academy": {};
    		case "hermit": {};
    		case "questman": {};
    		default: throw 'Error. in SceneSystem.prepareBuilding. No action found for building "$name"';
    	}
	}
	




	//PRIVATE



	private function _drawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var prepared:String = scene.get( "prepared" );
		if( prepared == "unprepared" )
			throw 'Error in SceneSystem.drawScene. Scene "$name" is "$prepared"';

		var isDrawed:Bool = scene.get( "isDrawed" );
		if( isDrawed )
			throw 'Error in SceneSystem._drawScene. Scene "$name" already drawed';

		var sceneSprite:Sprite = scene.get( "sprite" );
		sceneSprite.alpha = 0.0;
		//this.createSceneEvent( scene.get( "id" ), "reviewScene", 1000 );
		this._scenesSprite.addChild( scene.get( "sprite" ));
		this._drawUiForScene( scene );
		scene.setDrawed( true );
	}

	private function _undrawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var isDrawed:Bool = scene.get( "isDrawed" );
		if( !isDrawed )
			throw 'Error in SceneSystem._undrawScene. Scene "$name" not drawed yet';

		var sceneSprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.removeChild( sceneSprite );
		this._undrawUiForScene( scene );
		scene.setDrawed( false );
	}

	private function _updateSceneEvents( time:Float ):Void
	{
		for( i in 0...this._sceneEvents.length )
		{
			var event:SceneEvent = this._sceneEvents[ i ];
			if( event == null )
				return;

			event.SceneEventCurrentTime -= time;
			switch( event.SceneEventName )
			{
				case "reviewScene":	this._reviewScene( event.SceneID, event.SceneEventTime, event.SceneEventCurrentTime );
				case "showScene": this._showScene( event.SceneID, event.SceneEventTime, event.SceneEventCurrentTime );
				case "hideScene": this._hideScene( event.SceneID, event.SceneEventTime, event.SceneEventCurrentTime );
				case "checkShowLoader": this._checkShowLoader( event.SceneID, event.SceneEventTime, event.SceneEventCurrentTime );
				case "undrawSceneWithHide": this._undrawSceneWithHide( event.SceneID, event.SceneEventTime, event.SceneEventCurrentTime );
				default: throw 'Error in SceneSystem._updateSceneEvents. No event found for "$event"';
			}
		}
	}


	private function _prepareStartScene( scene:Scene ):Void
	{
		scene.changePrepareStatus( "prepared" );
	}

	private function _prepareCityScene( scene:Scene ):Void
	{
		var eventHandler:EventHandler = this._parent.getSystem( "event" );
		var sprite:Sprite = scene.get( "sprite" );
		var buildingsArray:Array<Building> = scene.getChilds( "building" );
		for( i in 0...buildingsArray.length )
		{
			var building:Building = buildingsArray[ i ];
			var buildingSprite:Sprite = building.get( "sprite" );
			sprite.addChild( buildingSprite );
			eventHandler.addEvents( building );

		}

		var panelCityWindow = this._parent.getSystem( "ui" ).getWindowByDeployId( 3003 ); // panel city Window
		var playerMoney:Player.Money = this._parent.getPlayer().get( "money" );
		panelCityWindow.get( "graphics" ).setText( '$playerMoney', "first" );


		scene.changePrepareStatus( "prepared" );
	}

	private function _prepareChooseDungeonScene( scene:Scene ):Void
	{
		scene.changePrepareStatus( "prepared" );
	}

	private function _prepareDungeonScene( scene:Scene ):Void
	{
		scene.changePrepareStatus( "prepared" );
		//TODO:
	}

	private function _prepareSceneLoader( scene:Scene ):Void
	{
		scene.changePrepareStatus( "prepared" );
	}

	

	private function _drawLoader( scene:Scene ):Void
	{
		var bitmap:Bitmap = scene.get( "graphics" ).getGraphicsAt( 1 );
		bitmap.width = 0;

		this._scenesSprite.addChild( scene.get( "sprite" ));
		scene.setDrawed( true );
	}

	private function _undrawLoader( scene:Scene ):Void
	{
		this._scenesSprite.removeChild( scene.get( "sprite" ));
		scene.setDrawed( false );
	}

	private function _doLoader():Void
	{
		var nextScene:Scene = this._sceneAfterLoader;
		if( nextScene == null )
			throw 'Error in SceneSystem._doLoader. Next Scene is null';

		var sceneName:String = nextScene.get( "name" );
		switch( sceneName )
		{
			case "cityScene":
			{
				var scenePrepared:String = nextScene.get( "prepared" );
				// change loader sprite (1) to %;
				if( scenePrepared == "unprepared" )
					this._prepareCityScene( nextScene );

				//change loader sprite (1) to %;
				this._drawScene( nextScene );
				//change loader sprite (1) to 100%;
				this.createSceneEvent( this._activeScene.get( "id" ), "hideScene", 500 );
				this._activeScene = nextScene;
				//this._parent.getSystem( "ui" ).show();

			}
			default: throw 'Error in SceneSystem._doLoader. Can not load scene "$sceneName" from loader ';
		}
				
		
	}

	

	

	private function _changeSceneToStartScene( scene:Scene ):Void
	{
		var currentScene:Scene = this._activeScene;
		var sceneLoader:Scene;
		if( currentScene == null ) // делаем вывод, что это начало игры.
		{

			sceneLoader = this.createScene( 1003 ); // create loader;
			this._prepareSceneLoader( sceneLoader );

			this._prepareStartScene( scene );
			this._drawScene( scene );
			this.createSceneEvent( scene.get( "id" ), "showScene", 1000 );
			this._activeScene = scene;
		}
		else
		{
			//TODO: draw loader, save game - do progress in loader, undraw old scene - do progress in loader, - draw new scene - do progress, remove loader, show scene;
			sceneLoader = this.getSceneByName( "loader" );
			this._sceneAfterLoader = scene;
		
		}
	}

	private function _changeSceneToCityScene( scene:Scene ):Void
	{
		var currentScene:Scene = this._activeScene;
		var sceneName:String = currentScene.get( "name" );
		var sceneLoader:Scene = this.getSceneByName( "loader" );
		switch( sceneName )
		{
			case "chooseDungeonScene":
			{
				this.hideScene( currentScene );
				this._parent.getSystem( "ui" ).closeAllActiveWindows();
				this._parent.getSystem( "state" ).clearAllChooseHeroToDungeonButton();
				this._activeScene = scene;
			}
			case "startScene":
			{
				this._parent.getSystem( "ui" ).hide();
				this._sceneAfterLoader = scene;
				this.undrawSceneWithHide( this._activeScene );
				this._activeScene = sceneLoader;
				this._drawLoader( sceneLoader );
				this.createSceneEvent( sceneLoader.get( "id" ), "checkShowLoader", 4000 );	
			}
			default: throw 'Error in SceneSystem._changeSceneToCityScene. Can not change to City scene from "$sceneName"';
		}
	}

	private function _changeSceneToChooseDungeonScene( scene:Scene ):Void
	{

	}

	private function _drawUiForScene( scene:Scene ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var sceneDeployId:SceneDeployID = scene.get( "deployId" );
		var configScene:Dynamic = this._parent.getSystem( "deploy" ).getScene( sceneDeployId );
		var windowArray:Array<Int> = configScene.window;

		for( i in 0...windowArray.length )
		{
			var window:Int = windowArray[ i ];
			var windowId:WindowDeployID = WindowDeployID( window );
			if( window == 3003 ) // panelCityWindow deploy Id 3003;
			{
				var panelCityWindow = ui.getWindowByDeployId( 3003 );
				var playerMoney:Player.Money = this._parent.getPlayer().get( "money" );
				panelCityWindow.get( "graphics" ).setText( '$playerMoney', "first" );
			}

			ui.addWindowOnUi( windowId );
		}
	}

	private function _undrawUiForScene( scene:Scene ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var sceneDeployId:SceneDeployID = scene.get( "deployId" );
		var configScene:Dynamic = this._parent.getSystem( "deploy" ).getScene( sceneDeployId );
		var windowArray:Array<Int> = configScene.window;

		for( i in 0...windowArray.length )
		{
			var window:Int = windowArray[ i ];
			var windowId:WindowDeployID = WindowDeployID( window );
			ui.removeWindowFromUi( windowId );
		}
	}

	private function _destroyUiForScene( scene:Scene ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var sceneDeployId:SceneDeployID = scene.get( "deployId" );
		var configScene:Dynamic = this._parent.getSystem( "deploy" ).getScene( sceneDeployId );
		var windowArray:Array<Int> = configScene.window;

		for( i in 0...windowArray.length )
		{
			var window:Int = windowArray[ i ];
			var windowId:WindowDeployID = WindowDeployID( window );
			ui.destroyWindow( windowId );
		}
	}

	private function _checkSceneByDeployId( id:SceneDeployID ):Int
	{
		for( i in 0...this._scenesArray.length )
		{
			var scene:Scene = this._scenesArray[ i ];
			var sceneDeployId:SceneDeployID = scene.get( "deployId" );
			if( haxe.EnumTools.EnumValueTools.equals( id, sceneDeployId ))
				return i;
		}
		return null;
	}

	private function _createGraphicsSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap;

		if( config.imageNormalURL != null )
		{
			bitmap = this._createBitmap( config.imageNormalURL );
			bitmap.x = config.imageNormalX;
			bitmap.y = config.imageNormalY;
			sprite.addChild( bitmap );
		}

		if( config.imageHoverURL != null )
		{
			bitmap = this._createBitmap( config.imageHoverURL );
			bitmap.x = config.imageHoverX;
			bitmap.y = config.imageHoverY;
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		if( config.imageSecondURL != null )
		{
			bitmap = this._createBitmap( config.imageSecondURL );
			bitmap.x = config.imageSecondX;
			bitmap.y = config.imageSecondY;
			sprite.addChild( bitmap );
		}

		return sprite;
	}

	private function _createBitmap( url:String ):Bitmap
	{
		return new Bitmap( Assets.getBitmapData( url ));
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
        	default: throw( "Error in SceneSystem._createText. Wrong align: " + text.align + "; text: " + text.text );
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
        	throw( "Some errors in SceneSystem._createText. In config some values is NULL. Text: " + text.text );

        return txt;
	}






	// TEST
	private function _reviewScene( id:SceneID, time:Float, currentTime:Float ):Void
	{
		var scene:Scene = this.getSceneById( id );
		var sprite:Sprite = scene.get( "sprite" );
		if( currentTime <= 0 )
		{
			sprite.alpha = 1.0;
			this.removeSceneEvent( id, "reviewScene");
			return;
		}
		var newAlpha:Float = -1*( 1/time )*currentTime + 1;
		sprite.alpha = newAlpha;
	}

	private function _showScene( id:SceneID, time:Float, currentTime:Float ):Void
	{
		var scene:Scene = this.getSceneById( id );
		var sprite:Sprite = scene.get( "sprite" );
		if( currentTime <= 0 )
		{
			sprite.alpha = 1.0;
			this._parent.getSystem( "ui" ).show();
			this.removeSceneEvent( id, "showScene");
			return;
		}
		if( !sprite.visible )
		{
			sprite.alpha = 0.0;
			sprite.visible = true;
		}
		var newAlpha:Float = -1*( 1/time )*currentTime + 1;
		sprite.alpha = newAlpha;
	}

	private function _hideScene( id:SceneID, time:Float, currentTime:Float ):Void
	{
		var scene:Scene = this.getSceneById( id );
		var sprite:Sprite = scene.get( "sprite" );
		if( currentTime <= 0 )
		{
			sprite.alpha = 0.0;
			sprite.visible = false;
			this.removeSceneEvent( id, "hideScene");
			this.createSceneEvent( this._activeScene.get( "id" ), "showScene", 1000 );
			return;
		}
		var newAlpha:Float = ( 1/time )*currentTime;
		sprite.alpha = newAlpha;
	}

	private function _checkShowLoader( id:SceneID, time:Float, currentTime:Float ):Void
	{
		var scene:Scene = this.getSceneById( id );
		var sprite:Sprite = scene.get( "sprite" );
		if( sprite.alpha >= 1.0 )
		{
			this.removeSceneEvent( id, "checkShowLoader");
			this._doLoader();
		}
	}

	private function _undrawSceneWithHide( id:SceneID, time:Float, currentTime:Float ):Void
	{
		var scene:Scene = this.getSceneById( id );
		var sprite:Sprite = scene.get( "sprite" );
		if( currentTime <= 0 )
		{
			sprite.alpha = 0.0;
			sprite.visible = false;
			this.removeSceneEvent( id, "undrawSceneWithHide" );
			this._undrawScene( scene );
			return;
		}
		var newAlpha:Float = ( 1/time )*currentTime;
		sprite.alpha = newAlpha;
	}
}
