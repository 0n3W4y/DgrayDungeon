package;

import Hero;
import Player;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.display.Bitmap;
import openfl.Assets;

typedef HeroSystemConfig =
{
	var Parent:Game;
	var ManNames:Array<String>;
	var WomanNames:Array<String>;
	var Surnames:Array<String>;
	var Rarity:Array<String>;
	var Types:Array<String>;
}

class HeroSystem
{
	private var _parent:Game;
	private var _manNames:Array<String>;
	private var _womanNames:Array<String>;
	private var _surnames:Array<String>;
	private var _usedNamesSurnames:Array<String>;

	private var _rarity:Array<String>; // легендарность героев.
	private var _types:Array<String>; // типы героев

	public function new( config:HeroSystemConfig ):Void
	{
		this._parent = config.Parent;
		this._manNames = config.ManNames;
		this._womanNames = config.WomanNames;
		this._surnames = config.Surnames;
		this._rarity = config.Rarity;
		this._types = config.Types;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in HeroSystem.init';

		if( this._parent == null )
			throw '$err. Parent is wrong';

		if( this._manNames == null || this._manNames.length == 0 )
			throw '$err. Man names is wrong';

		if( this._womanNames == null || this._womanNames.length == 0 )
			throw '$err. Woman names is wrong';

		if( this._surnames == null || this._surnames.length == 0 )
			throw '$err. Surnames is wrong';

		if( this._rarity == null || this._rarity.length == 0 )
			throw '$err. Rarity is wrong';

		if( this._types == null || this._types.length == 0 )
			throw '$err Hero classes are wrong';
	}

	public function postInit( error:String ):Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "rarity": return this._rarity;
			case "types": return this._types;
			default: throw 'Error in HeroSystem.get. Can not get $value';
		}
	}

	public function generateHero( type:String, rarity:String ):Hero
	{
		var newType:String = null;
		var newRarity:String = null;

		if( type == "random" )
				newType = this._types[ Math.floor( Math.random() * this._types.length )];
		else
				newType = type;

		if( rarity == "random" )
			newRarity = this._rarity[ Math.floor( Math.random() * this._rarity.length )];
		else
			newRarity = rarity;

		var heroMap:Map<PlayerDeployID, Dynamic> = this._parent.getSystem( "deploy" ).getDeploy( "hero" );
		var deployId:Int = 0;
		for( key in heroMap.keys() )
		{
			var object:Dynamic = heroMap[ key ];
			if( object.rarity == newRarity && object.name == newType )
			{
				deployId = object.deployId;
				break;
			}
		}

		if( deployId == 0 )
			throw 'Error in HeroSystem.generateHero. Can not generate hero with $type and $rarity';

		var hero:Hero = this.createHero( deployId );
		return hero;
	}

	public function createHero( deployId:Int ):Hero
	{
		var heroDeployId:HeroDeployID = HeroDeployID( deployId );
		var config:Dynamic = this._parent.getSystem( "deploy" ).getHero( heroDeployId );
		var id:HeroID = HeroID( this._parent.createId() );
		var buyPrice:Money = config.buyPrice;
		//var sprite:Sprite = new Sprite();
		//var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		//sprite.addChild( graphicsSprite );
		//var textSprite:Sprite = this._createTextSprite( config );
		//sprite.addChild( textSprite );

		var configForHero =
		{
			ID: id,
			DeployID: heroDeployId,
			Name: config.name,
			Rarity: config.rarity,
			BuyPrice: buyPrice,
			HealthPoints:config.healthPoints,
			Accuracy:config.accuracy,
			Dodge:config.dodge,
			Block:config.block,
			CritChanse:config.critChanse,
			Defense:config.defense,
			Damage:config.damage,
			Speed:config.speed,
			CritDamage:config.critDamage,
			Stress:config.stress,
			ResistStun:config.resistStun,
			ResistPoison:config.resistPoison,
			ResistBleed:config.resistBleed,
			ResistDeseas:config.resistDisease,
			ResistDebuff:config.resistDebuff,
			ResistMove:config.resistMove,
			ResistFire:config.resistFire,
			ResistCold:config.resistCold,
			PreferPosition:{ First:config.preferPosition[ 0 ], Second:config.preferPosition[ 1 ], Third: config.preferPosition[ 2 ], Fourth: config.preferPosition[ 3 ] },
			PreferTargetPosition:{ First:config.preferTargetPosition[ 0 ], Second:config.preferTargetPosition[ 1 ], Third: config.preferTargetPosition[ 2 ], Fourth: config.preferTargetPosition[ 3 ] },
			MaxPositiveTraits:config.maxPositiveTraits,
			MaxNegativeTraits:config.maxNegativeTraits,
			MaxLockedPositiveTraits:config.maxLockedPositiveTraits,
			MaxLockedNegativeTraits:config.maxLockedNegativeTraits,
			MaxActiveSkills:config.maxActiveSkills,
			MaxPassiveSkills:config.maxPassiveSkills
		}
		var hero:Hero = new Hero( configForHero );
		hero.init( 'Error in HeroSystem.CreateHero' );

		//TODO: skills and traits on hero.
		return hero;
	}

	//PRIVATE

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
