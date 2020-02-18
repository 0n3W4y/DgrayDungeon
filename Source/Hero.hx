package;

import InventorySystem;

enum HeroID
{
	HeroID( _:Int );
}

enum HeroDeployID
{
	HeroDeployID( _:Int );
}

typedef HeroConfig =
{
	var ID:HeroID;
	var Name:String;
	var DeployID:HeroDeployID;
	var Rarity:String;
	var BuyPrice:Player.Money;
	var HeroName:String;
	var HeroSurname:String;
	var HealthPoints:Int;
	var Accuracy:Int;
	var Dodge:Int;
	var Block:Int;
	var CritChanse:Int;
	var BaseArmor:Int;
	var BaseDamage:Int;
	var Speed:Int;
	var CritDamage:Int;
	var Stress:Int;
	var ResistStun:Int;
	var ResistPoison:Int;
	var ResistBleed:Int;
	var ResistDesease:Int;
	var ResistDebuff:Int;
	var ResistMove:Int;
	var ResistFire:Int;
	var ResistCold:Int;
	var PreferPosition:Array<Int>;
	var MaxPositiveTraits:Int;
	var MaxNegativeTraits:Int;
	var MaxLockedPositiveTraits:Int;
	var MaxLockedNegativeTraits:Int;
	var ActiveSkills:Array<Int>;
	var PassiveSkils:Array<Int>;
	var MaxActiveSkills:Int;
	var MaxPassiveSkills:Int;
}

typedef Position =
{
  var First:Int;
  var Second:Int;
  var Third:Int;
  var Fourth:Int;
}


class Hero
{
	private var _id:HeroID;
	private var _deployId:HeroDeployID;
	private var _name:String;
	private var _type:String;
	private var _buyPrice:Player.Money;
	private var _heroName:String;
	private var _heroSurname:String;

	private var _currentPosition:String; // "second";
	private var _preferPosition:Position;
	private var _preferTargetPosition:Position;

	private var _inventory:InventorySystem;
	private var _itemInventory:Array<Slot>; //использовтаь поле как константу, для инвентаря.

	private var _graphics:GraphicsSystem;
	private var _stat:StatSystem;
	private var _resist:ResistSystem;
	private var _skill:SkillSystem;

	//текущие значения статов.
	private var _hp:Float;
	private var _acc:Float;
	private var _ddg:Float;
	private var _block:Float;
	private var _cc:Float;
	private var _def:Float;
	private var _dmg:Float;
	private var _spd:Float;
	private var _stress:Float;
	private var _critDmg:Float;
	//текущие значения резистов.
	private var _resistStun:Float;
	private var _resistPoison:Float;
	private var _resistBleed:Float;
	private var _resistDesease:Float;
	private var _resistDebuff:Float;
	private var _resistMove:Float;
	private var _resistFire:Float;
	private var _resistCold:Float;

	private var _status:String; // мертв, лечится, на задании  и прочие статусы.


	public function new( config:HeroConfig ):Void
	{
		this._type = "hero";
		this._id = config.ID;
		this._deployId = config.DeployID;
		this._name = config.Name;
		this._buyPrice = config.BuyPrice;
		this._heroName = config.HeroName;
		this._heroSurname = config.HeroSurname;
		this._inventory = new InventorySystem({ Parent:this });
		this._graphics = new GraphicsSystem({ Parent:this, GraphicsSprite:config.GraphicsSprite });
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';
		this._status = "none";
		this._itemInventory = new Array<Slot>();
		this._itemInventory.push({ Type:"weapon", Item:null, Restriction:this._name, Available:true });
		this._itemInventory.push({ Type:"armor", Item:null, Restriction:this._name, Available:true });
		this._itemInventory.push({ Type:"accessory1", Item:null, Restriction:"none", Available:true });
		this._itemInventory.push({ Type:"accessory2", Item:null, Restriction:"none", Available:true });

		if( this._id == null )
			throw '$err';

		if( this._deployId == null )
			throw '$err';

		if( this._name == null )
			throw '$err';

		this._inventory.init( err );

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
			case "status": return this._status;
			case "heroName": return this._heroName;
			case "heroSurname": return this._heroSurname;
			case "fullHeroName": return ( this._heroName + ' ' + this._heroSurname );
			case "inventory": return this._inventory;
			case "itemInventory": return this._itemInventory;
			case "stat": return this._stat;
			default: throw 'Error in Hero.get. Can not get $value';
		}
	}

	public function changeStatusTo( value:String ):Void
	{
		switch( value )
		{
			case "none": this._status = value;
			default: throw 'Error in Hero.ChangeStatusTo. $value is not valid status';
		}
	}

	public function setStstTo( stat:String, value:Float ):Void
	{
		switch( stat )
		{
			case "hp":
			case "acc":
			case "ddg":
			case ""
		}
	}


	//PRIVATE


}
