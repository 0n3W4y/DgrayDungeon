package;

import Item;

typedef ItemSystemConfig =
{
	var Parent:Game;
}

class ItemSystem
{
	var _parent:Game;

	public function new( config:ItemSystemConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in ItemSystem.init';
		if( this._parent == null )
			throw '$err. Parent is null';
	}

	public function generateItem( name:String, itemType:String, rarity:String ):Item // name: LongSword, itemType: Weapon, rarity: "common";
	{
		var deployItem:Map<ItemDeployID, Dynamic> = this._parent.getSystem( "deploy" ).getDeploy( "item" ); // full config of items;
		var generatedName = name;
		var generatedItemType = itemType;
		var generatedRarity = rarity;

		if( itemType == "generate" && name == "generate" )
			generatedItemType = this._generateItemType();

		if( rarity == "generate" )
			generatedRarity = this._generateRarity();

		if( name == "generate" )
			generatedName = this._generateName( generatedItemType );

		var deployId:Int = this._foundDeployIdForItem( generatedName, generatedItemType, generatedRarity );

		if( deployId == null )
			throw 'Error in ItemSystem.generateItem. can not find any item "$generatedName", "$generatedItemType", "$generatedRarity"';

		var item:Item = createItem( deployId );
		return item;
	}

	public function createItem( deployId:Int ):Item
	{
		var config:Dynamic = this._parent.getSystem( "deploy" ).getItem( ItemDeployID( deployId ) );
		var id:Int = this._parent.createId();
		var secondConfig:Dynamic = this.generatePriceAndStats( config );
		trace ( secondConfig );

		var itemConfig:ItemConfig =
		{
			Name: config.name,
			ID: ItemID( id ),
			ItemType: config.itemType,
			DeployID: ItemDeployID( config.deployId ),
			Rarity: config.rarity,
			Restriction: config.restriction,
			FullName: config.fullName,
			Amount: config.amount,
			AmountMax: config.amountMax,
			PriceBuy: secondConfig.priceBuy,
			PriceSell: secondConfig.priceSell,
			UpgradeLevel: config.upgradeLevel,
			UpgradeLevelMax: config.upgradeLevelMax,
			UpgradeLevelPrice: secondConfig.upgradeLevelPrice,
			UpgradeLevelMultiplier: config.upgradeLevelMultiplier,
			Damage: secondConfig.damage,
			Defense: secondConfig.defense,
			ExtraDamage: secondConfig.extraDamage,
			ExtraDefense: secondConfig.extraDefense,
			Accuracy: secondConfig.accuracy,
			Dodge: secondConfig.dodge,
			Block: secondConfig.block,
			CriticalChanse: secondConfig.criticalChanse,
			CriticalDamage: secondConfig.criticalDamage,
			Speed: secondConfig.speed,
			HealthPoints: secondConfig.healthPoints,
			ResistStun: secondConfig.resistStun,
			ResistPoison: secondConfig.resistPoison,
			ResistBleed: secondConfig.resistBleed,
			ResistDisease: secondConfig.resistDisease,
			ResistDebuff: secondConfig.resistDebuff,
			ResistMove: secondConfig.resistMove,
			ResistFire: secondConfig.resistFire,
			ResistCold: secondConfig.resistCold
		}

		var item:Item = new Item( itemConfig );
		item.init( 'Error in ItemSystem.createItem.');

		//TODO: Sprite for item;
		return item;
	}

