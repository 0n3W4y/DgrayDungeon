package;

import openfl.display.Sprite;

typedef BuildingConfig =
{
	var ID:GeneratorSystem.ID;
	var DeployID:GeneratorSystem.DeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
	var UpgradeLevel:Int;
	var NextUpgradeId:Int;
	var CanUpgradeLevel:Bool;
	var UpgradePrice:GeneratorSystem.Money;
	var HeroStorageSlotsMax:Int;
}

class Building
{
	private var _id:GeneratorSystem.ID;
	private var _name:String;
	private var _deployId:GeneratorSystem.DeployID;
	private var _type:String;

	private var _graphics:GraphicsSystem;

	private var _upgradeLevel:Int; // текущий уровень здания
	private var _nextUpgradeId:Int; // deployId этого здания, но уже с апгерйдом.
	private var _canUpgradeLevel:Bool; // можно ли улучшить здание.
	private var _upgradePrice:GeneratorSystem.Money; // количество моент необходимое для апгрейда здания.

	private var _heroStorage:Array<Hero>;
	private var _heroStorageSlots:Int;
	private var _heroStorageSlotsMax:Int;

	public function new( config:BuildingConfig ):Void
	{
		this._type = "building";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;		
		this._upgradeLevel = config.UpgradeLevel;
		this._nextUpgradeId = config.NextUpgradeId;
		this._canUpgradeLevel = config.CanUpgradeLevel;
		this._upgradePrice = config.UpgradePrice;
		this._heroStorageSlotsMax = config.HeroStorageSlotsMax;
		this._graphics = new GraphicsSystem( this, config.GraphicsSprite );
		this._heroStorage = new Array<Hero>();
		this._heroStorageSlots = 0;
	}

	public function init():String
	{
		if( this._name == null || this._name == "" )
			return 'Error in Building.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._id == null )
			return 'Error in Building.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null )
			return 'Error in Building.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._upgradeLevel == null || this._upgradeLevel < 1 )
			return 'Error in Building.init. Upgrade level is not valid: "$_upgradeLevel". Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._canUpgradeLevel == null )
			return 'Error in Building.init. Can Upgrade value is not valid: "$_canUpgradeLevel". Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._canUpgradeLevel && this._nextUpgradeId == null )
			return 'Error in Building.init. Next upgrade deploy Id is not valid: "$_nextUpgradeId". Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._heroStorageSlotsMax == null )
			return 'Error in Building.init. Container slots maximum value is not valid: "_heroStorageSlotsMax". Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Building.init. $err; "$_deployId"';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function checkForFreeSlotsHeroStorage():Bool
	{
		if( this._heroStorageSlotsMax > this._heroStorageSlots )
			return true;

		return false;
	}

	public function cleareHeroStorage():Void
	{
		this._heroStorageSlots = 0;
		this._heroStorage = new Array<Hero>();
	}

	public function addHeroToStorage( hero:Hero ):Void
	{
		if( !this.checkForFreeSlotsHeroStorage() ) //защита от "дурака";
			return;

		var name:String = hero.get( "name" );
		var check:Int = this._checkHero( hero );
		if( check != null )
			throw 'Error in Building.addHero. Find duplicate hero with name: "$name"';

		this._heroStorage.push( hero );
		this._heroStorageSlots++;
	}

	public function removeHeroFromStorage( hero:Hero ):Array<Dynamic>
	{
		var name:String = hero.get( "name" );
		var check:Int = this._checkHero( hero );
		if( check == null )
			throw 'Error in Building.removeHero. Hero with name: "$name" does not exist';

		this._heroStorage.splice( check, 1 );
		this._heroStorageSlots--;
		return [ hero, null ];
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
			case "sprite": return this._graphics.getSprite();
			case "upgradeLevel": return this._upgradeLevel;
			case "nextUpgradeId": return this._nextUpgradeId;
			case "canUpgradeLevel": return this._canUpgradeLevel;
			case "heroStorage": return this._heroStorage;
			case "maxSlots": return this._heroStorageSlotsMax;
			default: throw 'Error in Building.get. Can not get "$value"';
		}
	}

	//PRIVATE

	private function _checkHero( hero:Hero ):Int
	{
		var id:Int = hero.get( "id" );
		for( i in 0...this._heroStorage.length )
		{
			if( this._heroStorage[ i ].get( "id" ) == id )
				return i;
		}
		return null;
	}
}