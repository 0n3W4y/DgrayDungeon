package;

import ItemSystem.ItemSystemConfig;
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

typedef BuildingEvent =
{
	var SceneID:SceneID;
	var BuildingID:BuildingID;
	var BuildingEventName:String;
	var BuildingEventTime:Float;
	var BuildingEventCurrentTime:Float;
}

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;
	//private var _sceneAfterLoaderScene:Scene;
	private var _nextDrawScene:Scene;

	private var _sceneEvents:Array<SceneEvent>;
	private var _buildingEvents:Array<BuildingEvent>;


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
		this._nextDrawScene = null;
		this._scenesArray = new Array<Scene>();
		this._sceneEvents = new Array<SceneEvent>();
		this._buildingEvents = new Array<BuildingEvent>();
	}

	public function postInit():String
	{
		return null;
	}

	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		this._updateSceneEvents( time );
		this._updateBuildingEvents( time );
		//this._updateObjectEvents( time );
		//this._updateCharacterEvents( time );
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
			case "dungeonCaveOneEasy", "dungeonCaveOneNormal", "dungeonCaveOneHard", "dungeonCaveOneExtreme": this._changeSceneToDungeonCave( scene );
			default: throw 'Error in SceneSystem.changeSceneTo. Can not change scene to "$sceneName"';
		}
	}

	public function createBuildingEvent( sceneId:SceneID, buildingId:BuildingID, eventType:String, time:Float ):Void
	{
		if( eventType == "updateListOfRecruits" || eventType == "updateListOfItems" )
			this._buildingEvents.push({ SceneID: sceneId, BuildingID: buildingId, BuildingEventName: eventType, BuildingEventTime: time, BuildingEventCurrentTime: time });
		else
			throw 'Error in SceneSystem.createBuildingEvent. Can not create "$eventType"';
	}

	public function removeBuildingEvent( event:BuildingEvent ):Void
	{
		this._buildingEvents.remove( event );
	}

	public function createSceneEvent( sceneId:SceneID, eventType:String, time:Float ):Void
	{
		if( eventType == "reviewScene" || eventType == "showScene" || eventType == "hideScene" || eventType == "showLoaderScene" || eventType == "undrawSceneWithHide" )
			this._sceneEvents.push({ SceneID: sceneId, SceneEventName: eventType, SceneEventTime: time, SceneEventCurrentTime: time });
		else
			throw 'Error in SceneSystem.createSceneEvent. Can not create "$eventType"';		
	}

	public function removeSceneEvent( event:SceneEvent ):Void
	{
		this._sceneEvents.remove( event );
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
		var config:Dynamic = this._parent.getSystem( "deploy" ).getScene( sceneDeployId );
		if( config == null )
			throw 'Error in SceneSystem.createScene. Deploy ID: "$deployId + " does not exist in SceneDeploy data';

		if( deployId >= 1100 )
		{
			var battleScene:Scene = this._createBattleScene( sceneDeployId, config );
			return battleScene;
		}

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
    		case "recruits": {};
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



	private function _drawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var prepared:String = scene.get( "prepared" );
		if( prepared == "unprepared" )
			throw 'Error in SceneSystem.drawScene. Scene "$name" is "$prepared"';

		var isDrawed:Bool = scene.get( "isDrawed" );
		if( isDrawed )
			throw 'Error in SceneSystem._drawScene. Scene "$name" already drawed';

		if( name == "loaderScene" )
		{
			this._drawLoaderScene( scene );
			return;
		}
		var sceneSprite:Sprite = scene.get( "sprite" );
		sceneSprite.alpha = 0.0;
		//this.createSceneEvent( scene.get( "id" ), "reviewScene", 1000 );
		this._scenesSprite.addChild( scene.get( "sprite" ));
		this._drawUiForScene( scene );
		scene.setDrawed( true );
		this._afterDrawScene( scene );
		this._activeScene = scene;
	}

	private function _undrawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var isDrawed:Bool = scene.get( "isDrawed" );
		if( !isDrawed )
			throw 'Error in SceneSystem._undrawScene. Scene "$name" not drawed yet';

		if( name == "loaderScene" )
		{
			this._undrawLoaderScene( scene );
			return;
		}

		var sceneSprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.removeChild( sceneSprite );
		this._undrawUiForScene( scene );
		scene.setDrawed( false );
		this._activeScene = null;
	}

	private function _updateSceneEvents( time:Float ):Void
	{
		for( i in 0...this._sceneEvents.length )
		{
			var event:SceneEvent = this._sceneEvents[ i ];
			if( event == null )
				return;// защита после того, как предыдущий ивент был удален.

			event.SceneEventCurrentTime -= time;
			switch( event.SceneEventName )
			{
				case "reviewScene":	this._reviewScene( event );
				case "showScene": this._showScene( event );
				case "hideScene": this._hideScene( event );
				case "showLoaderScene": this._showLoaderScene( event );
				case "undrawSceneWithHide": this._undrawSceneWithHide( event );
				default: throw 'Error in SceneSystem._updateSceneEvents. No event found for "$event"';
			}
		}
	}

	private function _updateBuildingEvents( time:Float ):Void
	{
		for( i in 0...this._buildingEvents.length )
		{
			var event:BuildingEvent = this._buildingEvents[ i ];
			if( event == null )
				return; // защита после того, как предыдущий ивент был удален.

			event.BuildingEventCurrentTime -= time;
			switch ( event.BuildingEventName )
			{
				case "updateListOfRecruits": this._updateListOfRecruits( event );
				//case "updateListOfShopItems": this._updateListOfShopItems( event );
				default: throw 'Error in SceneSystem._updateBuildingEvents. No event found for "$event"';
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
			this.prepareBuilding( building );

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

	private function _prepareLoaderScene( scene:Scene ):Void
	{
		scene.changePrepareStatus( "prepared" );
	}

	

	private function _drawLoaderScene( scene:Scene ):Void
	{
		var bitmap:Bitmap = scene.get( "graphics" ).getGraphicsAt( 1 );
		bitmap.width = 1.0;

		var sprite:Sprite = scene.get( "sprite" );
		//sprite.alpha = 1.0; // запускаем его видимым.
		this._scenesSprite.addChild( sprite );
		scene.setDrawed( true );
	}

	private function _undrawLoaderScene( scene:Scene ):Void
	{
		this._scenesSprite.removeChild( scene.get( "sprite" ));
		scene.setDrawed( false );
	}

	private function _doLoaderScene():Void
	{
		if( this._activeScene != null )
			throw 'Error in SceneSystem._doLoader. Active scene not null';

		var nextScene:Scene = this._nextDrawScene;
		if( nextScene == null )
			throw 'Error in SceneSystem._doLoaderScene. Next Scene is null';

		var loader:Scene = this.getSceneByName( "loaderScene" );
		this._drawScene( loader );
		var bitmap:Bitmap = loader.get( "graphics" ).getGraphicsAt( 1 ); // полоска "прогрессбара".
		var hundredPercentBitmap:Bitmap = loader.get( "graphics" ).getGraphicsAt( 2 ); // рамка прогрессбара ( длинна ).
		var hundredPercentWidth:Float = hundredPercentBitmap.width - 10; // запоминае длинну рамки прогрессбара. что бы сам прогрессбар довести до него.

		var sceneName:String = nextScene.get( "name" );
		switch( sceneName )
		{
			case "cityScene":
			{
				var chooseDungeonScene:Scene = this.getSceneByName( 'chooseDungeonScene' );
				var cityScenePrepared:String = nextScene.get( "prepared" );
				var chooseDungeonScenePrepared:String = chooseDungeonScene.get( 'prepared' );
				// change loader sprite (1) to 15%;
				bitmap.width = hundredPercentWidth * 0.15; 
				if( cityScenePrepared == "unprepared" )
					this._prepareCityScene( nextScene );

				if( chooseDungeonScenePrepared == 'unprepared' )
					this._prepareChooseDungeonScene( chooseDungeonScene );

				//change loader sprite (1) to 30%;
				bitmap.width = hundredPercentWidth * 0.30; 
				this._drawScene( nextScene );
				//this._drawScene( chooseDungeonScene );
				
				//change loader sprite (1) to 45%;
				bitmap.width = hundredPercentWidth * 0.45; 
				//this.createSceneEvent( this._activeScene.get( "id" ), "undrawSceneWithHide", 200 );
				//change loader to 60%
				bitmap.width = hundredPercentWidth * 0.60; 
				//this._activeScene = nextScene;
				//change loader to 75%
				bitmap.width = hundredPercentWidth * 0.75; 
				this.createSceneEvent( this._activeScene.get( "id" ), "showScene", 1000 );
				//change loader to 100%
				bitmap.width = hundredPercentWidth * 1;
			}
			case "dungeonCaveEasy":
			{

			}
			default: throw 'Error in SceneSystem._doLoaderScene. Can not load scene "$sceneName" from loaderScene ';
		}
		this._undrawScene( loader );
	}

	private function _changeSceneToStartScene( scene:Scene ):Void
	{
		var currentScene:Scene = this._activeScene;
		var sceneLoader:Scene;
		if( currentScene == null ) // делаем вывод, что это начало игры.
		{

			sceneLoader = this.createScene( 1003 ); // create loader;
			this._prepareLoaderScene( sceneLoader );

			this._prepareStartScene( scene );
			this._drawScene( scene );
			this.createSceneEvent( scene.get( "id" ), "showScene", 1000 );
			//this._activeScene = scene;
		}
		else
		{
			//TODO: draw loader, save game - do progress in loader, undraw old scene - do progress in loader, - draw new scene - do progress, remove loader, show scene;
			sceneLoader = this.getSceneByName( "loader" );
			//this._sceneAfterLoaderScene = scene;
			this._nextDrawScene = scene;
		
		}
	}

	private function _changeSceneToCityScene( scene:Scene ):Void
	{
		var currentScene:Scene = this._activeScene;
		var sceneName:String = currentScene.get( "name" );
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var state:State = this._parent.getSystem( "state" );

		ui.hide();
		//var sceneLoader:Scene = this.getSceneByName( "loaderScene" );
		switch( sceneName )
		{
			case "chooseDungeonScene":
			{
				this.hideScene( currentScene );
				ui.closeAllActiveWindows();
				state.clearAllChooseHeroToDungeonButton();
				state.clearChoosenDungeon();
				this._activeScene = scene;
				this._undrawUiForScene( currentScene );
			}
			case "startScene":
			{
				ui.hide();
				//this._sceneAfterLoaderScene = scene;
				this._nextDrawScene = scene;

				this.undrawSceneWithHide( currentScene );
				//this._activeScene = sceneLoader;
				//this._drawLoaderScene( sceneLoader );
				//this.createSceneEvent( sceneLoader.get( "id" ), "showLoaderScene", 550 );
			}
			default: throw 'Error in SceneSystem._changeSceneToCityScene. Can not change to City scene from "$sceneName"';
		}
	}

	private function _changeSceneToChooseDungeonScene( scene:Scene ):Void
	{
		this._parent.getSystem( "ui" ).hide();
		var currentScene:Scene = this._activeScene;
		this._parent.getSystem( "ui" ).closeAllActiveWindows();
		this._parent.getSystem( "state" ).unchooseActiveInnHeroButtonInCityScene();
		this._activeScene = scene;
		
		var isScenePrepared:String = scene.get( "prepared" );
		if( isScenePrepared == "unprepared" )
			this._prepareChooseDungeonScene( scene );

		this.hideScene( currentScene );
		var isSceneDrawed:Bool = scene.get( "isDrawed" );
		if( !isSceneDrawed )
		{
			this._drawScene( scene );
			return;
		}
		
		this._drawUiForScene( scene );
	}

	private function _changeSceneToDungeonCave( scene:Scene ):Void
	{
		var currentScene:Scene = this._activeScene;
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var state:State = this._parent.getSystem( "state" );
		
		ui.hide();
		ui.closeAllActiveWindows();

		state.clearAllChooseHeroToDungeonButton();
		state.clearChoosenDungeon();

		var sceneLoader:Scene = this.getSceneByName( "loaderScene" ); // withoutchek. because loader already created when game started;
		this._activeScene = sceneLoader;
		this._nextDrawScene = scene;
		this.hideScene( currentScene );
		this._undrawUiForScene( currentScene );			
		
	}

	private function _afterDrawScene( scene:Scene ):Void
	{
		var sceneName:String = scene.get( "name" );
		switch( sceneName )
		{
			case "cityScene":
			{
				var state:State = this._parent.getSystem( "state" );
				state.generateHeroesForRecruitBuilding();
				state.generateItemsForMerchantBuilding();
			}
		}
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

	private function _createBattleScene( sceneDeployId:SceneDeployID, config:Dynamic ):Scene
	{
		var id:SceneID = SceneID( this._parent.createId() );
		var sprite:Sprite = new Sprite();

		
		//var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		//sprite.addChild( graphicsSprite );
		//var textSprite:Sprite = this._createTextSprite( config );
		//sprite.addChild( textSprite );
		
		var graphicsSprite:Sprite = this._createGraphicsSpriteForBattleScene( config.images );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = null;

		var availableQuests:Array<String> = config.quest;
		var minEnemyEvents:Int = config.enemyEventsMin;
		var maxEnemyEvents:Int = config.enemyEventsMax;

		var questIndex:Int = Math.floor( Math.random() * availableQuests.length );

		var enemyEvents:Int = Math.floor( minEnemyEvents + Math.random()*( maxEnemyEvents - minEnemyEvents + 1 ));
		var quest:Dynamic = config.quest[ questIndex ];


		var configForScene:BattleScene.BattleSceneConfig =
		{
			ID: id,
			Name: config.name,
			DeployID: sceneDeployId,
			GraphicsSprite: sprite,
			ImagesNum: config.images.length,
			Difficulty: config.difficulty,
			DungeonLength: config.dungeonLength,
			EnemyEvents: enemyEvents,
			CurrentQuest: quest
		};

		var scene = new BattleScene( configForScene );
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
		return scene;
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

		if( config.imageThirdURL != null )
		{
			bitmap = this._createBitmap( config.imageThirdURL );
			bitmap.x = config.imageThirdX;
			bitmap.y = config.imageThirdY;
			sprite.addChild( bitmap );
		}	

		return sprite;
	}

	private function _createGraphicsSpriteForBattleScene( images:Array<String> ):Sprite
	{
		var sprite:Sprite = new Sprite();

		for( i in 0...images.length )
		{
			var imageURL:String = images[ i ];
			var bitmap = this._createBitmap( imageURL );
			bitmap.x = 0;
			bitmap.y = 0;
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
	private function _reviewScene( event:SceneEvent ):Void
	{
		var scene:Scene = this.getSceneById( event.SceneID );
		var sprite:Sprite = scene.get( "sprite" );
		if( event.SceneEventCurrentTime <= 0 )
		{
			sprite.alpha = 1.0;
			this.removeSceneEvent( event );
			return;
		}
		var newAlpha:Float = -1*( 1/event.SceneEventTime )*event.SceneEventCurrentTime + 1;
		sprite.alpha = newAlpha;
	}

	private function _showScene( event:SceneEvent ):Void
	{
		var scene:Scene = this.getSceneById( event.SceneID );
		var sprite:Sprite = scene.get( "sprite" );
		if( event.SceneEventCurrentTime <= 0 )
		{
			sprite.alpha = 1.0;
			this._parent.getSystem( "ui" ).show();
			this.removeSceneEvent( event );
			//TODO: do click scene objects;
			return;
		}
		if( !sprite.visible )
		{
			sprite.alpha = 0.0;
			sprite.visible = true;
			this._parent.getSystem( "ui" ).show();
		}
		var newAlpha:Float = -1*( 1/event.SceneEventTime )*event.SceneEventCurrentTime + 1;
		sprite.alpha = newAlpha;
	}

	private function _hideScene( event:SceneEvent ):Void
	{
		var scene:Scene = this.getSceneById( event.SceneID );
		var sprite:Sprite = scene.get( "sprite" );
		if( event.SceneEventCurrentTime <= 0 )
		{
			sprite.alpha = 0.0;
			sprite.visible = false;
			this.removeSceneEvent( event );
			this.createSceneEvent( this._activeScene.get( "id" ), "showScene", 1000 );
			return;
		}
		var newAlpha:Float = ( 1/event.SceneEventTime )*event.SceneEventCurrentTime;
		sprite.alpha = newAlpha;
	}

	private function _showLoaderScene( event:SceneEvent ):Void
	{
		var scene:Scene = this.getSceneById( event.SceneID );
		var sprite:Sprite = scene.get( "sprite" );
		var newAlpha:Float = -1*( 1/event.SceneEventTime )*event.SceneEventCurrentTime + 1;
		sprite.alpha = newAlpha;

		if( event.SceneEventCurrentTime <= 0 )
		{
			this.removeSceneEvent( event );
			this._doLoaderScene();
		}
	}

	private function _undrawSceneWithHide( event:SceneEvent ):Void
	{
		var scene:Scene = this.getSceneById( event.SceneID );
		var sprite:Sprite = scene.get( "sprite" );
		if( event.SceneEventCurrentTime <= 0 )
		{
			sprite.alpha = 0.0;
			sprite.visible = false;
			this.removeSceneEvent( event );
			this._undrawScene( scene );
			this._doLoaderScene();
			return;
		}
		var newAlpha:Float = ( 1/event.SceneEventTime )*event.SceneEventCurrentTime;
		sprite.alpha = newAlpha;
	}

	private function _updateListOfRecruits( event:BuildingEvent ):Void
	{
		
		if( event.BuildingEventCurrentTime%1000 <= 34 ) // 1000/ 60 = 16.6 , x2 = 33.2; - in game.hx 
		{
			var num = event.BuildingEventCurrentTime/1000;
			var minute = Math.ffloor((num / 60) % 60);
			var strMinute = '$minute';
			if( minute < 10 )
				strMinute = '0' + '$minute';
			var seconds = Math.ffloor(num % 60);
			var strSeconds = '$seconds';
			if( seconds < 10 )
				strSeconds = '0' + '$seconds';

			var string:String = 'Next recruits in $strMinute:$strSeconds';
			this._parent.getSystem( "ui" ).setTextToWindow( 3002, string, "timer" );
		}

		if( event.BuildingEventCurrentTime <= 34 )
		{
			this.removeBuildingEvent( event );
			this._parent.getSystem( "state" ).generateHeroesForRecruitBuilding();
		}
		
	}
}
