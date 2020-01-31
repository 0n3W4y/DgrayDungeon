package;

import haxe.Timer;
import openfl.system.System;
import openfl.display.Sprite;

import UserInterface;
import Deploy;

enum ID 
{
	ID( _:Int );	
}

class Game
{
	private var _mainSprite:Sprite;
	private var _scenesSprite:Sprite;
	private var _uiSprite:Sprite;

	private var _width:Int;
	private var _height:Int;
	private var _gameStart:Float;

	private var _deploy:Deploy;
	private var _state:State;
	private var _eventHandler:EventHandler;
	private var _sceneSystem:SceneSystem;
	private var _userInterface:UserInterface;


	private var _onPause:Bool;
	private var _fps:Int;
	private var _mainLoop:Timer;
	private var _currentTime:Float;
	private var _lastTime:Float;
	private var _delta:Float;
	private var _doubleDelta:Float;

	private var _player:Player;
	private var _lastSave:Dynamic;

	private var _playerDeploy:Map<Int, Dynamic>;

	public function new( width:Int, height:Int, fps:Int, mainSprite:Sprite ):Void
	{
		this._fps = fps;
		this._height = height;
		this._width = width;

		this._mainSprite = mainSprite;
		this._scenesSprite = new Sprite();
		this._uiSprite = new Sprite();
		this._mainSprite.addChild( this._scenesSprite );
		this._mainSprite.addChild( this._uiSprite );
		this._onPause = false;

		var parseDataContainer:DeployConfig = this._parseData();

		this._deploy = new Deploy( parseDataContainer );
		var err:String = this._deploy.init();
		if( err != null )
			throw 'Error in Game.new. $err';

		this._eventHandler = new EventHandler( this );
		err = this._eventHandler.init();
		if( err != null )
			throw 'Error in Game.new. $err';

		this._sceneSystem = new SceneSystem( this, this._scenesSprite );
		err = this._sceneSystem.init();
		if( err != null )
			throw 'Error in Game.new. $err';

		this._userInterface = new UserInterface( this, this._uiSprite );
		err = this._userInterface.init();
		if( err != null )
			throw 'Error in Game.new. $err';

		this._userInterface.hide();
		this._startGame();		
	}

	public function start():Void
	{
		var time = Std.int( Math.ffloor( this._delta ) );

		this._mainLoop = new Timer( 10 ); // 100 обновлений в секунду. ТЕСТ
		this._mainLoop.run = function()
		{
			this._tick();
		};
	}

	public function stop():Void
	{
		this._mainLoop.stop();
	}

	public function pause():Void
	{
		if( this._onPause )
			this._onPause = false;
		else
			this._onPause = true;
	}

	public function exit():Void
	{
		System.exit( 0 );
	}

	public function changeFpsTo( fps:Int ):Void
	{
		this._fps = fps;
		this._calculateDelta();
		this.stop();
		this.start();
	}

	public function getSystem( system:String ):Dynamic
	{
		switch( system )
		{
			case "deploy" : return this._deploy;
			case "state": return this.state;
			case "scene": return this._sceneSystem;
			case "event": return this._eventHandler;
			case "ui": return this._userInterface;
			default: trace( "Error in Game.getSystem; system can't be: " + system );
		}
		return null;
	}

	public function getMainSprite():Sprite
	{
		return this._mainSprite;
	}

	public function getPlayer():Player
	{
		return this._player;
	}

	public function getLastSave():Dynamic
	{
		return this._lastSave;
	}

	public inline function createId():ID
	{
		var result:ID = ID( this._nextId );
		this._nextId++;
		return result;
	}

	public function createPlayer( deployId:Int, name:String ):Array<Dynamic>
	{
		var config:PlayerDeploy = this._deploy.get( "player", deployId );

		var id:ID = this.createId;
		var configForPlayer:PlayerConfig =
		{
			ID: id,
			Name: name,
			DeployID: PlayerDeployID( config.deployId ),
			MaxHeroSlots: config.itemStorageSlotsMax,
			MoneyAmount: Money( config.moneyAmount )
		};

		var player:Player = new Player( configForPlayer );
		var err:String = player.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.createPlayer. $err' ];

		if( this._player != null )
			throw 'Error in Game.createPlayer. Player already created!';

		this._player = player;
		return [ player, null ];
	}



	//PRIVATE

	private function _calculateDelta():Void
	{
		this._delta = 1000 / this._fps;
		this._doubleDelta = this._delta * 2;
	}

	private function _checkForSave():Dynamic
	{
		return null;
	}