	public function generatePriceAndStats( config:Dynamic ):Dynamic
	{
		// by default, all stats is 0; in calculate we ignore 0 and take only -value and +value;
		var configToReturn:Dynamic =
		{
			"priceBuy": config.priceBuy,
			"priceSell": config.priceSell,
			"upgradeLevelPrice": config.upgradeLevelPrice,
			"damage": 0,
			"extraDamage": 0,
			"accuracy": 0,
			"dodge": 0,
			"block": 0,
			"criticalChanse": 0,
			"criticalDamage": 0,
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

		var extraStats:Array<String> = config.extraStats;
		var maxExtraStats:Int = config.maxExtraStats;
		var cursedStat:Int = config.cursedStat; // получаем процент, котоырй покажет будет ли статы отрицательной или положительной.

		if( maxExtraStats == null )
			throw 'Error in ItemSyste.generatePriceAndStats. Max Extra stats "$maxExtraStats"';
		//choose  stats for item; yes, random; and check - cursed or not;
		// if cursed stat have "-" value;
		for( i in 0...maxExtraStats )
		{
			var arrayLength:Int = extraStats.length;
			var stat:String = extraStats[ Math.floor( Math.random() * arrayLength ) ]; // получаем рандомную стату из аррэя
			extraStats.remove( stat );// во избежании повторов, удаляем из массива.

			// рандомно получаем отрицательной или положительной будет стата.
			var cursedMultiplier:Int = 1;
			var cursedNumber:Int = Math.floor( Math.random() * 100 ); // [ 0 - 99 ];
			if( cursedNumber < cursedStat ) // Если число меньше значения, значит считаем что *да*.
				cursedMultiplier = -1;

			var defaultStatValue:Int = Reflect.field( config, stat ); // получаем стандартное занчение статы из конфига
			var statValue:Int = cursedMultiplier * Math.floor( Math.random() * ( defaultStatValue + 1 )); // +1 because we using Math.floor();
			Reflect.setField( configToReturn, stat, statValue ); // записываем значение в конфиг для возврата.

			var key:String = stat + "BuyPrice"; // получаем что-то типа resistColdBuyPrice;
			var defaultBuyPrice:Int = Reflect.field( config, key ); // получаем стоимость за эту стату в максимальном ее значении.

			var addedPrice:Int = Math.round( statValue * defaultBuyPrice / defaultStatValue ); // ищем среднюю цену относительно максимальной цены за максимальный стат
			configToReturn.priceBuy += addedPrice;
			configToReturn.upgradeLevelPrice += Math.round( addedPrice / 2 ); // увеличиваем стоимость апгрейда.
		}

		configToReturn.priceSell += Math.round( configToReturn.priceSell * configToReturn.priceBuy / config.priceBuy ); // ищем среднюю цену относительно начальной цени и конечной.

		if( config.damage == null )
			configToReturn.defense = config.defense;
		else
			configToReturn.damage = config.damage;

		if( configToReturn.priceBuy <= 0 )
			configToReturn.priceBuy = config.priceBuy;

		if( configToReturn.priceSell <= 0 )
			configToReturn.priceSell = config.priceSell;

		if( configToReturn.upgradeLevelPrice <= 0 )
			configToReturn.upgradeLevelPrice = config.upgradeLevelPrice;

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
		var array:Array<String> = [ "weapon", "armor" ]; // "acessory1", "acessory2";
		return array[ Math.floor( Math.random() * array.length )];
	}

	private function _foundDeployIdForItem( name:String, type:String, rarity:String ):Int
	{
		var rarityNumber:Int = 0;
		switch ( rarity )
		{
			case "uncommon": rarityNumber = 1;
			case "rare": rarityNumber = 2;
			case "legendary": rarityNumber = 3;
			default: throw 'Error in ItemSystem._foundDeployIdForItem. Bad rarity "$rarity"';
		}
		switch( type )
		{
			case "weapon":
			{
					switch( name )
					{
						case "longSword": return ( 20000 + rarityNumber );
						case "swordAndShield":  return ( 20004 + rarityNumber );
						case "hummerAndShield":  return ( 20008 + rarityNumber );
						case "crossbow":  return ( 20012 + rarityNumber );
						case "oilAndCandle":  return ( 20016 + rarityNumber );
						default: throw 'Error in ItemSystem._foundDeployIdForItem. Can not find item with type "$type" and name "$name"';
					}
			}
			case "armor":
			{
				switch( name )
				{
					case "breastArmor":  return ( 25000 + rarityNumber );
					case "chainMail":  return ( 25004 + rarityNumber );
					case "robe":  return ( 25008 + rarityNumber );
					default: throw 'Error in ItemSystem._foundDeployIdForItem. Can not find item with type "$type" and name "$name"';
				}
			}
			default: throw 'Error in ItemSystem._foundDeployIdForItem. Can not find item with type "$type"';
		}
		return null;
	}

}
