package;

typedef Slot = 
{
	var Type:String;
	var Item:Dynamic;
	var Restriction:String;
}

class InventorySystem
{
	private var _parent:Dynamic;
	private var _inventory:Array<Slot>;
	private var _inventorySlots:Int;
	private var _inventorySlotsMax:Int;

	public inline function new( parent:Dynamic ):Void
	{
		this._parent = parent;
	}

	public function init():String
	{
		if( this._parent == null || this._parent == '' )
			return 'Error in InventorySystem.init. Parent is wrong: "$_parent"';

		this._inventory = this._parent.get( "inventoryStorage" );
		this._inventorySlots = this._parent.get( "inventoryStorageSlots" );
		this._inventorySlotsMax = this._parent.get( "inventoryStorageSlotsMax" );
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function addToInventory( item:Item, amount:Int ):Int
	{
		var storable:Bool = item.get( "storable" );
		this._inventorySlots ++;
		return "ok";
	}

	public function removeFromInventory( item:Item, amount:Int ):Item
	{
		this._inventory[ index ].Item = null
		this._inventorySlots--;
		return item;
	}

	//PRIVATE

	private function _checkDuplicate( item:Item ):Int // находит дубликат по уникальному ID. Если есть совпадение - то лучше вывести ошибку и остановить приложение.
	{
		for( i in 0...this._inventory.length )
		{
			var oldItem:Item = this._inventory[ i ].Item;
			if( oldItem == null )
				continue;

			if( item.get( "id" ).match( oldItem.get( "id" ) ) )
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

	private function _substractItemFromSlot( item:Item, slot:Slot ):Int
	{
		return 0;
	}
}