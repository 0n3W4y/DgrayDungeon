package;


import Item;

class ItemSystem
{

	var _parent:Game;
	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in ItemSystem.init';
	}

	public function generateItem( name:String, itemType:String, rarity:String ):Item
	{
		return null;
	}

	public function createItem( deployId:ItemDeployID ):Item
	{
		var config:Dynamic = this._parent.getSystem( "deploy" ).getItem( deployId );

		var itemConfig:ItemConfig =
		{
			Name: config.name;
			
		}

		return null;
	}

	public function generateStatsForItem ( item:Item ):Void
	{

	}
}
