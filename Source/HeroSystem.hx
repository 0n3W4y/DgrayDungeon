package;

import Hero;
import Player;

class HeroSystem
{
	private var _parent:Game;

	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function init( error:String ):Void
	{
		if( this._parent == null )
			throw '$error. Parent is null!';
	}

	public function postInit( error:String ):Void
	{

	}

	public function createHero( deployId:Int ):Hero
	{
		var heroDeployId:HeroDeployID = DeroDeployID( deployId );
		var config:Dynamic = this._parent.getSystem( "deploy" ).getHero( heroDeployId );
		var id:HeroID = HeroID( this._parent.createId() );
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
			BuyPrice: Money( config.buyPrice ),
			Slot0Type:String,
			Slot0Restriction:String,
			Slot0IsAvailable:Bool,
			Slot1Type:String,
			Slot1Restriction:String,
			Slot1IsAvailable:Bool,
			Slot2Type:String,
			Slot2Restriction:String,
			Slot2IsAvailable:String,
			Slot3Type:String,
			Slot3Restriction:String,
			Slot3IsAvailable:Bool,
			HealthPoints:Int,
			Accuracy:Int,
			Dodge:Int,
			Block:Int,
			CritChanse:Int,
			BaseArmor:Int,
			BaseDamage:Int,
			Speed:Int,
			CritDamage:Int,
			Stress:Int,
			ResistStun:Int,
			ResistPoison:Int,
			ResistBleed:Int,
			ResistDeseas:Int,
			ResistDebuff:Int,
			ResistMove:Int,
			ResistFire:Int,
			ResistCold:Int,
			PreferPosition:Array<Int>,
			MaxPositiveTraits:Int,
			MaxNegativeTraits:Int,
			MaxLockedPositiveTraits:Int,
			MaxLockedNegativeTraits:Int,
			ActiveSkills:Array<Int>,
			PassiveSkils:Array<Int>,
			MaxActiveSkills:Int,
			MaxPassiveSkills:Int
		}
		var hero:Hero = new Hero( configForHero );
		hero.init( 'Error in HeroSystem.CreateHero. Hero.init' );

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
