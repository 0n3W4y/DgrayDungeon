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
	private var _type:String;
	private var _moneyAmount:Money;

	private var _inventory:InventorySystem;
	private var _inventoryStorage:Array<Slot>; // Инвентарь, котоырй будет использовтаь игрок во время боевых сцен. Так же он досутпен будет, для подготовки к боевой сцены.
	private var _inventoryStorageMaxSlots:Int;

	public inline function new( config:PlayerConfig ):Void
	{
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._moneyAmount = config.MoneyAmount;
		this._inventory = new InventorySystem({ Parent:this, InventoryName: "inventoryStorage" });
		this._inventoryStorageMaxSlots = config.InventoryStorageSlotsMax;
	}

	public function init( error:String ):Void
	{
		var err:String = 'Name "$_name" id "$_id" deploy id "$_deployId"';
		this._type = "player";
		this._inventoryStorage = new Array<Slot>();

		if( this._name == null || this._name == "" )
			throw '$error Wrong name. $err ';
		
		if( this._id == null )
			throw '$error. Wrong ID. $err';
		
		if( this._deployId == null )
			throw '$error. Wrong Deploy ID. $err';

		if( this._moneyAmount == null )
			throw '$error. Wrong money amount. $err';

		if( this._inventoryStorageMaxSlots < 0 || this._inventoryStorageMaxSlots == null )
			throw '$error. Wrong Maximum item slots. $err';

		for( i in 0...this._inventoryStorageMaxSlots )
		{
			this._inventoryStorage.push({ Type: "item", Item: null, Restriction: "none" });
		}

		this._inventory.init( 'Error in Player.Init. Inventory.init. $err' );
	}

	public function postInit():Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "inventory": return this._inventory;
			case "inventoryStorage": return this._inventoryStorage;
			case "name": return this._name;
			case "deployId": return this._deployId;
			case "id": return this._id;
			case "type": return this._type;
			case "money": return this._moneyAmount;
			default: throw 'Error in Player.get. Not valid value: "$value"';
		}
	}



	//PRIVATE

}