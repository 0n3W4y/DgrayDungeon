package;

import Window;

import openfl.display.Sprite;
import openfl.display.Bitmap;

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
		//TODO: найти окно с рекрутами, найти кнопку, которая сейчас активна ( может быть активна только одна кнопка ), проверить хватает ли денег, проверить
		// хвататет ли места в инветаре здания для героев ( inn ). Совершить сделку, в противном случае вывести окно, в котором будет сведения об ошибке.
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
			throw 'Error in State.recruitHero. No button is choosed';

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
			throw 'Error in State.recruitHero. No hero assigned to button';

		this.giveHeroToPlayer( heroToBuy );
	}

	public function giveHeroToPlayer( hero:Hero ):Void
	{
		var innBuilding:Building = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2010 );
		if( innBuilding.checkFreeSlotForHero() )
			innBuilding.addHero( hero );
		else
			this.showError( 'Can not buy recruit, you do not have free slots in Inn' );

		var heroPrice:Player.Money = hero.get( "buyPrice" );
		this.withdrawMoneyFromPlayer( heroPrice );

		var ui:UserInterface = this._parent.getSystem( "ui" );
		var innWindow:Window = ui.getWindowByDeployId( 3002 );
		var newHeroButton = ui.createButton( 4016 );
		this.bindHeroAndButton( hero, newHeroButton );
		//TODO: убрать текущую кнопку из списка, сдвинуть список ( если нужно ), добавить новую кнопку в Inn.

	}

	public function withdrawMoneyFromPlayer( amount:Player.Money ):Void
	{
			var check:Bool = this._parent.getPlayer().withdrawMoney( amount );
			if( !check )
				this.showError( 'Can not buy recruit, you do not have enough moeny' );

			//TODO: отобразить в графике изменения в моентах.
	}

	public function bindHeroAndButton( hero:Hero, button:Button ):Void
	{
		var buttonName:String = button.get( "name" );
		switch( buttonName )
		{
			case "recruitWindowHeroButton": this._bindHeroAndRecruitWindowButton( hero, button );
			case "innWindowHeroButton": this._bindHeroAndInnWindowButton( hero, button );
			default: 'Error in State.bindHeroAndButton. Can not bind hero with button $buttonName';
		}
	}

	public function showError( string:String ):Void
	{
		trace( string ); // временно.
		//TODO: достать окно с ошибкой с userinterface, изменить текст ошибки, добавить на активную часть ui. Показать, забиндить клавишу "ок" на закрытие окна и анбинд кнопки "ок";
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
			var heroButton:Button = null;
			// создаем кнопку на основе длегендарности героя ( отличие оконтовка )
			switch( rarity )
			{
				case "uncommon": heroButton = ui.createButton( 4014 );
				case "common": heroButton = ui.createButton( 4014 );
				case "rare": heroButton = ui.createButton( 4014 );
				case "legendary": heroButton = ui.createButton( 4014 );
				default:
			}
			this.bindHeroAndButton( hero, heroButton );
			var recruitWindow:Window = ui.getWindowByDeployId( 3002 );
			recruitWindow.addButton( heroButton );
		}

		//TODO: запустить внутренний таймер для отсчета смены новых героев.
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
		buttonGraphics.setText( fullHeroName, "first" );
		buttonGraphics.setText( heroClass, "second" );
	}

	private function _bindHeroAndInnWindowButton( hero:Hero, button:Button ):Void
	{

	}

}
