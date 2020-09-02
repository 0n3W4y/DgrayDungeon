package;

import haxe.display.Display.Package;
import Item;

typedef ItemSystemConfig =
{
	var Parent:Game;
}

typedef ItemParameters =
{
	var Name:String;
	var DeployID:Int;
}

class ItemSystem
{
	var _parent:Game;
	var _types:Array<String>;
	var _names:Map<String, Array<String>>;
	var _rarities:Array<String>;
	var _itemParametersStorage:Map<String, Array<ItemParameters>>;

	public function new( config:ItemSystemConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in ItemSystem.init';
		if( this._parent == null )
			throw '$err. Parent is null';

		this._types = new Array<String>();
		this._names = new Map<String, Array<String>>();
		this._rarities = new Array<String>();
		this._itemParametersStorage = new Map<String, Array<ItemParameters>>();

		this._fillDataArrays();

		if( this._rarities.length == 0 )
			throw '$err. Rarities array is empty';

		if( this._types.length == 0 )
			throw '$err. Item Types array is empty';

	}

	public function generateItem( name:String, itemType:String, rarity:String ):Item // name: LongSword, itemType: Weapon, rarity: "common";
	{
		var generatedName = name;
		var generatedItemType = itemType;
		var generatedRarity = rarity;

		if( itemType == "generate" && name == "generate" )
			generatedItemType = this._generateItemType();

		if( rarity == "generate" )
			generatedRarity = this._generateRarity();

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

		var configExtraStats:Array<String> = config.extraStats;
		var extraStats:Array<String> = configExtraStats.copy();
		var maxExtraStats:Int = config.maxExtraStats;
		var cursedStat:Int = config.cursedStat; // получаем процент, котоырй покажет будет ли статы отрицательной или положительной.
		var deployId:Int = config.deployId;

		if( extraStats == null )
			throw 'Error in IemSystem.generatePriceAndStats. Array with extra stats is null in deploy id "$deployId"';

		if( maxExtraStats == null )
			throw 'Error in ItemSyste.generatePriceAndStats. Max Extra stats "$maxExtraStats" in deploy id "$deployId"';
		//choose  stats for item; yes, random; and check - cursed or not;
		// if cursed stat have "-" value;
		for( i in 0...maxExtraStats )
		{
			var stat:String = extraStats[ Math.floor( Math.random() * extraStats.length ) ]; // получаем рандомную стату из аррэя
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

		configToReturn.priceSell = Math.round( configToReturn.priceSell * configToReturn.priceBuy / config.priceBuy ); // ищем среднюю цену относительно начальной цени и конечной.

		if( config.damage == null )
			configToReturn.defense = config.defense;
		else
			configToReturn.damage = config.damage;

		if( configToReturn.priceBuy <= 0 )
		{
			configToReturn.priceBuy = config.priceBuy;
			configToReturn.priceSell = config.priceSell;
		}
			
		if( configToReturn.priceSell <= 0 )
			configToReturn.priceSell = 1;

		if( configToReturn.priceBuy < configToReturn.priceSell )
			configToReturn.priceSell = 1;

		if( configToReturn.upgradeLevelPrice <= 0 )
			configToReturn.upgradeLevelPrice = config.upgradeLevelPrice;

		return configToReturn;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "rarity": return this._rarities;
			case "type": return this._types;
			case "name": return this._names;
			default: throw 'Error in ItemSystem.get. can not get "$value"';
		}
		return null;
	}


	// PRIVATE



	private function _generateRarity():String
	{
		var array:Array<String> = this._rarities;
		return array[ Math.floor( Math.random() * array.length )];
	}

	private function _generateItemType():String
	{
		var array:Array<String> = this._types;
		return array[ Math.floor( Math.random() * array.length )];
	}

	private function _foundDeployIdForItem( name:String, type:String, rarity:String ):Int
	{
		var array:Array<ItemParameters> = this._itemParametersStorage[ type ];
		if( array == null )
			throw 'Error in ItemSystem._generateName. No "$type" in Item Parameters Storage';

		// в конфиге каждая item  типа armor, weapon, acessory1-2 имеет rarity. в конце мы его и добавялем. Соответственно другие item имеют common = 0;
		var rarityNumber:Int = null;
		switch ( rarity )
		{
			case "common": rarityNumber = 0;
			case "uncommon": rarityNumber = 1;
			case "rare": rarityNumber = 2;
			case "legendary": rarityNumber = 3;
			default: throw 'Error in ItemSystem._foundDeployIdForItem. Bad rarity "$rarity"';
		}

		if( name == "generate" )
		{
			var itemParameters:ItemParameters = array[ Math.floor( Math.random() * array.length )];
			return ( itemParameters.DeployID + rarityNumber );
		}
		else 
		{
			for( i in 0...array.length )
			{
				var parameters:ItemParameters = array[ i ];
				if( parameters.Name == name )
					return ( parameters.DeployID + rarityNumber );					
			}
		}
		return null;		
	}

	private function _fillDataArrays():Void
	{
		var deployItem:Map<ItemDeployID, Dynamic> = this._parent.getSystem( "deploy" ).getDeploy( "item" ); // full config of items;
		for( key in deployItem.keys() )
		{
			var value:Dynamic = deployItem[ key ];
			this._addTypeInTypesArray( value.itemType );
			this._addRarityInRarityArray( value.rarity );
			if( value.rarity == "common" )
				this._addToParametersStorage( value.itemType, value.name, value.deployId );
		}
	}

	private function _addToParametersStorage( type:String, name:String, deployId:Int ):Void
	{
		if( this._itemParametersStorage[ type ] == null )
			this._itemParametersStorage[ type ] = new Array<ItemParameters>();

		var typeValue:Array<ItemParameters> = this._itemParametersStorage[ type ];
		typeValue.push({ Name:name, DeployID: deployId });
		// "armor" ->[ {Name: "longSword", DeployID: 10000 } ]; 
	}

	private function _addTypeInTypesArray( type:String ):Void
	{
		if( type == null )
			throw 'Error in itemSystem._addTypeInTypesArray. Type is null!';

		for( i in 0...this._types.length )
		{
			if( type == this._types[ i ] )
				return;
		}
		this._types.push( type );
	}

	private function _addRarityInRarityArray( rarity:String ):Void
	{
		if( rarity == null )
			throw 'Error in itemSystem._addTypeInTypesArray. Name is null!';
		
		for( i in 0...this._rarities.length )
		{
			if( rarity == this._rarities[ i ] )
				return;
		}
		this._rarities.push( rarity );
	}

}
