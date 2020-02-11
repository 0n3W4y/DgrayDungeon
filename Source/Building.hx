package;

import openfl.display.Sprite;

import InventorySystem;

enum BuildingDeployID
{
	BuildingDeployID( _:Int );
}

enum BuildingID
{
	BuildingID( _:Int );
}

typedef BuildingConfig =
{
	var ID:BuildingID;
	var DeployID:BuildingDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
	var UpgradeLevel:Int;
	var NextUpgradeId:Int;
	var CanUpgradeLevel:Bool;
	var UpgradePrice:Player.Money;
	var ItemStorageSlotsMax:Int;
	var HeroStorageSlotsMax:Int;
}

class Building
{
	private var _id:BuildingID;
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

	private var _itemStorage:Array<Item>;
	private var _itemStorageSlots:Int;
	private var _itemStorageSlotsMax:Int;

	private var _buyBackItemStorage:Array<Item>;

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
		this._heroStorageSlotsMax = config.HeroStorageSlotsMax;
		this._itemStorageSlotsMax = config.ItemStorageSlotsMax;
		this._graphics = new GraphicsSystem();
	}

	public function init():Void
	{
		var err:String = 'Name:"$_name" id:"$_id" deploy id:"$_deployId"';

		if( this._name == null || this._name == "" )
			throw 'Error in Building.init. Wrong name. $err';

		if( this._id == null )
			throw 'Error in Building.init. Wrong ID. $err';
		
		if( this._deployId == null )
			throw 'Error in Building.init. Wrong Deploy ID. $err';

		if( this._upgradeLevel == null || this._upgradeLevel < 1 )
			throw 'Error in Building.init. Upgrade level is not valid: "$_upgradeLevel". $err';

		if( this._canUpgradeLevel == null )
			throw 'Error in Building.init. Can Upgrade value is not valid: "$_canUpgradeLevel". $err';

		if( this._canUpgradeLevel && this._nextUpgradeId == null )
			throw 'Error in Building.init. Next upgrade deploy Id is not valid: "$_nextUpgradeId". $err';

		if( this._heroStorageSlotsMax == null )
			throw 'Error in Building.init. Container slots maximum value is not valid: "_heroStorageSlotsMax". $err';

		if( this._itemStorageSlotsMax == null )
			throw 'Error in Building.init. Container slots maximum value is not valid: "_itemStorageSlotsMax". $err';

		this._graphics.init( 'Error in Building.init. Error in GraphicsSystem.init. $err' );

	}

	public function postInit():Void
	{
		
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
			case "itemStorage": return this._itemStorage;
			case "itemStorageMaxSlots": return this._itemStorageSlotsMax;
			case "itemStorageSlots": return this._itemStorageSlots;
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
		return hero;
	}

	public function addItem( item:Item ):Void
	{

	}

	public function removeItem( item:Item ):Item
	{
		return item;
	}

	public function checkFreeSlotForHero():Bool
	{
		if( this._heroStorageSlots < this._heroStorageSlotsMax )
			return true;

		return false;
	}
}