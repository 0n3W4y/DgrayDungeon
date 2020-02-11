package;

import Hero;

class HeroSystem
{
	private var _parent:Game;

	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function init( error:String ):Void
	{
		if( this._parent == null )
			throw '$error. Parent is null!';
	}

	public function postInit( error:String ):Void
	{

	}

	public function createHero( deployId:Int ):Hero
	{
		var heroDeployId:HeroDeployID = DeroDeployID( deployId );

	}
}