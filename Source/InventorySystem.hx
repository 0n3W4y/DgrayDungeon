package;

import Item;

typedef InventorySystemConfig =
{
	var Parent:Dynamic;
	var Inventory:Array<Slot>;
	var MaxSlots:Int;
	var Slots:Int;
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
	private var _inventory:Array<Slot>;
	private var _inventorySlots:Int;
	private var _inventorySlotsMax:Int;

	public inline function new():Void
	{
		
	}

	public function init( config:InventorySystemConfig ):String
	{
		this._parent = config.Parent;
		this._inventory = config.Inventory;
		this._inventorySlots = config.Slots;
		this._inventorySlotsMax = config.MaxSlots;

		if( this._parent == null || this._parent == '' )
			return 'Error in InventorySystem.init. Parent is wrong';

		if( this._inventory == null )
			return 'Error in InventorySystem.init. Inventory Array is null!';

		if( this._inventorySlots == null )
			return 'Error in InventorySystem.init. Inventory Slots are null!';

		if( this._inventorySlotsMax == null )
			return 'Error in InventorySystem.init. Inventory Slots Max are null!';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function addToInventory( item:Item ):Void
	{
		this._inventorySlots ++;
	}

	public function removeFromInventory( item:Item ):Item
	{
		var index:Int = 0;
		this._inventory[ index ].Item = null;
		this._inventorySlots--;
		return item;
	}

	//PRIVATE

	private function _checkDuplicate( item:Item ):Int // находит дубликат по уникальному ID. Если есть совпадение - то лучше вывести ошибку и остановить приложение.
	{
		var id:ItemID = item.get( "id" );
		for( i in 0...this._inventory.length )
		{
			var oldItem:Item = this._inventory[ i ].Item;
			if( oldItem == null )
				continue;

			if( haxe.EnumTools.EnumValueTools.equals( id, oldItem.get( "id" )))
				return i;
		}

		return null;
	}

	private function _findFreeSlotForItem( item:Item ):Int
	{
		for( i in 0...this._inventory.length )
		{
			var oldItem:Item = this._inventory[ i ].Item;
			if( oldItem != null )
				continue;

			var slot:Slot = this._inventory[ i ];
			if( this._checkTypeBetweenItemAndSlot( item, slot ) && this._checkRestrictionBetweenItemAndSlot( item, slot ) )
				return i;
		}

		return null;
	}

	private function _checkTypeBetweenItemAndSlot( item:Item, slot:Slot ):Bool
	{
		var itemType:String = item.get( "type" );
		var slotType:String = slot.Type;
		if( itemType == slotType )
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

	private function _storeItemInSlot( item:Item, slot:Slot ):Int
	{
		return 0;
	}

	private function _substractAmountItemFromSlot( item:Item, slot:Slot ):Int
	{
		return 0;
	}
}