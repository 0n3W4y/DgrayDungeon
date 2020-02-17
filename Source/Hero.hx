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
	var Rarity:String;
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

	private var _status:String;


	public function new():Void
	{
		this._type = "hero";
		this._id = null;
		this._deployId = null;
		this._name = null;
	}

	public function init( error:String ):Void
	{
		var err:String = 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';
		if( this._id == null )
			throw '$error. $err';


		if( this._deployId == null )
			throw '$error. $err';


		if( this._name == null )
			throw '$error. $err';

	}

	public function postInit():Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			case "status": return this._status;
			default: throw 'Error in Hero.get. Can not get $value';
		}
	}

	public function changeStatusTo( value:String ):Void
	{
		switch( value )
		{
			case "":
			default: throw 'Error in Hero.ChangeStatusTo. $value is not valid status';
		}
	}


	//PRIVATE


}
