package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

import Item;

typedef ItemSystemConfig =
{
	Parent:Game;
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
		if( this._parent == "null" )
			throw '$err. Parent is null';
	}

	public function generateItem( name:String, itemType:String, rarity:String ):Item // name: LongSword, itemType: Weapon, rarity: "common";
	{
		var deployItem:Map<ItemDeployID, Dynamic> = this._parent.getSystem( "deploy" ).getDeploy( "item" ); // full config of items;
		var generatedName = name;
		var generatedItemType = itemType;
		var generatedRarity = rarity;

		if( itemType == "generate" && name == "generate" )
			generatedItemType = this._generatedItemType();

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
		var sprite:Sprite = new DataSprite({ ID: id, Name: config.name });
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( graphicsSprite );
		sprite.addChild( textSprite );

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
			Damage: Hero.Damage( secondConfig.damage ),
			Defense: Hero.Defense( secondConfig.defense ),
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

		var item:Item = new Item( itemConfig );
		item.init();

		//TODO: Sprite for item;
		return item;
	}

	public function generatePriceAndStats( config:Dynamic ):Dynamic
	{
		// by default, all stats is 0; in calculate we ignore 0 and take only -value and +value;
		var configToReturn:Dynamic =
		{
			"priceBuy": 0,
			"priceSell": 0,
			"upgradeLevelPrice": 0,
			"damage": 0,
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
		var upgradeLevelPrice:Int = config.upgradeLevelPrice;

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
			var addedPrice:Int = Math.round( statValue * defaultBuyPrice / defaultStatValue ); // ищем среднюю цену относительно максимальной цены за максимальный стат
			priceBuy += addedPrice;
			configToReturn.upgradeLevelPrice += Math.round( addedPrice / 2 );
		}

		configToReturn.priceBuy = priceBuy;
		priceSell += Math.round( priceSell * priceBuy / config.priceBuy ); // ищем среднюю цену относительно начальной цени и конечной.
		configToReturn.priceSell = priceSell;

		if( config.damage == null )
			configToReturn.defense = config.defense;
		else
			configToReturn.damage = config.damage;

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
		switch( type ):
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

	private function _createGraphicsSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap;

		if( config.imageNormalURL != null )
		{
			bitmap = this._createBitmap( config.imageNormalURL, config.imageNormalX, config.imageNormalY );
			sprite.addChild( bitmap );
		}

		if( config.imageHoverURL != null )
		{
			bitmap = this._createBitmap( config.imageHoverURL, config.imageHoverX, config.imageHoverY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		if( config.imagePushURL != null )
		{
			bitmap = this._createBitmap( config.imagePushURL, config.imagePushX, config.imagePushY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		if( config.imageChooseURL != null )
		{
			bitmap = this._createBitmap( config.imageChooseURL, config.imageChooseX, config.imageChooseY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		// TODO: Portrait for button hero, Level for button hero.

		return sprite;
	}
	private function _createBitmap( url:String, x:Float, y:Float ):Bitmap
	{
		var bitmap:Bitmap = new Bitmap( Assets.getBitmapData( url ) );
		bitmap.x = x;
		bitmap.y = y;
		return bitmap;
	}

	private function _createTextSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var text:TextField;
		var textConfig:Dynamic =
		{
			"text": null,
			"size": null,
			"color": null,
			"width": null,
			"height": null,
			"x": null,
			"y": null,
			"align": null
		};

		if( config.firstText != null )
		{
			textConfig.text = config.firstText;
			textConfig.size = config.firstTextSize;
			textConfig.color = config.firstTextColor;
			textConfig.width = config.firstTextWidth;
			textConfig.height = config.firstTextHeight;
			textConfig.x = config.firstTextX;
			textConfig.y = config.firstTextY;
			textConfig.align = config.firstTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		if( config.secondText != null )
		{
			textConfig.text = config.secondText;
			textConfig.size = config.secondTextSize;
			textConfig.color = config.secondTextColor;
			textConfig.width = config.secondTextWidth;
			textConfig.height = config.secondTextHeight;
			textConfig.x = config.secondTextX;
			textConfig.y = config.secondTextY;
			textConfig.align = config.secondTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		if( config.thirdText != null )
		{
			textConfig.text = config.thirdText;
			textConfig.size = config.thirdTextSize;
			textConfig.color = config.thirdTextColor;
			textConfig.width = config.thirdTextWidth;
			textConfig.height = config.thirdTextHeight;
			textConfig.x = config.thirdTextX;
			textConfig.y = config.thirdTextY;
			textConfig.align = config.thirdTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		return sprite;
	}

	private function _createText( text:Dynamic ):TextField
	{
    var txt:TextField = new TextField();

    var align:Dynamic = null;
    switch( text.align )
    {
    	case "left": align = TextFormatAlign.LEFT;
    	case "right": align = TextFormatAlign.RIGHT;
    	case "center": align = TextFormatAlign.CENTER;
    	default: throw( "Error in GeneratorSystem._createText. Wrong align: " + text.align + "; text: " + text.text );
    }

    var textFormat:TextFormat = new TextFormat();
    textFormat.font = "Verdana";
    textFormat.size = text.size;
    textFormat.color = text.color;
    textFormat.align = align;

    txt.defaultTextFormat = textFormat;
    txt.visible = true;
    txt.selectable = false;
    txt.text = text.text;
    txt.width = text.width;
    txt.height = text.height;
    txt.x = text.x;
    txt.y = text.y;

    if( text.text == null || text.width == null || text.height == null || text.x == null || text.y == null || text.size == null || text.color == null )
    	throw( "Some errors in GeneratorSystem._createText. In config some values is NULL. Text: " + text.text );

    return txt;
	}
}