	private function _tick():Void
	{
		this._currentTime = Date.now().getTime();
		var delta:Float = this._currentTime - this._lastTime;

		if ( delta >= this._delta ){
			if( delta >= this._doubleDelta ){
				delta = this._doubleDelta; // Защита от скачков времени вперед.
			}
			this._update( delta );
			this._lastTime = this._currentTime;	
		}
		this._sUpdate(); // special update; обновление дейсвтий мыши на графические объкты.
	}

	private function _update( time:Float ):Void
	{
		if( !this._onPause )
		{
			//this._sceneSystem.update( time );
		}
	}

	private function _sUpdate():Void
	{

	}

	private function _parseData():Deploy.DeployConfig
	{
		var window:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployWindow.json" );
		var windowMap:Map<Int, WindowDeploy> = new Map<Int, WindowDeploy>();
		for( key in Reflect.fields( window ) )
		{
			var intKey:Int = Std.parseInt( key );
			windowMap[ intKey ] = WindowDeploy( Reflect.getProperty( window, key ) );

		}

		var button:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployButton.json" );
		var buttonMap:Map<Int, ButtonDeploy> = new Map<Int, ButtonDeploy>();
		for( key in Reflect.fields( button ) )
		{
			var intKey:Int = Std.parseInt( key );
			buttonMap[ intKey ] = ButtonDeploy( Reflect.getProperty( button, key ) );

		}

		var scene:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployScene.json" );
		var sceneMap:Map<Int, SceneDeploy> = new Map<Int, SceneDeploy>();
		for( key in Reflect.fields( scene ) )
		{
			var intKey:Int = Std.parseInt( key );
			sceneMap[ intKey ] = SceneDeploy( Reflect.getProperty( scene, key ) );

		}

		var building:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployBuilding.json" );
		var buildingMap:Map<Int, BuildingDeploy> = new Map<Int, BuildingDeploy>();
		for( key in Reflect.fields( building ) )
		{
			var intKey:Int = Std.parseInt( key );
			buildingMap[ intKey ] = SceneDeploy( Reflect.getProperty( building, key ) );

		}

		var hero:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployHero.json" );
		var heroMap:Map<Int, HeroDeploy> = new Map<Int, HeroDeploy>();
		for( key in Reflect.fields( hero ) )
		{
			var intKey:Int = Std.parseInt( key );
			heroMap[ intKey ] = SceneDeploy( Reflect.getProperty( hero, key ) );

		}

		var item:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployItem.json" );
		var itemMap:Map<Int, ItemDeploy> = new Map<Int, ItemDeploy>();
		for( key in Reflect.fields( item ) )
		{
			var intKey:Int = Std.parseInt( key );
			itemMap[ intKey ] = SceneDeploy( Reflect.getProperty( item, key ) );

		}

		var enemy:Dynamic = ConfigJSON.json( "c:/projects/DgrayDungeon/Source/DeployEnemy.json" );
		var enemyMap:Map<Int, EnemyDeploy> = new Map<Int, EnemyDeploy>();
		for( key in Reflect.fields( enemy ) )
		{
			var intKey:Int = Std.parseInt( key );
			enemyMap[ intKey ] = SceneDeploy( Reflect.getProperty( enemy, key ) );

		}

		var player:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployPlayer.json" );
		var playerMap:Map<Int, PlayerDeploy> = new Map<Int, PlayerDeploy>();
		for( key in Reflect.fields( player ) )
		{
			var intKey:Int = Std.parseInt( key );
			playerMap[ intKey ] = SceneDeploy( Reflect.getProperty( player, key ) );

		}

		return { Window:windowMap, Button:buttonMap, Scene:sceneMap, Building:buildingMap, Hero:heroMap, Item:itemMap, Enemy:enemyMap, Player:playerMap };
	}

	private function _mapJsonObject( newObject:Dynamic, oldObject:Dynamic ):Void
	{
		
	}

	private function _startGame():Void
	{
		this._gameStart = Date.now().getTime();
		this._calculateDelta();
		this._lastTime = 0.0;

		this._lastSave = this._checkForSave();

		var createScene:Array<Dynamic> = this._generatorSystem.createScene( 1000 );
		var scene:Scene = createScene[ 0 ];
		var err:String = createScene[ 1 ];
		if( err != null )
			throw 'Error in Game._startGame. $err';

		this._sceneSystem.addScene( scene );
		this._sceneSystem.prepareScene( scene );
		this._sceneSystem.changeSceneTo( scene );

		this.start();
	}
}