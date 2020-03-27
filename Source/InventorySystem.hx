package;

import Item;

typedef InventorySystemConfig =
{
	var Parent:Dynamic;
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
		var err:String = " $error. Error in InventorySystem.init";
		this._inventoryName = "itemInventory"; //constant;
		if( this._parent == null )
			throw '$err. Parent is null';

		if( this._inventory() == null )
			throw '$err. Inventory is null!';

	}

	public function postInit():Void
	{

	}

	public function add( item:Item ):Void
	{
		var itemId:ItemID = item.get( "id" );
		var check:Int = this._checkDuplicate( itemId );
		if( check != null )
			throw 'Error in InventorySystem.add. Can not add item, because it already in "$itemId", "$item.get( "name" )"';

		var slotIndex:Int = this._findSlotForItem( item );
		if( slotIndex == null )
			throw 'Error in InventorySystem.add. Can not add item, because no slot for this item "$itemId", "$item.get( "name" )"';

		var inventory:Array<Slot> = this._inventory();
		if( inventory[ slotIndex ].Item != null )
			throw 'Error in InventorySystem.add. Inventory already have item in this slot "$slotIndex"';

		inventory[ slotIndex ].Item = item;
	}

	public function remove( item:Item ):Item
	{
		var itemId:ItemID = item.get( "id" );
		var check:Int = this._checkDuplicate( itemId );
		if( check == null )
			throw 'Error in InventorySystem.add. Can not remove item, because  item not available in inventory "$itemId", "$item.get( "name" )"';

		var slotIndex:Int = this._findSlotForItem( item );
		if( slotIndex == null )
			throw 'Error in InventorySystem.add. Can not add item, because no slot for this item "$itemId", "$item.get( "name" )"';
	}

	public function getItemById( itemId:ItemID ):Item
	{
		return null;
	}

	//PRIVATE

	private function _checkDuplicate( id:ItemID ):Int // находит дубликат по уникальному ID. Если есть совпадение - то лучше вывести ошибку и остановить приложение.
	{
		var inventory:Array<Slot> = this._inventory();
		for( i in 0...inventory.length )
		{
			var item:Item = inventory[ i ].Item;
			if( item == null )
				continue;

			if( haxe.EnumTools.EnumValueTools.equals( id, item.get( "id" )))
				return i;
		}
		return null;
	}

	private function _findSlotForItem( item:Item ):Int
	{
		var inventory:Array<Slot> = this._inventory();
		for( i in 0...inventory.length )
		{
			var slot:Slot = inventory[ i ];
			var restriction:Bool = this._checkRestrictionBetweenItemAndSlot( item, slot );
			var type:Bool = this._checkTypeBetweenItemAndSlot( item, slot );
			var available:Bool = slot.Available;

			if( restriction && type && available )
				return i;
		}
		return null;
	}

	private function _checkTypeBetweenItemAndSlot( item:Item, slot:Slot ):Bool
	{
		var itemType:String = item.get( "itemType" );
		var slotType:String = slot.Type;
		if( itemType == slotType )
			return true;

		return false;
	}

	private function _checkRestrictionBetweenItemAndSlot( item:Item, slot:Slot ):Bool
	{
		var itemRestriction:Array<String> = item.get( "restriction" );
		var slotRestriction:String = slot.Restriction;
		if( slotRestriction == "none" )
			return true;

		for( i in 0...itemRestriction.length )
		{
			if( slotRestriction == itemRestriction[ i ] )
				return true;
		}

		return false;
	}

	private inline function _inventory():Array<Slot>
	{
		return this._parent.get( this._inventoryName );
	}
}
