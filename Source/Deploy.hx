package;

import Window;
import Player;
import Button;
import Building;
import Hero;
import Enemy;
import Scene;
import Item;

typedef DeployConfig =
{
	var Window:Dynamic;
	var Button:Dynamic;
	var Scene:Dynamic;
	var Building:Dynamic;
	var Hero:Dynamic;
	var Item:Dynamic;
	var Enemy:Dynamic;
	var Player:Dynamic;
	var System:Dynamic;
}

enum SystemDeployID
{
	SystemDeployID( _:Int );
}

class Deploy
{
	private var _player:Map<PlayerDeployID, Dynamic>;
	private var _scene:Map<SceneDeployID, Dynamic>;
	private var _hero:Map<HeroDeployID, Dynamic>;
	private var _building:Map<BuildingDeployID, Dynamic>;
	private var _enemy:Map<EnemyDeployID, Dynamic>;
	private var _window:Map<WindowDeployID, Dynamic>;
	private var _button:Map<ButtonDeployID, Dynamic>;
	private var _item:Map<ItemDeployID, Dynamic>;
	private var _system:Map<SystemDeployID, Dynamic>;

	public inline function new( config:DeployConfig ):Void
	{
		this._player = new Map<PlayerDeployID, Dynamic>();
		for( key in Reflect.fields( config.Player ))
		{
			var intKey:Int = Std.parseInt( key );
			this._player[ PlayerDeployID( intKey )] = Reflect.getProperty( config.Player, key );
		}

		this._scene = new Map<SceneDeployID, Dynamic>();
		for( key in Reflect.fields( config.Scene ))
		{
			var intKey:Int = Std.parseInt( key );
			this._scene[ SceneDeployID( intKey )] = Reflect.getProperty( config.Scene, key );
		}

		this._hero = new Map<HeroDeployID, Dynamic>();
		for( key in Reflect.fields( config.Hero ))
		{
			var intKey:Int = Std.parseInt( key );
			this._hero[ HeroDeployID( intKey )] = Reflect.getProperty( config.Hero, key );
		}

		this._building = new Map<BuildingDeployID, Dynamic>();
		for( key in Reflect.fields( config.Building ))
		{
			var intKey:Int = Std.parseInt( key );
			this._building[ BuildingDeployID( intKey )] = Reflect.getProperty( config.Building, key );
		}

		this._enemy = new Map<EnemyDeployID, Dynamic>();
		for( key in Reflect.fields( config.Enemy ))
		{
			var intKey:Int = Std.parseInt( key );
			this._enemy[ EnemyDeployID( intKey )] = Reflect.getProperty( config.Enemy, key );
		}

		this._window = new Map<WindowDeployID, Dynamic>();
		for( key in Reflect.fields( config.Window ))
		{
			var intKey:Int = Std.parseInt( key );
			this._window[ WindowDeployID( intKey )] = Reflect.getProperty( config.Window, key );
		}

		this._button = new Map<ButtonDeployID, Dynamic>();
		for( key in Reflect.fields( config.Button ))
		{
			var intKey:Int = Std.parseInt( key );
			this._button[ ButtonDeployID( intKey )] = Reflect.getProperty( config.Button, key );
		}

		this._item = new Map<ItemDeployID, Dynamic>();
		for( key in Reflect.fields( config.Item ))
		{
			var intKey:Int = Std.parseInt( key );
			this._item[ ItemDeployID( intKey )] = Reflect.getProperty( config.Item, key );
		}

		this._system = new Map<SystemDeployID, Dynamic>();
		for( key in Reflect.fields( config.System ))
		{
			var intKey:Int = Std.parseInt( key );
			this._system[ SystemDeployID( intKey )] = Reflect.getProperty( config.System, key );
		}
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in Deploy.init';
		if( !this._scene.exists( SceneDeployID( 1000 )))
			throw '$err. Scene deploy is not valid';

		if( this._building == null )
			throw '$err. Building deploy is not valid';

		if( this._hero == null )
			throw '$err. Hero deploy is not valid';

		if( this._item == null )
			throw '$err. Item deploy is not valid';

		if( !this._button.exists( ButtonDeployID( 4000 )))
			throw '$err. Button deploy config is not valid!';

		if( !this._window.exists( WindowDeployID( 3000 )))
			throw '$err. Window deploy config is not valid!';

		if( !this._system.exists( SystemDeployID( 10 )))
			throw '$err. System deploy config is not valid!';

		//TODO: добавить дополнительные провеки на deploy.
	}

	public function getDeploy( value:String ):Dynamic
	{
		switch( value )
		{
			case "player": return this._player;
			case "hero": return this._hero;
			case "item": return this._item;
			default: throw 'Error in Deploy.getDeploy. Can not get $value';
		}
	}

	public function getWindow( deployId:Window.WindowDeployID ):Dynamic
	{
		if( !this._window.exists( deployId ) )
			throw 'Error in Deploy.getWindow. Wrong deploy id: "$deployId"';

		return this._window[ deployId ];
	}

	public function getButton( deployId:Button.ButtonDeployID ):Dynamic
	{
		if( !this._button.exists( deployId ) )
			throw 'Error in Deploy.getButton. Wrong deploy id: "$deployId"';

		return this._button[ deployId ];
	}

	public function getHero( deployId:Hero.HeroDeployID ):Dynamic
	{
		if( !this._hero.exists( deployId ) )
			throw 'Error in Deploy.getHero. Wrong deploy id: "$deployId"';

		return this._hero[ deployId ];
	}

	public function getPlayer( deployId:Player.PlayerDeployID ):Dynamic
	{
		if( !this._player.exists( deployId ) )
			throw 'Error in Deploy.getPlayer. Wrong deploy id: "$deployId"';

		return this._player[ deployId ];
	}

	public function getScene( deployId:Scene.SceneDeployID ):Dynamic
	{
		if( !this._scene.exists( deployId ) )
			throw 'Error in Deploy.getScene. Wrong deploy id: "$deployId"';

		return this._scene[ deployId ];
	}

	public function getBuilding( deployId:Building.BuildingDeployID ):Dynamic
	{
		if( !this._building.exists( deployId ) )
			throw 'Error in Deploy.getBuilding. Wrong deploy id: "$deployId"';

		return this._building[ deployId ];
	}

	public function getItem( deployId:Item.ItemDeployID ):Dynamic
	{
		if( !this._item.exists( deployId ) )
			throw 'Error in Deploy.getItem. Wrong deploy id: "$deployId"';

		return this._item[ deployId ];
	}

	public function getEnemy( deployId:Enemy.EnemyDeployID ):Dynamic
	{
		if( !this._enemy.exists( deployId ) )
			throw 'Error in Deploy.getEnemy. Wrong deploy id: "$deployId"';

		return this._enemy[ deployId ];
	}

	public function getSystem( deployId:SystemDeployID ):Dynamic
	{
		if( !this._system.exists( deployId ) )
			throw 'Error in Deploy.getSystem. Wrong deploy id: "$deployId"';

		return this._system[ deployId ];
	}
}
