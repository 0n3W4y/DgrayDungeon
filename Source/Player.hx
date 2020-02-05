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
	var ItemStorageSlotsMax:Int;
	var BattleItemStorageSlotsMax:Int;
	var MoneyAmount:Money;
}

class Player
{
	private var _id:PlayerID;
	private var _name:String;
	private var _deployId:PlayerDeployID;
	private var _moneyAmount:Money;

	private var _itemStorage:Array<Item>; // Никаких ограничений, если предмет является классом Item, его можно запихнуть сюда. Это инвентарь игрока.
	private var _itemStorageSlotsMax:Int;
	private var _itemStorageSlots:Int;

	private var _battleItemStorage:Array<Slot>; // данный инвентарь имееет ограничение по количеству слотов. 
	private var _battleItemStorageSlots:Int;
	private var _battleItemStorageSlotsMax:Int;

	private var _inventory:InventorySystem;

	public inline function new( config:PlayerConfig ):Void
	{
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._moneyAmount = config.MoneyAmount;
		this._itemStorageSlotsMax = config.ItemStorageSlotsMax;
		this._battleItemStorageSlotsMax = config.BattleItemStorageSlotsMax;
		this._inventory = new InventorySystem();
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

		if( this._itemStorageSlotsMax < 0 )
			return 'Error in Player.init. Wrong Maximum item slots. Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		if( this._battleItemStorageSlotsMax < 0 )
			return 'Error in Player.init. Wrong item in battle storage Maximum slots. Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		this._itemStorageSlots = 0;
		this._battleItemStorageSlots = 0;
		this._heroStorage = new Array<Slot>();
		this._battleItemStorage = new Array<Slot>();
		var err:String = this.inventory.init( { Parent:this, Inventory:this._battleItemStorage, MaxSlots:this._battleItemStorageSlotsMax, Slots:this._battleItemStorageSlots } );
		if( err != null )
			return 'Error in Player.Init. Name: "$_name" id: "$_id"  deploy id: "$_deployId". $err';

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
		if( !this.checkItemStorageForFreeSlots )
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
		return [ hero, null ];
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
			case "inventory" :return this._inventory;
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