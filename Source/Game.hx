package;

import haxe.Timer;
import openfl.system.System;
import openfl.display.Sprite;

class Game
{
	private var _mainSprite:Sprite;
	private var _scenesSprite:Sprite;
	private var _uiSprite:Sprite;

	private var _width:Int;
	private var _height:Int;
	private var _gameStart:Float;

	private var _eventHandler:EventHandler;
	private var _generatorSystem:GeneratorSystem;

	

	


	private var _onPause:Bool = false;
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
		var delta:Float = this._currentTime - this._lastTime;

		if ( delta >= this._delta ){
			if( delta >= this._doubleDelta ){
				delta = this._doubleDelta;
			}
			this._update( delta );
			this._lastTime = this._currentTime;	
		}
		this._sUpdate();
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
		this._eventHandler.update();
	}

	private function _parseData( url:String ):Map<Int, Dynamic>
	{
		var conf = ConfigJSON.json( url );
		var result:Map<Int, Dynamic> = new Map<Int, Dynamic>();

		for( key in Reflect.fields( conf ) )
		{
			var intKey:Int = Std.parseInt( key );
			result[ intKey ] = Reflect.getProperty( conf, key );

		}
		return result;
	}

	private function _startGame():Void
	{
		this._gameStart = Date.now().getTime();
		this._calculateDelta();
		this._lastTime = 0.0;
	}

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

		this._eventHandler = new EventHandler();
		var err = this._eventHandler.preInit( this );
		if( err != "ok" )
			throw "Error in Game.new. " + err;

		this._generatorSystem = new GeneratorSystem();
		err = this._generatorSystem.preInit( this );
		if( err != "ok" )
			throw "Error in Game.new. " + err;

		var windowDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployWindow.json" );
		var buttonDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployButton.json" );
		var sceneDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployScene.json" );
		var buildingDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployBuilding.json" );
		var heroDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployHero.json" );
		var itemDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployItem.json" );
		//var enemyDeployMap:Map<Int, Dynamic> = this._parseData( "c:/projects/dgraydungeon/source/DeployEnemy.json" );


		this._startGame();
		
		
	}

	public function start():Void
	{
		var time = Std.int( Math.ffloor( this._delta ) );

		this._mainLoop = new Timer( time );
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
/*
		var acc = 70;
        var dmg = [ 10, 12 ];
        var minDmg = dmg[0];
        var maxDmg = dmg[1];
        var damage = null;
        var difDmg = Math.round( (maxDmg - minDmg)*acc/100 );
        var k = 0;
        var l = 0;
        for( i in 0...9 )
            {
                var hitTest = Math.floor(Math.random() * 100 );
                if( hitTest <= acc-1 )
                    k++;
                else
                    l++;     
            }
         if( k > l )
             minDmg += difDmg;
        else
            maxDmg -= difDmg;
        
            
        var random =  Math.floor( minDmg + Math.random() * ( maxDmg - minDmg + 1 ));
*/