package;

import Item;

typedef InventorySystemConfig =
{
	var Parent:Dynamic;
	var InventoryName:String; // название, как получить интвентарь Array, с которым инвентарь должен работать.
}


typedef Slot =
{
	var Type:String;
	var Item:Item;
	var Restriction:String;
	var Available:Bool;
}

class InventorySystem
{
	private var _parent:Dynamic;
	private var _inventoryName:String;

	public inline function new( config:InventorySystemConfig ):Void
	{
		this._parent = config.Parent;

	}

	public function init( error:String ):Void
	{
		var err:String = "Error in InventorySystem.init";
		this._inventoryName = "itemInventory";
		if( this._parent == null )
			throw '$error. $err. Parent is null';

		if( this._inventory() == null )
			throw '$error. $err. Inventory is null!';

	}

	public function postInit():Void
	{

	}

	public function addToInventory( item:Item ):Void
	{
		var itemId:ItemID = item.get( "id" );
		var itemDeployId:ItemDeployID = item.get( "deployId" );
	}

	public function removeFromInventory( item:Item ):Item
	{
		return item;
	}

	public function getItemById( itemId: ItemID ):Item
	{
		return null;
	}

	//PRIVATE

	private function _checkDuplicate( item:Item ):Int // находит дубликат по уникальному ID. Если есть совпадение - то лучше вывести ошибку и остановить приложение.
	{
		var id:ItemID = item.get( "id" );
		var inventory:Array<Slot> = this._inventory();
		for( i in 0...inventory.length )
		{
			var oldItem:Item = inventory[ i ].Item;
			if( oldItem == null )
				continue;

			if( haxe.EnumTools.EnumValueTools.equals( id, oldItem.get( "id" )))
				return i;
		}

		return null;
	}

	private function _findFreeSlotForItem( item:Item ):Int
	{
		var inventory:Array<Slot> = this._inventory();
		for( i in 0...inventory.length )
		{
			var oldItem:Item = inventory[ i ].Item;
			if( oldItem != null )
				continue;

			var slot:Slot = inventory[ i ];
			if( this._checkTypeBetweenItemAndSlot( item, slot ) && this._checkRestrictionBetweenItemAndSlot( item, slot ) )
				return i;
		}

		return null;
	}

	private function _checkTypeBetweenItemAndSlot( item:Item, slot:Slot ):Bool
	{
		var itemType:String = item.get( "name" );
		var slotType:String = slot.Type;
		if( itemType == slotType || slotType == "item" )
			return true;

		return false;
	}

	private function _checkRestrictionBetweenItemAndSlot( item:Item, slot:Slot ):Bool
	{
		var slotRestriction = slot.Restriction;
		if( slotRestriction == "none" )
			return true;

		//var itemRestriction:Array<String> = item.get( "inventoryRestriction" );
		//for( i in 0...itemRestriction.length )
		//{
		//	if( slotRestriction == itemRestriction[ i ] )
		//		return true;
		//}
		//
		return false;
	}

	private inline function _inventory():Array<Slot>
	{
		return this._parent.get( this._inventoryName );
	}
}
