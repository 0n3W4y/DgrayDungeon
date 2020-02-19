package;

import InventorySystem;
import SkillSystem;
import TraitSystem;
import StatSystem;
import ResistSystem;

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
	var HealthPoints:Float;
	var Accuracy:Float;
	var Dodge:Float;
	var Block:Float;
	var CritChanse:Float;
	var BaseArmor:Float;
	var BaseDamage:Float;
	var Speed:Float;
	var CritDamage:Float;
	var Stress:Float;
	var ResistStun:Float;
	var ResistPoison:Float;
	var ResistBleed:Float;
	var ResistDesease:Float;
	var ResistDebuff:Float;
	var ResistMove:Float;
	var ResistFire:Float;
	var ResistCold:Float;
	var PreferPosition:Position;
	var PreferTargetPosition:Position;
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

	private var _position:String; // "second";
	private var _preferPosition:Position;
	private var _preferTargetPosition:Position;

	private var _traits:Array<Null>;
	private var _skills:Array<Null>;
	private var _itemInventory:Array<Slot>; //использовтаь поле как константу, для инвентаря.

	private var _inventory:InventorySystem;
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
	private var _resistDisease:Float;
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
		this._stat = new StatSystem({ Parent:this });
		this._resist = new ResistSystem({ Parent:this });

		this._hp = config.HealthPoints;
		this._acc = config.Accuracy;
		this._ddg = config.Dodge;
		this._block = config.Block;
		this._cc = config.CritChanse;
		this._def = config.Defense;
		this._dmg = config.Damage;
		this._spd = config.Speed;
		this._stress = config.Stress;
		this._critDmg = config.CritDamage;

		this._resistStun = config.ResistStun;
		this._resistPoison = config.ResistPoison;
		this._resistBleed = config.ResistBleed;
		this._resistDisease = config.ResistDisease;
		this._resistDebuff = config.ResistDebuff;
		this._resistMove = config.ResistMove;
		this._resistFire = config.ResistFire;
		this._resistCold = config.ResistCold;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';
		this._status = "none";
		this._itemInventory = new Array<Slot>();
		// заполняем интвентарь для нормальной работы InventorySystem;
		// this._name == "cleric";
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
		this._graphics.init( err );
		this._stat.init( err );
		this._resist.init( err );

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
			case "resist": return this._resist;
			case "preferPosition": return this._preferPosition;
			case "preferTarget": return this._preferTargetPosition;
			case "position": return this._position;
			default: throw 'Error in Hero.get. Can not get $value';
		}
	}

	public function getStat( stat:String ):Float
	{
		switch( stat )
		{
			case "hp": return this._hp;
			case "acc": return this._acc;
			case "ddg": return this._ddg;
			case "block": return this._block;
			case "cc": return this._cc
			case "def": return this._def;
			case "dmg": return this._dmg;
			case "spd": return this._spd;
			case "stress": return this._stress;
			case "critDmg": return this._critDmg;
			default: throw 'Error in Hero.getStat. can not get $stat';
		}
	}

	public function getResist( resist:String ):Float
	{
		switch( resist )
		{
			case "stun": return this._resistStun;
			case "poison": return this._resistPoison;
			case "bleed": return this._resistBleed;
			case "disease": return this._resistDisease;
			case "debuff": return this._resistDebuff;
			case "move": return this._resistMove;
			case "fire": return this._resistFire;
			case "cold": return this._resistCold;
			default: throw 'Error in Hero.getResist. Can not get $resist';
		}
	}

	public function setStatusTo( value:String ):Void
	{
		switch( value )
		{
			case "none": this._status = value;
			default: throw 'Error in Hero.ChangeStatusTo. $value is not valid status';
		}
	}

	public function setPositionTo( value:String ):Void
	{
		if( value == "first" || value == "second" || value == "third" || value == "fourth" )
			this._position = value;
		else
			throw 'Error in Hero.setPositionTo. can not set position to $value';
	}

	public function setStatTo( stat:String, value:Float ):Void
	{
		switch( stat )
		{
			case "hp": this._hp = value;
			case "acc": this._acc = value;
			case "ddg": this._ddg = value;
			case "block": this._block = value;
			case "cc": this._cc = value;
			case "def": this._def = value;
			case "dmg": this._dmg = value;
			case "spd": this._spd = value;
			case "stress": this._stress = value;
			case "critDmg": this._critDmg = value;
			default: throw 'Error in Hero.setStatTo. Can not set $stat';
		}
	}

	public function setResistTo( resist:String, value:FLoat ):Void
	{
		switch( resist )
		{
			case "stun": this._resistStun = value;
			case "poison": this._resistPoison = value;
			case "bleed": this._resistBleed = value;
			case "disease": this._resistDisease = value;
			case "debuff": this._resistDebuff = value;
			case "move": this._resistMove = value;
			case "fire": this._resistFire = value;
			case "cold": this._resistCold = value;
			default: throw 'Error in Hero.setResistTo. Can not set $resist';
		}
	}


	//PRIVATE


}
