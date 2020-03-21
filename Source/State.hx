package;

import Window;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

typedef StateConfig =
{
	var Parent:Game;
}

class State
{
	private var _parent:Game;


	public inline function new( config:StateConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{

	}

	public function postInit():Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "parent": return this._parent;
			default: throw 'Error in State.get. No "$value" found.';
		}
	}

	public function startGame():Void
	{
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		var player:Player = this._parent.createPlayer( 100 , "test player" );

		var scene:Scene = sceneSystem.createScene( 1001 );
		sceneSystem.prepareScene( scene );
		sceneSystem.changeSceneTo( scene );

	}

	public function recruitHero():Void
	{
		var error:String = 'You can not buy hero, because ';
		var hero:Hero = this._findRecruitHeroForBuy();
		if( hero == null )
			return;

		var price:Player.Money = hero.get( "buyPrice" );
		if ( !this._checkPlayerMoneyAmount( price ) )
		{
			this._showWarning( '$error not enough money' );
			this.unchooseRecruitHeroButtons();
			return;
		}

		if( !this._checkRoomInInnInventoryForHero() )
		{
			this._showWarning( '$error not enough room in Inn' );
			this.unchooseRecruitHeroButtons();
			return;
		}

		//after all checks
		this._transferHeroToPlayerInn( hero );
		this._removeHeroFromRecruitBuilding( hero );
		this.withdrawMoneyFromPlayer( price );

		// redraw our list;
		this._redrawListOfHeroesInRecruitBuilding();
	}

	public function withdrawMoneyFromPlayer( amount:Player.Money ):Void
	{
		if ( !this._checkPlayerMoneyAmount( amount ) )
			throw 'Error in State.withdrawMoneyFromPlayer. Player money < "$amount"';

		var player:Player = this._parent.getPlayer();
		player.withdrawMoney( amount );
		var currentMoney:Player.Money = player.get( "money" );
		//TODO: отобразить в графике изменения в моентах.
		// Графическая часть находится только на cityMainScene в окне, где отображены кнопки storage, options Lauch;
		// var windowGraphics:GraphicsSystem = this._parent.getSystem( "ui" ).getWindowByDeployId( 0000 ).get( "graphics" );
		// windowGraphics.setText( '$currentMoney', "first" );
	}

	public function generateHeroesForBuilding( building:Building ):Void
	{
		var heroSystem:HeroSystem = this._parent.getSystem( "hero" );
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var heroSlots:Int = building.get( "heroStorageSlotsMax" );
		var buildingLevel:Int = building.get( "upgradeLevel" );
		var rarityArray:Array<String> = this._parent.getSystem( "hero" ).get( "rarity" );
		var inverseLevel:Int = rarityArray.length - buildingLevel;
		// 1 lvl - only common; 2 lvl - common + uncommon; 3 lvl common + uncommon + rare; 4 lvl common + uncommon + rare + legendary;
		for( i in 0...heroSlots )
		{
			var rarityIndex:Int = Math.floor( Math.random() * ( rarityArray.length - inverseLevel ));
			var rarity:String = rarityArray[ rarityIndex ];
			var hero:Hero = heroSystem.generateHero( "random", rarity );
			building.addHero( hero );
			var heroButton:Button = null;
			// создаем кнопку на основе легендарности героя ( отличие оконтовка )
			switch( rarity )
			{
				case "uncommon": heroButton = ui.createButton( 4014 );
				case "common": heroButton = ui.createButton( 4015 );
				case "rare": heroButton = ui.createButton( 4016 );
				case "legendary": heroButton = ui.createButton( 4017 );
				default: throw 'Error in State.generateHeroesForBuilding. Can not create button with rarity: "$rarity"';
			}
			
			var buttonSprite:Sprite = heroButton.get( "sprite" );
			var buttonNewY:Float = buttonSprite.height * i;
			buttonSprite.y += buttonNewY;
			this._bindHeroAndRecruitWindowButton( hero, heroButton );
			var recruitWindow:Window = ui.getWindowByDeployId( 3002 );
			recruitWindow.addButton( heroButton );
		}

		//TODO: запустить внутренний таймер для отсчета смены новых героев.
	}

	public function chooseUnchooseButton( id:Button.ButtonID, name:String ):Void
	{
		switch( name )
		{
			case "recruitHeroButtonWhite", "recruitHeroButtonBlue", "recruitHeroButtonOrange", "recruitHeroButtonGreen": 
			{
				var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
				var button:Button = recruitWindow.getButtonById( id );
				if( !button.get( "activeStatus" ))
					this.unchooseRecruitHeroButtons();

				button.changeActiveStatus();
			};
			default: throw 'Error in Stat.unchooseButton. Can not choose button with name: "$name"';
		}
	}

	public function unchooseRecruitHeroButtons():Void
	{
		var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
		var array:Array<Button> = recruitWindow.get( "buttons" );
		for( i in 0...array.length )
		{
			var button:Button = array[ i ];
			var name:String = button.get( "name" );
			if( name == "recruitHeroButtonWhite" || name == "recruitHeroButtonBlue" || name == "recruitHeroButtonOrange" || name == "recruitHeroButtonGreen" )
			{
				if( button.get( "activeStatus") )
					button.changeActiveStatus();
			}
		}
	}

	//PRIVATE

	private function _bindHeroAndRecruitWindowButton( hero:Hero, button:Button ):Void
	{
		var buttonId:Button.ButtonID = button.get( "id" );
		hero.setButtonId( buttonId );

		//create new sprite with portrait of hero, and add it to new button;
		var buttonGraphics:GraphicsSystem = button.get( "graphics" );
		var heroDeployId:Hero.HeroDeployID = hero.get( "deployId" );
		var heroDeployConfig:Dynamic = this._parent.getSystem( "deploy" ).getHero( heroDeployId );
		var urlHeroPortrait:String = heroDeployConfig.imagePortraitURL;
		var heroPortraitSprite:Sprite = new Sprite();
		heroPortraitSprite.addChild( new Bitmap( Assets.getBitmapData( urlHeroPortrait )));
		buttonGraphics.setPortrait( heroPortraitSprite );

		// get needed strings from hero and add them to button;
		var fullHeroName:String = hero.get( "fullName" );
		var heroClass:String = hero.get( "name" );
		var heroBuyPrice:Player.Money = hero.get( "buyPrice" );
		buttonGraphics.setText( fullHeroName, "first" );
		buttonGraphics.setText( heroClass, "second" );
		buttonGraphics.setText( '$heroBuyPrice', "third" );
	}

	private function _bindHeroAndInnWindowButton( hero:Hero, button:Button ):Void
	{

	}

	private function _showWarning( error:String ):Void
	{
		// временно будет trace;
		trace( error );
		return;
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var warningWindow:Window = ui.getWindowByDeployId( 3100 ); // warningWindow Deploy ID;
		warningWindow.get( "graphics" ).setText( error, "first" );
		ui.openWindow( 3100 );
	}

	private function _checkPlayerMoneyAmount( price:Player.Money ):Bool
	{
		var playerMoney:Player.Money = this._parent.getPlayer().get( "money" );
		var number:Int = playerMoney - price;
		if( number < 0 )
			return false;

		return true;
	}

	private function _checkRoomInInnInventoryForHero():Bool
	{
		var innBuilding:Building = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2010 );
		var currentSlots:Int = innBuilding.get( "heroStorage" ).length; // returned Array<Hero>;
		var maxSlots:Int = innBuilding.get( "heroStorageSlotsMax" );
		if( maxSlots > currentSlots )
			return true;

		return false;
	}

	private function _transferHeroToPlayerInn( hero:Hero ):Void
	{
		if( !this._checkRoomInInnInventoryForHero() )
			throw 'Error in State._transferHeroToPlayerInn. No room space for hero in Inn';
		
		this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2010 ).addHero( hero );
		//TODO:all
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var innWindow:Window = ui.getWindowByDeployId( 3002 );
		var rarity:String = hero.get( "rarity" );
		var heroButton:Button = null;
		switch( rarity )
		{
			case "uncommon": heroButton = ui.createButton( 4014 );
			case "common": heroButton = ui.createButton( 4015 );
			case "rare": heroButton = ui.createButton( 4016 );
			case "legendary": heroButton = ui.createButton( 4017 );
			default: throw 'Error in State.generateHeroesForBuilding. Can not create button with rarity: "$rarity"';
		}
		//this._bindHeroAndInnWindowButton( hero, newHeroButton );
	}

	private function _checkBoxInStorageInventoryForItem():Bool
	{
		//TODO: check this :D
		return false;
	}

	private function _removeHeroFromRecruitBuilding( hero:Hero ):Hero
	{
		var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
		var buttonId:Button.ButtonID = hero.get( "buttonId" );
		var button:Button = recruitWindow.getButtonById( buttonId );
		recruitWindow.removeButton( button );
		var newHero:Hero = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2002 ).removeHero( hero );
		return newHero;
	}

	private function _findRecruitHeroForBuy():Hero
	{
		var recruitWindow = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
		var buttonsArray:Array<Button> = recruitWindow.get( "buttons" );
		var buttonToBuy:Button = null;
		var heroToBuy:Hero = null;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			if( button.get( "activeStatus") )
			{
				buttonToBuy = button;
				break;
			}
		}

		if( buttonToBuy == null )
			return null;

		var buttonId:Button.ButtonID = buttonToBuy.get( "id" );
		var recruitBuilding:Building = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2002 );
		var heroStorage:Array<Hero> = recruitBuilding.get( "heroStorage" );
		for( j in 0...heroStorage.length )
		{
			var hero:Hero = heroStorage[ j ];
			if( haxe.EnumTools.EnumValueTools.equals( hero.get( "buttonId"), buttonId ))
			{
				heroToBuy = hero;
				break;
			}
		}

		if( heroToBuy == null )
			return null;

		return heroToBuy;
	}

	private function _redrawListOfHeroesInRecruitBuilding():Void
	{
		var recruitWindow = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
		var buttonsArray:Array<Button> = recruitWindow.get( "buttons" );
		var counter:Int = 0;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var name:String = button.get( "name" );
			if( name == "recruitHeroButtonWhite" || name == "recruitHeroButtonBlue" || name == "recruitHeroButtonOrange" || name == "recruitHeroButtonGreen" )
			{
				var buttonSprite:Sprite = button.get( "sprite" );
				// we can get Deploy ID from button, get sprite.y and add it;
				var deployId:Button.ButtonDeployID = button.get( "deployId" );
				var newY:Int = this._parent.getSystem( "deploy" ).getButton( deployId ).y;
				buttonSprite.y = counter * buttonSprite.height + newY;
				counter++;
			}
		}
	}

}
