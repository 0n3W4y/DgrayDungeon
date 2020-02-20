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
	var ItemInventoryMaxSlots:Int;
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
	private var _itemInventory:Array<Slot>; // Инвентарь, котоырй будет использовтаь игрок во время боевых сцен. Так же он досутпен будет, для подготовки к боевой сцены.
	private var _itemInventoryMaxSlots:Int;

	public inline function new( config:PlayerConfig ):Void
	{
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._moneyAmount = config.MoneyAmount;
		this._inventory = new InventorySystem({ Parent:this });
		this._itemInventoryMaxSlots = config.ItemInventoryMaxSlots;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in Player.init. Name "$_name" id "$_id" deploy id "$_deployId"';
		this._type = "player";
		this._itemInventory = new Array<Slot>();
			// заполняем инвентарь
		for( i in 0...this._itemInventoryMaxSlots )
		{
			this._itemInventory.push({ Type:"none", Item:null, Restriction:"none", Available:true });
		}

		if( this._name == null || this._name == "" )
			throw '$err. Wrong name';

		if( this._id == null )
			throw '$err. Wrong ID';

		if( this._deployId == null )
			throw '$err. Wrong Deploy ID';

		if( this._moneyAmount == null )
			throw '$err. Wrong money amount';

		if( this._itemInventoryMaxSlots < 0 || this._itemInventoryMaxSlots == null )
			throw '$err. Wrong Maximum item slots';

		this._inventory.init( err );
	}

	public function postInit():Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "inventory": return this._inventory;
			case "itemInventory": return this._itemInventory;
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
