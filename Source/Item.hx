package;

import openfl.display.Sprite;

enum ItemID
{
	ItemID( _:Int );
}

enum ItemDeployID
{
	ItemDeployID( _:Int );
}

typedef ItemAmount = Int;

typedef ItemConfig =
{
	var Name:String;
	var ID:ItemID;
	var ItemType:String;
	var DeployID:ItemDeployID;
	var Rarity:String;
	var Restriction: Array<String>;
	var FullName:String;
	var Amount: ItemAmount;
	var AmountMax: ItemAmount;
	var PriceBuy:Player.Money;
	var PriceSell:Player.Money;
	var UpgradeLevel:Int;
	var UpgradeLevelMax:Int;
	var UpgradeLevelPrice:Player.Money;
	var UpgradeLevelMultiplier:Int;
	var Damage: Hero.Damage;
	var Defense: Hero.Defense;
	var ExtraDamage: Hero.Damage;
	var ExtraDefense: Hero.Defense;
	var Accuracy:Hero.Accuracy;
	var Dodge:Hero.Dodge;
	var Block:Hero.Block;
	var CriticalChanse:Hero.CriticalChanse;
	var CriticalDamage:Hero.CriticalDamage;
	var Speed:Hero.Speed;
	var HealthPoints: Hero.HealthPoints;
	var ResistStun:Hero.ResistStun;
	var ResistPoison:Hero.ResistPoison;
	var ResistBleed:Hero.ResistBleed;
	var ResistDisease:Hero.ResistDisease;
	var ResistDebuff:Hero.ResistDebuff;
	var ResistMove:Hero.ResistMove;
	var ResistFire:Hero.ResistFire;
	var ResistCold:Hero.ResistCold;
}

class Item
{
	private var _id:ItemID;
	private var _deployId:ItemDeployID;
	private var _type:String;
	private var _itemType:String;
	private var _name:String;
	private var _rarity:String;
	private var _restriction:Array<String>;
	private var _fullName:String;

	private var _amount:ItemAmount;
	private var _amountMax:ItemAmount;
	private var _priceBuy:Player.Money;
	private var _priceSell:Player.Money;
	private var _upgradeLevel:Int;
	private var _upgradeLevelPrice:Player.Money;

	private var _damage:Hero.Damage;
	private var _defense:Hero.Defense;
	private var _extraDamage: Hero.Damage;
	private var _extraDefense: Hero.Defense;
	private var _accuracy:Hero.Accuracy;
	private var _dodge:Hero.Dodge;
	private var _block:Hero.Block;
	private var _criticalChanse:Hero.CriticalChanse;
	private var _criticalDamage:Hero.CriticalDamage;
	private var _speed:Hero.Speed;
	private var _healthPoints: Hero.HealthPoints;
	private var _resistStun:Hero.ResistStun;
	private var _resistPoison:Hero.ResistPoison;
	private var _resistBleed:Hero.ResistBleed;
	private var _resistDisease:Hero.ResistDisease;
	private var _resistDebuff:Hero.ResistDebuff;
	private var _resistMove:Hero.ResistMove;
	private var _resistFire:Hero.ResistFire;
	private var _resistCold:Hero.ResistCold;

	public function new( config:ItemConfig ):Void
	{
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._rarity = config.Rarity;
		this._fullName = config.FullName;
		this._restriction = config.Restriction;
		this._amount = config.Amount;
		this._amountMax = config.AmountMax;
		this._priceBuy = config.PriceBuy;
		this._priceSell = config.PriceSell;
		this._upgradeLevel = config.UpgradeLevel;
		this._upgradeLevelPrice = config.UpgradeLevelPrice;
		this._damage = config.Damage;
		this._defense = config.Defense;
		this._extraDamage = config.ExtraDamage;
		this._extraDefense = config.ExtraDefense;
		this._accuracy = config.Accuracy;
		this._dodge = config.Dodge;
		this._block = config.Block;
		this._criticalChanse = config.CriticalChanse;
		this._criticalDamage = config.CriticalDamage;
		this._speed = config.Speed;
		this._healthPoints = config.HealthPoints;
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
		var err:String = '$error. Error in Item.init. Name "$_name", itemType "$_itemType", deploy id "$_deployId"';
		if( this._name == null )
			throw '$err. Name is null';

		if( this._id == null )
			throw '$err. Id is null';

		if( this._deployId == null )
			throw '$err. deploy id is null';

		if( this._rarity == null )
			throw '$err. rarity is null';

		if( this._fullName == null )
			throw '$err. full name is null';

		if( this._restriction == null )
			throw '$err. restriction is null';

		if( this._amount == null || this._amount < 0 )
			throw '$err. amount "$_amount"';

		if( this._amountMax == null || this._amountMax < 0 )
			throw '$err. Max amount "$_amountMax"';

		if( this._priceBuy == null || this._priceBuy < 0 )
			throw '$err. Buy Price "$_priceBuy"';

		if( this._priceSell == null || this._priceSell < 0 )
			throw '$err. Buy Price "$_priceBuy"';

		if( this._upgradeLevel == null || this._upgradeLevel < 0 )
			throw '$err. Upgrade level "$_upgradeLevel"';

		if( this._upgradeLevelPrice == null || this._upgradeLevelPrice < 0 )
			throw '$err. Upgrade level price "$_upgradeLevelPrice"';

		if( this._damage == null )
			throw '$err. Damage is null';

		if( this._defense == null )
			throw '$err. Defense is null';

		if( this._extraDamage == null )
			throw '$err. Extra Damage is null';

		if( this._extraDefense == null )
			throw '$err. Extra Defense is null';

		if( this._accuracy == null )
			throw '$err. Accuracy is null';

		if( this._dodge == null )
			throw '$err. Dodge is null';

		if( this._block == null )
			throw '$err. Block is null';

		if( this._criticalChanse == null )
			throw '$err. Crit Chanse is null';

		if( this._speed == null )
			throw '$err. Speed is null';

		if( this._criticalDamage == null )
			throw '$err. Crit damage is null';

		if( this._healthPoints == null )
			throw '$err. Health Points is null';

		if( this._resistStun == null )
			throw '$err. Resist Stun is null';

		if( this._resistPoison== null )
			throw '$err. Resist Poison is null';

		if( this._resistDisease == null )
			throw '$err. Resist Disease is null';

		if( this._resistBleed == null )
			throw '$err. Rresist Bleed is null';

		if( this._resistDebuff == null )
			throw '$err. Resist debuff is null';

		if( this._resistMove == null )
			throw '$err. Resist Move is null';

		if( this._resistFire == null )
			throw '$err. Resist fire is null';

		if( this._resistCold == null )
			throw '$err. Resist cold is null';
	}

