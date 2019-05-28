package;

import haxe.Timer;

class Game
{
	private var _entitySystem:EntitySystem;
	private var _sceneSystem:SceneSystem;
	private var _graphicsSystem:GraphicsSystem;
	private var _timeSystem:TimeSystem;

	private var _date:Date;
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

	private function _calculateTimeParams():Void
	{
		_delta = 1000 / _fps;
		_doubleDelta = _delta * 2;
	}

	private function _tick():Void
	{
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
		if( !_onPause )
		{
			trace( "tick" );
		}
	}




	public function new( width:Int, height:Int, fps:Int ):Void
	{
		_entitySystem = new EntitySystem( this );
		_sceneSystem = new SceneSystem( this );
		_graphicsSystem = new GraphicsSystem( this );
		_calculateTimeParams();
		start();
	}

	public function start():Void
	{
		if( !_loopStartTime )
			_loopStartTime = Date.now().getTime();
		
		var time = Std.int( Math.ffloor( _delta ) );

		_mainLoop = new Timer( time );
		_mainLoop.run = _tick;
		_lastTime = _loopStartTime;
	}

	public function stop():Void
	{
		_mainLoop.stop();
	}

	public function pause():Void
	{
		if( _onPause )
		{
			_onPause = false;
		}
		else
		{
			_onPause = true;
		}
	}

	public function changeFpsTo( fps:Int ):Void
	{

		_fps = fps;
		_calculateTimeParams();


	}

	




}