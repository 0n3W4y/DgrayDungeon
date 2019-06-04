package;

import openfl.display.Sprite;
import haxe.Timer;

class Game
{
	private var _enterSprite:Sprite;
	private var _mainSprite:Sprite;
	private var _entitySystem:EntitySystem;
	private var _sceneSystem:SceneSystem;
	private var _graphicsSystem:GraphicsSystem;
	private var _userInterface:UserInterface;
	private var _eventSystem:EventSystem;

	private var _gameStart:Float;
	private var _loopStartTime:Float;

	private var _onPause:Bool = false;

	private var _width:Int;
	private var _height:Int;

	private var _fps:Int;
	private var _mainLoop:Timer;
	private var _currentTime:Float;
	private var _lastTime:Float;
	private var _delta:Float;
	private var _doubleDelta:Float;

	private function _calculateDelta():Void
	{
		this._delta = 1000 / this._fps;
		this._doubleDelta = this._delta * 2;
	}

	private function _tick():Void
	{
		//TODO: mathemathic tick with minimum time, graphics tick like FPS says;
		this._currentTime = Date.now().getTime();
		var delta = this._currentTime - this._lastTime;

		if ( delta >= this._delta ){
			if( delta >= this._doubleDelta ){
				delta = this._doubleDelta;
			}

			this._update( delta );
			this._lastTime = this._currentTime;
		}
	}

	private function _update( time:Float ):Void
	{
		if( !this._onPause )
		{
			trace( "tick" );
			//this._sceneSystem.update( time );
		}
	}

	private function _parseData():Dynamic
	{
		var conf = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/data.json" );
		return conf;
	}

	private function _startGame():Void
	{
		var scene = this._sceneSystem.createScene( "startScene" );
		this._sceneSystem.doActiveScene( scene );
		this.start();
	}




	public function new( width:Int, height:Int, fps:Int, mainSprite:Sprite ):Void
	{
		var config = this._parseData();
		this._entitySystem = new EntitySystem( this, config.entity );
		this._sceneSystem = new SceneSystem( this, config.scene );
		this._graphicsSystem = new GraphicsSystem( this );
		this._userInterface = new UserInterface( this );
		this._eventSystem = new EventSystem( this );
		this._enterSprite = mainSprite;

		this._mainSprite = new Sprite();
		mainSprite.addChild( this._mainSprite );
		mainSprite.addChild( this._userInterface );

		this._calculateDelta();
		this._gameStart = Date.now().getTime();
		this._startGame();
		
		
	}

	public function start():Void
	{
		var time = Std.int( Math.ffloor( this._delta ) );

		this._mainLoop = new Timer( time );
		this._mainLoop.run = _tick;
		this._lastTime = Date.now().getTime();
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
			case "entity" : return this._entitySystem;
			case "graphics": return this._graphicsSystem;
			case "scene": return this._sceneSystem;
			case "event": return this._eventSystem;
			case "ui": return this._userInterface;
			default: trace( "error in Game.getSystem; system can't be: " + system + "." );
		}
		return null;
	}

	public function getMainSprite():Sprite
	{
		return this._mainSprite;
	}
}