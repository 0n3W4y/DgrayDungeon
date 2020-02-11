package;

import InventorySystem;

enum HeroID
{
	HeroID( _:Int );
}

enum HeroDeployID
{
	HeroDeployID( _:Int );
}

typedef HeroConfig = 
{
	var ID:HeroID;
	var Name:String;
	var DeployID:HeroDeployID;
}


class Hero
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:HeroID;
	private var _deployId:HeroDeployID;
	private var _name:String;
	private var _type:String;

	private var _inventory:InventorySystem;
	private var _itemInventory:Array<Slot>;
	private var _itemInventorySlotsMax:Int;

	
	public function new():Void
	{
		this._type = "hero";
		this._id = null;
		this._deployId = null;
		this._name = null;
	}

	public function init():String
	{	
		
		if( this._id == null )
			throw 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';

		
		if( this._deployId == null )
			throw 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';

		
		if( this._name == null )
			throw 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			default: throw 'Error in Hero.get. Can not get $value';
		}
	}


	//PRIVATE


}