package;

import InventorySystem;

enum PlayerID
{
	PlayerID( _:Int );
}

enum PlayerDeployID
{
	PlayerDeployID( _:Int );
}

typedef Money = Int;

typedef PlayerConfig =
{
	var ID:PlayerID;
	var DeployID:PlayerDeployID;
	var Name:String;
	var InventoryStorageSlotsMax:Int;
	var BattleInventoryStorageSlotsMax:Int;
	var MoneyAmount:Money;
}

class Player
{
	private var _id:PlayerID;
	private var _name:String;
	private var _deployId:PlayerDeployID;
	private var _moneyAmount:Money;

	private var _inventory:InventorySystem;
	private var _inventoryStorage:Array<Slot>;
	private var _inventoryStorageMaxSlots:Int;
	private var _battleInventory:InventorySystem;
	private var _battleInventoryStorage:Array<Slot>;
	private var _battleInventoryStorageMaxSlots

	public inline function new( config:PlayerConfig ):Void
	{
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._moneyAmount = config.MoneyAmount;
		this._inventory = new InventorySystem({ Parent:this, InventoryName: "inventoryStorage" });
		this._inventoryStorageMaxSlots = config.InventoryStorageSlotsMax;
		this._battleInventory = new InventorySystem({ Parent:this, InventoryName: "battleInventoryStorage" });
		this._battleInventoryStorageMaxSlots = config.BattleInventoryStorageSlotsMax
	}

	public function init():String
	{
		if( this._name == null || this._name == "" )
			return 'Error in Player.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._id == null )
			return 'Error in Player.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null )
			return 'Error in Player.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._moneyAmount == null )
			return 'Error in Player.init.Wrong money amount. Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		if( this._inventoryStorageMaxSlots < 0 || this._inventoryStorageMaxSlots == null )
			return 'Error in Player.init. Wrong Maximum item slots. Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		if( this._battleInventoryStorageMaxSlots < 0 || this._battleInventoryStorageMaxSlots == null )
			return 'Error in Player.init. Wrong Maximum slots in battle item storage . Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		this._itemStorage = new Array<Slot>();
		this._battleItemStorage = new Array<Slot>();

		for( i in 0...this._inventoryStorageMaxSlots )
		{
			this._inventoryStorage.push({ Type: "any", Item: null, Restriction: "none" });
		}

		for( j in 0...this._battleInventoryStorageMaxSlots )
		{
			this._battleInventoryStorage.push({ Type: "any", Item: null, Restriction: "none" });
		}

		var err:String = this._inventory.init();
		if( err != null )
			return 'Error in Player.Init. Inventory Error. Name: "$_name" id: "$_id"  deploy id: "$_deployId". $err';

		err = this._battleInventory.init();
		if( err != null )
			return 'Error in Player.Init. Battle Inventory Error. Name: "$_name" id: "$_id"  deploy id: "$_deployId". $err';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function checkItemStorageForFreeSlots():Bool
	{
		if( this._itemStorageSlots < this._itemStorageSlotsMax )
			return true;

		return false;
	}

	public function addItemToStorage( item:Item ):Void
	{
		if( !this.checkItemStorageForFreeSlots() )
			return;
		//TODO: Сделать проверку на предмет того, можно ли "сложить" количество объектов. Будет решено после появления самих предметов.
		var name:String = item.get( "name" );
		var id:Item.ItemID = item.get( "id" );
		var check:Int = this._checkItemInStorage( id );
		if( check != null )
			throw 'Error in Player.addItemToStorage. Found duplicate item with name:"$name" id:"$id"';

		this._itemStorage.push( item );
		this._itemStorageSlots++;
	}

	public function removeItemFromStorage( item:Item ):Array<Dynamic>
	{
		var name:String = item.get( "name" );
		var id:Item.ItemID = item.get( "id" );
		var check:Int = this._checkItemInStorage( id );
		if( check == null )
			return [ null, 'Error in Player.removeItemFromStorage. Item with name:"$name" id:"$id" does not exist' ];

		this._itemStorage.splice( check, 1 );
		this._itemStorageSlots--;
		return [ item, null ];
	}

	public function getItemFromStorageById( id:Item.ItemID ):Array<Dynamic>
	{
		var check:Int = this._checkItemInStorage( id );
		if( check == null )
			return [ null, 'Error in Player.getHeroById. Hero with id:"$id" does not exist' ];

		return [ this._itemStorage[ check ], null ];
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "inventory": return this._inventory;
			case "battleInventory": return this._battleInventory;
			case "inventoryStorage": return this._inventoryStorage;
			case "battleInventoryStorage": return this._battleInventoryStorage;
			default: throw 'Error in Player.get. Not valid value: "$value"';
		}
	}



	//PRIVATE


	private function _checkItemInStorage( id:Item.ItemID ):Int
	{
		for( i in 0...this._itemStorage.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( this._itemStorage[ i ].get( "id" ), id ) )
				return i;
		}
		return null;
	}
}