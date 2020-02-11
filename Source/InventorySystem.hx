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
}

class InventorySystem
{
	private var _parent:Dynamic;
	private var _inventoryName:String;

	public inline function new( config:InventorySystemConfig ):Void
	{
		this._parent = config.Parent;
		this._inventoryName = config.InventoryName;
	}

	public function init():String
	{
		if( this._parent == null || this._parent == '' )
			return 'Error in InventorySystem.init. Parent is wrong';

		if( this._inventoryName == null )
			return 'Error in InventorySystem.init. Inventory name is null!';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function addToInventory( item:Item ):Void
	{

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
		var inventory:Array<Slot> = this.inventory();
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
		var inventory:Array<Slot> = this.inventory();
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

	private function _addAmountItemInSlot( item:Item, slot:Slot ):Int
	{
		return 0;
	}

	private function _withdrawAmountItemFromSlot( item:Item, slot:Slot ):Int
	{
		return 0;
	}

	private inline function inventory():Array<Slot>
	{
		return this._parent.get( this._inventoryName );
	}
}