package;

import haxe.Timer;
import openfl.system.System;
import openfl.display.Sprite;

class Game
{
	private var _mainSprite:Sprite;
	private var _worldSprite:Sprite;
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
		this._eventHandler.update();
	}

	private function _parseData():Array<Dynamic>
	{
		var window:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployWindow.json" );
		var button:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployButton.json" );
		var scene:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployScene.json" );
		var building:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployBuilding.json" );
		var hero:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployHero.json" );
		var item:Dynamic = ConfigJSON.json( "C:/projects/DgrayDungeon/Source/DeployItem.json" );
		//var enemy:Dynamic = ConfigJSON.json( "c:/projects/DgrayDungeon/Source/DeployEnemy.json" );
		
		return [ window, button, scene, building, hero, item ];
	}

	private function _mapJsonObject( object:Dynamic ):Map<Int, Dynamic>
	{
		var result:Map<Int, Dynamic> = new Map<Int, Dynamic>();

		for( key in Reflect.fields( object ) )
		{
			var intKey:Int = Std.parseInt( key );
			result[ intKey ] = Reflect.getProperty( object, key );

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
		this._worldSprite = new Sprite();
		this._uiSprite = new Sprite();
		this._mainSprite.addChild( this._worldSprite );
		this._mainSprite.addChild( this._uiSprite );

		var parseDataContainer:Array<Dynamic> = this._parseData();

		var windowDeploy:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[0] );
		var buttonDeploy:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[1] );
		var sceneDeploy:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[2] );
		var buildingDeploy:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[3] );
		var heroDeploy:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[4] );
		var itemDeploy:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[5] );
		//var enemyDeployMap:Map<Int, Dynamic> = this._mapJsonObject( parseDataContainer[6] );

		this._eventHandler = new EventHandler();
		this._eventHandler.preInit();
		var err = this._eventHandler.init( this );
		if( err != "ok" )
			throw "Error in Game.new. " + err;

		this._generatorSystem = new GeneratorSystem();
		this._generatorSystem.preInit();
		err = this._generatorSystem.init( this, sceneDeploy, buildingDeploy, windowDeploy, buttonDeploy, heroDeploy, itemDeploy  );
		if( err != "ok" )
			throw "Error in Game.new. " + err;

		


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
			case "generator" : return this._generatorSystem;
			//case "graphics": return this._graphicsSystem;
			//case "scene": return this._sceneSystem;
			case "event": return this._eventHandler;
			//case "ui": return this._userInterface;
			default: trace( "Error in Game.getSystem; system can't be: " + system );
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