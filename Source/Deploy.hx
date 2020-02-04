package;


enum WindowDeploy
{
	WindowDeploy( _:Dynamic );
}

enum ButtonDeploy
{
	ButtonDeploy( _:Dynamic );
}

enum PlayerDeploy
{
	PlayerDeploy( _:Dynamic );
}

enum SceneDeploy
{
	SceneDeploy( _:Dynamic );
}

enum ItemDeploy
{
	ItemDeploy( _:Dynamic );
}

enum BuildingDeploy
{
	BuildingDeploy( _:Dynamic );
}

enum EnemyDeploy
{
	EnemyDeploy( _:Dynamic );
}

enum HeroDeploy
{
	HeroDeploy( _:Dynamic );
}


typedef DeployConfig =
{
	var Window:Map<Int, WindowDeploy>;
	var Button:Map<Int, ButtonDeploy>;
	var Scene:Map<Int, SceneDeploy>;
	var Building:Map<Int, BuildingDeploy>;
	var Hero:Map<Int, HeroDeploy>; 
	var Item:Map<Int, ItemDeploy>;
	var Enemy:Map<Int, EnemyDeploy>;
	var Player:Map<Int, PlayerDeploy>;
}

class Deploy
{
	private var _player:Map<Int, PlayerDeploy>;
	private var _scene:Map<Int, SceneDeploy>;
	private var _hero:Map<Int, HeroDeploy>;
	private var _building:Map<Int, BuildingDeploy>;
	private var _enemy:Map<Int, EnemyDeploy>;
	private var _window:Map<Int, WindowDeploy>;
	private var _button:Map<Int, ButtonDeploy>;
	private var _item:Map<Int, ItemDeploy>;

	public inline function new( config:DeployConfig ):Void
	{
		this._player = config.Player;
		this._scene = config.Scene;
		this._window = config.Window;
		this._button = config.Button;
		this._building = config.Building;
		this._hero = config.Hero;
		this._item = config.Item;
		this._enemy = config.Enemy;
	}

	public function init():String
	{
		
		if( !this.scene.exists( 1000 ) )
			return 'Error in Deploy.init. Scene deploy is not valid';		
		
		if( this._building == null )
			return 'Error in Deploy.init. Building deploy is not valid';		
		
		if( this._hero == null )
			return 'Error in Deploy.init. Hero deploy is not valid';		
		
		if( this._item == null )
			return 'Error in Deploy.init. Item deploy is not valid';

		if( !this._button.exists( 4000 ) )
			return 'Error in UserInterface.init. Button deploy config is not valid!';

		if( !this._window.exists( 3000 ) )
			return 'Error in UserInterface.init. Window deploy config is not valid!';

		//TODO: добавить дополнительные провеки на deploy.
		
		return null;
	}

	public function get( type:String , deployId:Int ):Dynamic
	{
		switch( type )
		{
			case "window":
			{
				if( this._window.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';

				return this._window[ deployId ];
			}
			case "button":
			{
				if( this._button.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._button[ deployId ];
			}
			case "hero":
			{
				if( this._hero.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._hero[ deployId ];
			}
			case "player":
			{
				if( this._player.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._player[ deployId ];
			}
			case "scene":
			{
				if( this._scene.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._scene[ deployId ];
			}
			case "Building":
			{
				if( this._building.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._building[ deployId ];
			}
			case "item":
			{
				if( this._item.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._item[ deployId ];
			}
			case "enemy":
			{
				if( this._enemy.exists( deployId ) )
					throw 'Error in Deploy.get. Wrong deploy id for "$type" and deploy id: "$deployId"';
				
				return this._enemy[ deployId ];
			}
			default: throw 'Error in Deploy.get. Wrong type, type can not be: "$type"';
		}
	}
}