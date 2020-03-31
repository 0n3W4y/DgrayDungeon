package;

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
	var SceneEventTime:Int;
}

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;

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
	}

	public function postInit():String
	{
		return null;
	}

	public function update( time:Int ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		this._upfateSceneEvents( time );
	}

	public function addScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check != null )
			throw 'Error in SceneSystem.addScene. Scene with name "$name" already in.';

		this._scenesArray.push( scene );
	}

	public function removeScene( scene:Scene ):Scene
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check == null )
			throw 'Error in SceneSystem.addScene. Scene with name "$name" does not exist.';

		this.undrawUiForScene( scene );
		this._destroyUiForScene( scene );
		this._scenesArray.splice( check, 1 );
		return scene;
	}

	public function fastSwitchScenes( scene:Scene ):Void
	{
		var sceneName:String = scene.get( "name" );
		var sceneId:SceneID = scene.get( "id" );
		var sceneDeployId:SceneDeployID = scene.get( "deployId" );
		var activeSceneId:SceneID = this._activeScene.get( "id" );
		if( !haxe.EnumTools.EnumValueTools.equals( sceneId, activeSceneId ))
			throw 'Error in SceneSystem.fastSwitchScenes. Cannot switch scenes, becase scene is not active';

		var sceneToSwitchId:SceneID = scene.get( "sceneForFastSwitch" );
		if( sceneToSwitchId == null )
			throw 'Error in SceneSystem.switchCitySceneToChooseDungeonScene. Can not switch scene, because scene for fast switch is null';

		var sceneToFastSwitch:Scene = this.getSceneById( sceneToSwitchId );
		var sceneToFastSwitchIsDrawed:Bool = sceneToFastSwitch.get( "isDrawed" );
		var sceneToFastSwitchDeployId:SceneDeployID = sceneToFastSwitch.get( "deployId" );

		this._activeScene = sceneToFastSwitch;
		this.hideScene( scene );

		if( sceneName == "cityScene" )
		{
			if( sceneToFastSwitchIsDrawed )
			{
				this.showScene( sceneToFastSwitch ); // показываем ранее скрытую сцену выбора данжа.
				this.drawUiForScene( sceneToFastSwitch ); // прорисовываем окна интерфейса для сцены выбора данжа.
			}
			else
			{
				this.drawScene( sceneToFastSwitch );
				this._parent.getSystem( "ui" ).closeAllActiveWindows();
			}
		}
		else
		{
			if( sceneToFastSwitchIsDrawed )
			{
				this.showScene( sceneToFastSwitch ); // показываем сцену города.
				this.undrawUiForScene( scene ); // убираем окна с интерфейса для сцены выбора данжа.
			}
			else
			{
				throw 'Error in SceneSystem.fastSwitchScenes. City Scene not drawed!!!!!';
			}
		}

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

	public function undrawUiForScene( scene:Scene ):Void
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
			case "chooseDungeonScene": this._prepareChooseDungeonScene( scene );
			case "dungeonCaveOne": this._prepareDungeonScene( scene );
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
			throw 'Error in SceneSystem.drawScene. Scene "$name" is "$prepared"';

		var isDrawed:Bool = scene.get( "isDrawed" );
		if( isDrawed )
			throw 'Error in SceneSystem,drawScene. Scene "$name" already drawed';


		this._scenesSprite.addChild( scene.get( "sprite" ));
		this.drawUiForScene( scene );
		this._parent.getSystem( "ui" ).show();
		scene.setDrawed( true );
	}

	public function undrawScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.removeChild( sprite );
		this._parent.getSystem( "ui" ).hide();
		this.undrawUiForScene( scene );
		scene.setDrawed( false );
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
        var sprite:Sprite = new Sprite();
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
    	var name:String = building.get( "name" );
    	switch( name )
    	{
    		case "recruits": this._prepareBuildingRecruits( building );
    		case "hospital": {};
    		case "fontain": {};
    		case "inn": {};
    		case "tavern": {};
    		case "blacksmith": {};
    		case "merchant": {};
    		case "graveyard": {};
    		case "academy": {};
    		case "hermit": {};
    		case "questman": {};
    		default: throw 'Error. in SceneSystem.prepareBuilding. No action found for building "$name"';
    	}
    }

	//PRIVATE

	private function _prepareBuildingRecruits( building:Building ):Void
	{
		//TODO: Create heroes, add heroes to building.
		this._parent.getSystem( "state" ).generateHeroesForBuilding( building );
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

	private function _checkSceneIfExist( scene:Scene ):Int
	{
		for( i in 0...this._scenesArray.length )
		{
			if( scene.get( "id" ).match( this._scenesArray[ i ].get( "id" ) ) )
				return i;
		}
		return null;
	}

	private function _upfateSceneEvents( time:Int ):Void
	{
		var state:State = this._parent.getSystem( "state" );
		for( i in 0...this._sceneEvents.length )
		{
			var event:SceneEvent = this._sceneEvents[ i ];
			event.SceneEventTime -= time;
			if( event.SceneEventTime <= 0 )
				state.onSceneEventDing( event );
		}
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

		if( config.imageSecondURL != null )
		{
			bitmap = this._createBitmap( config.imageHoverURL );
			bitmap.x = config.imageSecondX;
			bitmap.y = config.imageSecondY;
			sprite.addChild( bitmap );
		}

		if( config.imageThirdURL != null )
		{
			bitmap = this._createBitmap( config.imagePushURL );
			bitmap.x = config.imageThirdX;
			bitmap.y = config.imageThirdY;
			sprite.addChild( bitmap );
		}

		return sprite;
	}

	private function _createBitmap( url:String ):Bitmap
	{
		var bitmap:Bitmap = new Bitmap( Assets.getBitmapData( url ) );
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
}