	public function postInit( error:String ):Void
	{
		var err:String = '$error. Error in Item.postInit. Name "$_name", itemType "$_itemType", deploy id "$_deployId"';
	}

	public function get( value:String ):Dynamic
	{
		switch ( value )
		{
			case "id": return this._id;
			case "name": return this._name;
			case "type": return this._type;
			case "itemType": return this._itemType;
			case "rarity": return this._rarity;
			case "restriction": return this._restriction;
			case "fullName": return this._fullName;
			case "amount": return this._amount;
			case "amountMax": return this._amountMax;
			case "priceBuy": return this._priceBuy;
			case "priceSell": return this._priceSell;
			case "upgradeLevel": return this._upgradeLevel;
			case "upgradeLevelPrice": return this._upgradeLevelPrice;
			default: throw 'Error in Item.get. No case for "$value"';
		}
	}

	public function setFullName( value:String ):Void
	{
		this._fullName = value;
	}

	public function setAmount( value:ItemAmount ):Void
	{
		var summ:ItemAmount = this._amount + value;
		if( summ > this._amountMax )
			throw 'Error in Item.setAmount. Max amount of this item "$_amountMax", current "$_amount"';

		this._amount = summ;
	}

	public function setPrice( type:String, value:Player.Money ):Void
	{
		switch( type )
		{
			case "buy": this._priceBuy = value;
			case "sell": this._priceSell = value;
			default: throw 'Error in Item.setPrice. No field with name "$type"';
		}
	}

	public function setUpgradeLevel( value:Int ):Void
	{
		this._upgradeLevel = value;
	}

	public function setUpgradeLevelPrice( value:Player.Money ):Void
	{
		this._upgradeLevelPrice = value;
	}

	//set get stats;

	public function getStat( name:String ):Dynamic
	{
		switch( name )
		{
			case "damage": return this._damage;
			case "extraDamage": return this._extraDamage;
			case "defense": return this._defense;
			case "extraDefense": return this._extraDefense;
			case "accuracy": return this._accuracy;
			case "dodge": return this._dodge;
			case "block": return this._block;
			case "criticalDamage": return this._criticalDamage;
			case "criticalChanse": return this._criticalChanse;
			case "speed": return this._speed;
			case "healthPoints": return this._healthPoints;
			case "resistStun": return this._resistStun;
			case "resistPoison": return this._resistPoison;
			case "resistBleed": return this._resistBleed;
			case "resistDesiase": return this._resistDisease;
			case "resistDebuff": return this._resistDebuff;
			case "resistMove": return this._resistMove;
			case "resistFire": return this._resistFire;
			case "resistCold": return this._resistCold;
			default: throw 'Error in Item.getStat. No stat with name "$name"';
		}
	}

	public function setStat( name:String, value:Dynamic ):Void
	{
		switch( name )
		{
			case "damage": this._damage = value;
			case "extraDamage": this._extraDamage = value;
			case "defense": this._defense = value;
			case "extraDefense": this._extraDefense = value;
			case "accuracy": this._accuracy = value;
			case "dodge": this._dodge = value;
			case "block": this._block = value;
			case "criticalDamage": this._criticalDamage = value;
			case "criticalChanse": this._criticalChanse = value;
			case "speed": this._speed = value;
			case "healthPoints": this._healthPoints = value;
			case "resistStun": this._resistStun = value;
			case "resistPoison": this._resistPoison = value;
			case "resistBleed": this._resistBleed = value;
			case "resistDesiase": this._resistDisease = value;
			case "resistDebuff": this._resistDebuff = value;
			case "resistMove": this._resistMove = value;
			case "resistFire": this._resistFire = value;
			case "resistCold": this._resistCold = value;
			default: throw 'Error in Item.setStat. No stat with name "$name"';
		}
	}




}
