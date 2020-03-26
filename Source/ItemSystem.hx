package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

import Item;

class ItemSystem
{

	var _parent:Game;
	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in ItemSystem.init';
	}

	public function generateItem( name:String, itemType:String, rarity:String ):Item // name: LongSword, itemType: Weapon, rarity: "common";
	{
		var deployItem:Map<ItemDeployID, Dynamic> = this._parent.getSystem( "deploy" ).getDeploy( "item" ); // full config of items;
		var generatedName = name;
		var generatedItemType = itemType;
		var generatedRarity = rarity;

		if( itemType == null )
			generatedItemType = this._generatedItemType();

		if( rarity == null )
			generatedRarity = this._generateRarity();

		if( name == null )
			generatedName = this._generateName( generatedItemType );

		for( key in deployItem )
		{

		}
		return null;
	}

	public function createItem( deployId:Int ):Item
	{
		var config:Dynamic = this._parent.getSystem( "deploy" ).getItem( ItemDeployID( deployId ) );
		var id:Int = this._parent.createId();
		var secondConfig:Dynamic = this.generatePriceAndStats( config );
		var sprite:Sprite = new DataSprite( );

		var itemConfig:ItemConfig =
		{
			Name: config.name,
			ID: ItemID( id ),
			ItemType: config.itemType,
			DeployId: ItemDeployID( config.deployId ),
			Rarity: config.rarity,
			Restriction: config.restriction,
			FullName: config.fullName,
			Amount: Amount( config.amount ),
			AmountMax: Amount( config.amountMax ),
			PriceBuy: Player.Money( secondConfig.priceBuy ),
			PriceSell: Player.Money( secondConfig.priceSell ),
			UpgradeLevel: config.upgradeLevel,
			UpgradeLevelMax: config.upgradeLevelMax,
			UpgradeLevelPrice: Player.Money( secondConfig.upgradeLevelPrice ),
			UpgradeLevelMultiplier: config.upgradeLevelMultiplier,
			Damage: Hero.Damage( config.damage ),
			Defense: Hero.Defense( config.defense ),
			ExtraDamage: Hero.Damage( secondConfig.extraDamage ),
			ExtraDefense: Hero.Defense( secondConfig.extraDefense ),
			Accuracy: Hero.Accuracy( secondConfig.accuracy ),
			Dodge: Hero.Dodge( secondConfig.dodge ),
			Block: Hero.Block( secondConfig.block ),
			CritChanse: Hero.CritChanse( secondConfig.critChanse ),
			CritDamage: Hero.CritDamage( secondConfig.critDamage ),
			Speed: Hero.Speed( secondConfig.speed ),
			HealthPoints: Hero.HealthPoints( secondConfig.healthPoints ),
			ResistStun: Hero.ResistStun( secondConfig.resistStun ),
			ResistPoison: Hero.ResistPoison( secondConfig.resistPoison ),
			ResistBleed: Hero.ResistBleed( secondConfig.resistBleed ),
			ResistDisease: Hero.ResistDisease( secondConfig.resistDisease ),
			ResistDebuff: Hero.ResistDebuff( secondConfig.resistDebuff ),
			ResistMove: Hero.ResistMove( secondConfig.resistMove ),
			ResistFire: Hero.ResistFire( secondConfig.resistFire ),
			ResistCold: Hero.ResistCold( secondConfig.resistCold )
		}

		return null;
	}

	public function generatePriceAndStats( config:Dynamic ):Dynamic
	{
		// by default, all stats is 0; in next function we ignore 0 and take only -value and +value;
		var configToReturn:Dynamic =
		{
			"priceBuy": 0,
			"priceSell": 0,
			"extraDamage": 0,
			"accuracy": 0,
			"dodge": 0,
			"block": 0,
			"critChanse": 0,
			"critDamage": 0,
			"speed": 0,
			"defense": 0,
			"extraDefense": 0,
			"healthPoints": 0,
			"resistStun": 0,
			"resistPoison": 0,
			"resistBleed": 0,
			"resistDisease": 0,
			"resistDebuff": 0,
			"resistMove": 0,
			"resistFire": 0,
			"resistCold": 0
		}

		var priceBuy:Int = config.priceBuy;
		var priceSell:Int = config.priceSell;
		var extraStats:Array<String> = config.extraStats;
		var maxExtraStats:Int = config.maxEstraStats;
		var cursedStat:Int = config.cursedStat;

		//choose  stats for item; yes, random; and check - cursed or not;
		// if cursed stat have "-" value;
		for( i in 0...maxExtraStats )
		{
			var randomIndex:Int = Math.floor( Math.random() * extraStats.length );
			var stat:String = extraStats[ randomIndex ];
			extraStats.splice( randomIndex, 1 );// во избежании повторов, удаляем из массива.

			var cursed:Int = 1;
			var cursedNumber:Int = Math.floor( Math.random() * 100 ); // [ 0 - 99 ];
			if( cursedNumber < cursedStat ) // Если число меньше значения, значит считаем что *да*.
				cursed = -1;

			var defaultStatValue:Int = Reflect.field( extraStats, stat );
			var statValue:Int = cursed * Math.floor( Math.random() * ( defaultStatValue + 1 )); // +1 because we using Math.floor();
			Reflect.setField( configToReturn, stat, statValue );
			var key:String = stat + "BuyPrice";
			var defaultBuyPrice:Int = Reflect.filed( config, key );
			priceBuy += Math.round( statValue * defaultBuyPrice / defaultStatValue ); // ищем среднюю цену относительно максимальной цены за максимальный стат
			configToReturn.priceBuy = priceBuy;
		}

		priceSell += Math.round( priceSell * priceBuy / config.priceBuy ); // ищем среднюю цену относительно начальной цени и конечной.
		return configToReturn;
	}


	// PRIVATE


	private function _generateName( itemType:String ):String
	{
		var array:Array<String> = null;
		switch( itemType )
		{
			case "weapon": array = [ "longSword", "swordAndShield", "hummerAndShield", "crossbow", "oilAndCandle" ];
			case "armor": array = [ "breastArmor", "chainMail", "robe" ];
			default: throw 'Error in ItemSystem._generateName. can not generate name with "$itemType"';
		}
		return array[ Math.floor( Math.random() * array.length )];
	}

	private function _generateRarity():String
	{
		var array:Array<String> = [ "common", "uncommon", "rare", "legendary" ];
		return array[ Math.floor( Math.random() * array.length )];
	}

	private function _generateItemType():String
	{

	}
}
