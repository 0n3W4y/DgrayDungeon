package;

typedef DeployConfig =
{
	var Window:Map<Int, Dynamic>;
	var Button:Map<Int, Dynamic>;
	var Scene:Map<Int, Dynamic>;
	var Building:Map<Int, Dynamic>;
	var Hero:Map<Int, Dynamic>; 
	var Item:Map<Int, Dynamic>;
	var Enemy:Map<Int, Dynamic>;
	var Player:Map<Int, Dynamic>;
}

class Deploy
{
	public var player:Map<Int, Dynamic>;
	public var scene:Map<Int, Dynamic>;
	public var hero:Map<Int, Dynamic>;
	public var building:Map<Int, Dynamic>;
	public var enemy:Map<Int, Dynamic>;
	public var window:Map<Int, Dynamic>;
	public var button:Map<Int, Dynamic>;
	public var item:MAp<Int, Dynamic>;

	public inline function new( config:DeployConfig ):Void
	{
		this.player = config.Player;
		this.scene = config.Scene;
		this.window = config.Window;
		this.button = config.Button;
		this.building = config.Building;
		this.hero = config.Hero;
		this.item = config.Item;
		this.enemy = config.Enemy;
	}

	public function init():String
	{
		
		if( this.scene == null || !this.scene.exists( 1000 ) )
			return 'Error in Deploy.init. Scene deploy is not valid';
		
		
		if( this._buildingDeploy == null )
			return 'Error in Deploy.init. Building deploy is not valid';
		
		
		if( this._windowDeploy == null )
			return 'Error in Deploy.init. Window deploy is not valid';
		
		
		if( this._buttonDeploy == null )
			return 'Error in Deploy.init. Button deploy is not valid';
		
		
		if( this._heroDeploy == null )
			return 'Error in Deploy.init. Hero deploy is not valid';
		
		
		if( this._itemDeploy == null )
			return 'Error in Deploy.init. Item deploy is not valid';

		//TODO: добавить дополнительные провеки на deploy.
		
		return null;
	}
}