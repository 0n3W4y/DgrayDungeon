package;

import openfl.display.Sprite;

enum ItemID
{
	ItemID( _:Int );
}

enum ItemDeployID
{
	ItemDeployID( _:Int );
}

class Item
{
	private var _id:ItemID;
	private var _deployId:ItemDeployID;
	private var _type:String;
	private var _itemType:String;
	private var _name:String;

	private var _sprite:Sprite;

	public function new():Void
	{

	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in Item.init. Name "$_name", itemType "$_itemType", deploy id "$_deployId"';
	}

	public function postInit( error:String ):Void
	{
		var err:String = '$error. Error in Item.postInit. Name "$_name", itemType "$_itemType", deploy id "$_deployId"';
	}

	public function get( value:String ):Dynamic
	{
		switch ( value )
		{
			case "id": return this._id;
			case "name": return this._name;
			case "type": return this._type;
			case "itemType": return this._itemType;
			case "sprite": return this._sprite;
			default: throw 'Error in Item.get. No case for "$value"';
		}
	}
}
