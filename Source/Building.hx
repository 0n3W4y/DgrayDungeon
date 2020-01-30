package;

import openfl.display.Sprite;

enum BuildingDeployID
{
	BuildingDeployID( _:Int );
}

typedef BuildingConfig =
{
	var ID:Game.ID;
	var DeployID:BuildingDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
	var UpgradeLevel:Int;
	var NextUpgradeId:Int;
	var CanUpgradeLevel:Bool;
	var UpgradePrice:Player.Money;
	var InventoryStorageSlotsMax:Int;
}

class Building
{
	private var _id:Game.ID;
	private var _name:String;
	private var _deployId:BuildingDeployID;
	private var _type:String;
	private var _sprite:Sprite;

	private var _graphics:GraphicsSystem;
	private var _inventory:InventorySystem;

	private var _upgradeLevel:Int; // текущий уровень здания
	private var _nextUpgradeId:Int; // deployId этого здания, но уже с апгерйдом.
	private var _canUpgradeLevel:Bool; // можно ли улучшить здание.
	private var _upgradePrice:Player.Money; // количество моент необходимое для апгрейда здания.

	private var _inventoryStorage:Array<Inventory.Slot>;
	private var _inventoryStorageSlots:Int;
	private var _inventoryStorageSlotsMax:Int;

	private var _heroStorage:Array<Hero>;
	private var _heroStorageSlots:Int;
	private var _heroStorageSlotsMax:Int;

	public inline function new( config:BuildingConfig ):Void
	{
		this._type = "building";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;	
		this._sprite = config.GraphicsSprite;	
		this._upgradeLevel = config.UpgradeLevel;
		this._nextUpgradeId = config.NextUpgradeId;
		this._canUpgradeLevel = config.CanUpgradeLevel;
		this._upgradePrice = config.UpgradePrice;
		this._heroStorageSlotsMax = config.InventoryStorageSlotsMax;
		this._graphics = new GraphicsSystem( this );
		this._inventory = new InventorySystem( this );
	}

	public function init():String
	{
		var textError:String = 'Name:"$_name" id:"$_id" deploy id:"$_deployId"';
		if( this._name == null || this._name == "" )
			return 'Error in Building.init. Wrong name. $textError';

		if( this._id == null )
			return 'Error in Building.init. Wrong ID. $textError';
		
		if( this._deployId == null )
			return 'Error in Building.init. Wrong Deploy ID. $textError';

		if( this._upgradeLevel == null || this._upgradeLevel < 1 )
			return 'Error in Building.init. Upgrade level is not valid: "$_upgradeLevel". $textError';

		if( this._canUpgradeLevel == null )
			return 'Error in Building.init. Can Upgrade value is not valid: "$_canUpgradeLevel". $textError';

		if( this._canUpgradeLevel && this._nextUpgradeId == null )
			return 'Error in Building.init. Next upgrade deploy Id is not valid: "$_nextUpgradeId". $textError';

		if( this._heroStorageSlotsMax == null )
			return 'Error in Building.init. Container slots maximum value is not valid: "_heroStorageSlotsMax". $textError';
		
		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Building.init. $err; $textError';

		err = this._inventory.init();
		if( err != null )
			return 'Error in Building.init. $err; $textError';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			case "graphics": return this._graphics;
			case "sprite": return this._sprite;
			case "upgradeLevel": return this._upgradeLevel;
			case "nextUpgradeId": return this._nextUpgradeId;
			case "canUpgradeLevel": return this._canUpgradeLevel;
			case "inventoryStorage": return this.inventoryStorage;
			case "inventoryStorageMaxSlots": return this._inventoryStorageSlotsMax;
			case "inventoryStorageSlots": return this._inventoryStorageSlots;
			case "inventory": return this._inventory;
			case "heroStorage": return this._heroStorage;
			case "heroStorageSlots": return this._heroStorageSlots;
			case "heroStorageSlotsMax": return this._heroStorageSlotsMax;
			default: throw 'Error in Building.get. Can not get "$value"';
		}
	}

	public function addHero( hero:Hero ):Void
	{

	}

	public function removeHero( hero:Hero ):Hero
	{
		return null;
	}
}