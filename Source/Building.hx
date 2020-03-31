package;

import openfl.display.Sprite;


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

	private var _upgradeLevel:Int; // текущий уровень здания
	private var _nextUpgradeId:Int; // deployId этого здания, но уже с апгерйдом.
	private var _canUpgradeLevel:Bool; // можно ли улучшить здание.
	private var _upgradePrice:Player.Money; // количество монет необходимое для апгрейда здания.

	private var _itemStorage:Array<Item>;
	private var _itemStorageSlotsMax:Int;

	private var _buyBackItemStorage:Array<Item>;

	private var _heroStorage:Array<Hero>;
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
		this._graphics = new GraphicsSystem({ Parent: this, GraphicsSprite: config.GraphicsSprite });
	}

	public function init( error:String ):Void
	{
		this._heroStorage = new Array<Hero>();
		this._itemStorage = new Array<Item>();

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
			case "heroStorage": return this._heroStorage;
			case "heroStorageSlotsMax": return this._heroStorageSlotsMax;
			default: throw 'Error in Building.get. Can not get "$value"';
		}
	}

	public function addHero( hero:Hero ):Void
	{
		if( !this._checkFreeSlotForHero() )
			throw 'Error in Building.addHero. No free slots for new one';

		this._heroStorage.push( hero );
	}

	public function removeHero( hero:Hero ):Hero
	{
		var id:Hero.HeroID = hero.get( "id" );
		for( i in 0...this._heroStorage.length )
		{
			var currentHero:Hero = this._heroStorage[ i ];
			if( haxe.EnumTools.EnumValueTools.equals( currentHero.get( "id" ), id ))
			{
				this._heroStorage.splice( i, 1 ); // при нахождении совпадения, удаляем его из хранилища.
				break;
			}
		}
		return hero;
	}

	public function addItem( item:Item ):Void
	{
		if( !this._checkFreeSlotForItem() )
			return;

		this._itemStorage.push( item );
	}

	public function removeItem( item:Item ):Item
	{
		var id:Item.ItemID = item.get( "id" );
		for( i in 0...this._itemStorage.length )
		{
			var currentItem:Item = this._itemStorage[ i ];
			if( haxe.EnumTools.EnumValueTools.equals( currentItem.get( "id" ), id ))
			{
				this._itemStorage.splice( i, 1 );
				break;
			}
		}
		return item;
	}

	public function getHeroById( id:Hero.HeroID ):Hero
	{
		for( i in 0...this._heroStorage.length )
		{
			var hero:Hero = this._heroStorage[ i ];
			var heroId:Hero.HeroID = hero.get ( "id" );
			if( haxe.EnumTools.EnumValueTools.equals( id, heroId ))
				return hero;
		}
		throw 'Error in Building.getHeroById.There is no hero "$id" in "$_name"';
		return null;
	}

	public function clearHeroStorage():Void
	{
		this._heroStorage = new Array<Hero>();
	}

	public function clearItemStorage():Void
	{
		this._itemStorage = new Array<Item>();
	}


	//PRIVATE

	private function _checkFreeSlotForHero():Bool
	{
		if( this._heroStorage.length < this._heroStorageSlotsMax )
			return true;

		return false;
	}

	private function _checkFreeSlotForItem():Bool
	{
		if( this._itemStorage.length < this._itemStorageSlotsMax )
			return true;

		return false;
	}
}
