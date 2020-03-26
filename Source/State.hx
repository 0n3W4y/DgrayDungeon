package;

import Window;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.display.BlendMode;

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
		var sceneId:Scene.SceneID = scene.get( "id" );
		var dungeonScene:Scene = sceneSystem.createScene( 1002 ); // start new game - create first dungeon scene;
		sceneSystem.prepareScene( dungeonScene );
		var dungeonSceneId:Scene.SceneID = dungeonScene.get( "id" );

		scene.setSceneForFastSwitch( dungeonSceneId );
		dungeonScene.setSceneForFastSwitch( sceneId );

		sceneSystem.changeSceneTo( scene );
	}

	public function startJourney():Void
	{
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		var currentSceneName:String = sceneSystem.getActiveScene().get( "name" );
		if( currentSceneName == "cityScene" )
		{
			sceneSystem.fastSwitchScenes( sceneSystem.getActiveScene() );
		}
		else
		{

			var choosenDungeon:Button = this._findChoosenDungeon(); // find active button in all windows on scene; { "dungeon": "cave", "difficulty": "easy" };
			if( choosenDungeon == null )
			{
				this._showWarning( 'Please choose a dungeon');
				// или выбать первую кнопку, которая будет в списке :)
				return;
			}

			var check:Bool = this._checkFullPartyHeroes();
			if( !check )
			{
				//Todo - сделать функцию, которая примет значение текста и 2-х кнопок да и нет. Функция должна будет забиндить кнопки на ответ "да", ответ "нет".
				// после чего, в зависимости от ответа и забиндинных функций конкретно для этого окна ( которое будет создаваться в момент вызова ) будет выполнены следующие функции
				// который были переданы с аргументами.
				//return;
			}

			var heroes:Array<Hero> = this._findHeroToDungeon();
			this._prepareJourneyToDungeon( heroes, choosenDungeon );
		}
	}

	public function backToCitySceneFromChooseDungeon():Void
	{
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		sceneSystem.fastSwitchScenes( sceneSystem.getActiveScene() );
	}

	public function innListUp():Void
	{

	}

	public function innListDown():Void
	{

	}

	public function recruitHero():Void
	{
		var error:String = 'You can not buy hero, because ';
		var button:Button = this._findActiveRecruitButton();
		if( button == null )
			return;

		var heroId:Hero.HeroID = button.get( "heroId" );
		var hero:Hero = this._findHeroFromRecruitBuilding( heroId );
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
		this._removeHeroFromRecruitBuilding( hero, button );
		this.withdrawMoneyFromPlayer( price );

		// redraw our list;
		this._redrawListOfHeroesInRecruitBuilding();
		this._redrawListOfHeroesInInnBuilding();
	}

	public function withdrawMoneyFromPlayer( amount:Player.Money ):Void
	{
		if ( !this._checkPlayerMoneyAmount( amount ) )
			throw 'Error in State.withdrawMoneyFromPlayer. Player money < "$amount"';

		var player:Player = this._parent.getPlayer();
		player.withdrawMoney( amount );
		var currentMoney:Player.Money = player.get( "money" );
		var panelCityWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3003 ); // panel City Window have deploy id 3003;
		panelCityWindow.get( "graphics" ).setText( '$currentMoney', "first" );
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

			//create hero weapon and armor;

			var heroButton:Button = null;
			// создаем кнопку на основе легендарности героя ( отличие оконтовка )
			switch( rarity )
			{
				case "common": heroButton = ui.createButton( 4015 );
				case "uncommon": heroButton = ui.createButton( 4016 );
				case "rare": heroButton = ui.createButton( 4017 );
				case "legendary": heroButton = ui.createButton( 4018 );
				default: throw 'Error in State.generateHeroesForBuilding. Can not create button with rarity: "$rarity"';
			}

			var buttonSprite:Sprite = heroButton.get( "sprite" );
			var buttonNewY:Float = buttonSprite.height * i;
			buttonSprite.y += buttonNewY;
			this._bindHeroAndButton( hero, heroButton );
			var recruitWindow:Window = ui.getWindowByDeployId( 3002 );
			recruitWindow.addButton( heroButton );
		}

		//TODO: запустить внутренний таймер для отсчета смены новых героев.
	}

	public function unchooseHeroToDungeon( id:Button.ButtonID, name:String ):Void
	{
		var buttonsArray:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3004 ).get( "buttons" ); // chooseHeroToDungeon Window deploy id is 3004;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			if( haxe.EnumTools.EnumValueTools.equals( id, button.get( "id" )))
			{
				var heroId:Hero.HeroID = button.get( "heroId" );
				if( heroId != null )
				{
					this._unchooseHeroToDungeon( id );
					return;
				}
				else
				{
					throw 'Error in State.unchooseHeroToDungeon. Button "$name", without HeroId!';
				}
			}
		}
	}

	public function chooseUnchooseButton( id:Button.ButtonID, name:String ):Void
	{
		switch( name )
		{
			case "recruitHeroButtonWhite", "recruitHeroButtonBlue", "recruitHeroButtonOrange", "recruitHeroButtonGreen":
			{
				this._chooseHeroRecruitButton( id, name );
			};
			case "innWindowHeroButtonOrange", "innWindowHeroButtonBlue", "innWindowHeroButtonWhite", "innWindowHeroButtonGreen":
			{
				this._chooseHeroInnButton( id, name );
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
				{
					button.changeActiveStatus();
					var sprite:Dynamic = button.get( "sprite" ).getChildAt( 0 );
					var spriteToChange:Sprite = sprite.getChildAt( 3 );
					spriteToChange.visible = false;
				}
			}
		}
	}

	public function uchooseInnHeroButtons():Void
	{
		var innWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ); //inn window deploy id 3009;
		var array:Array<Button> = innWindow.get( "buttons" );
		for( i in 0...array.length )
		{
			var button:Button = array[ i ];
			var name:String = button.get( "name" );
			if( name == "innWindowHeroButtonOrange" || name == "innWindowHeroButtonBlue" || name == "innWindowHeroButtonWhite" || name == "innWindowHeroButtonGreen" )
			{
				if( button.get( "activeStatus") )
				{
					button.changeActiveStatus();
					var sprite:Sprite = button.get( "sprite" );
					sprite.x = 0;
				}
			}
		}
	}





	//PRIVATE


	private function _prepareJourneyToDungeon( array:Array<Hero>, dungeon:Dynamic ):Void
	{
			//TODO:
			//1. open shop window, to buy staff for dungeon, like water, food, bandages, healthkits, shovel, e.t.c
			//2. Create dungeon by config,
			//3. Copy heroes to dungeon scene ( do shadow copy of each hero )
			//	this._setPositionHeroesToDungeonFromArray( array );
	}

	private function _chooseHeroRecruitButton( id:Button.ButtonID, name:String ):Void
	{
		var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
		var button:Button = recruitWindow.getButtonById( id );
		if( !button.get( "activeStatus" ))
			this.unchooseRecruitHeroButtons();
		else
		{
			this.unchooseRecruitHeroButtons();
			return;
		}

		button.changeActiveStatus();
		var sprite:Dynamic = button.get( "sprite" ).getChildAt( 0 );
		var spriteToChange:Sprite = sprite.getChildAt( 3 );
		spriteToChange.visible = true;
	}

	private function _chooseHeroInnButton( id:Button.ButtonID, name:String ):Void
	{
		var sceneName:String = this._parent.getSystem( "scene" ).getActiveScene();
		if( sceneName == "cityScene" )
		{
			var innWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ); //inn window deploy id 3009;
			var button:Button = innWindow.getButtonById( id );
			if( !button.get( "activeStatus" ))
				this.uchooseInnHeroButtons();
			else
			{
				this.uchooseInnHeroButtons();
				return;
			}

			button.changeActiveStatus();
			var sprite:Sprite = button.get( "sprite" );
			sprite.x = -40;
		}
		else // других сцен в которых будут эти кнопки нет. Остается - выбор подзеелья.
		{
			this._chooseHeroToDungeon( id );
		}
	}

	private function _chooseHeroToDungeon( buttonId:Button.ButtonID ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var button:Button = _findInnButtonById( buttonId );

		if( button == null )
			throw 'Error in State._chooseHeroToDungeon. There is no button "$buttonId" in Inn window.';

		if( button.get( "activeStatus") )
			return; // вовзаращем, так как кнопка уже активна - значит герой уже используется.

		var id:Hero.HeroID = button.get( "heroId" );
		var buttonsArray:Array<Button> = ui.getWindowByDeployId( 3004 ).get( "buttons" ); // chooseheroToDungeon Window deploy id 3004
		var isOk:Bool = false;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var heroId:Hero.HeroID = button.get( "heroId" );
			if( heroId == null )
			{
				button.setHeroId( id );
				var hero:Hero = this._findHeroFromInnBuildingById( id );
				this._bindHeroAndButton( hero, button );
				this._parent.getSystem( "event" ).addEvents( button );
				isOk = true;
				break;
			}
		}

		if( !isOk )
			return; // no room for heroes into dungeon;

		// меняем статус кнопки героя в Inn Building. Для того, что бы он не был добавлен дважды.

		button.changeActiveStatus(); // choose button;
		//TODO: Some graphics changes like pos+- or do alpha = 0.5;
		var sprite:Sprite = button.get( "sprite" );
		sprite.blendMode = BlendMode.INVERT;
	}

	private function _unchooseHeroToDungeon( buttonId:Button.ButtonID ):Void
	{
		var id:Hero.HeroID = null;
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var buttonsArray:Array<Button> = ui.getWindowByDeployId( 3004 ).get( "buttons" ); // chooseheroToDungeon Window deploy id 3004
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var oldButtonId:Button.ButtonID = button.get( "id" );
			if( haxe.EnumTools.EnumValueTools.equals( oldButtonId, buttonId ))
			{
				id = button.get( "heroId" );
				button.removeHeroId();
				var sprite:Dynamic = button.get( "sprite" ).getChildAt( 0 );
				sprite.removeChildAt( 3 ); // by default portrait on this button on index 3;
				this._parent.getSystem( "event" ).removeEvents( button ); // убираем ивенты с кнопки, что бы лишний раз не вызывать функции.
				break;
			}
		}

		// меняем статус кнопки героя в Inn Building. Для того, что бы его можно было перевыбрать.
		var newButtonsArray:Array<Button> = ui.getWindowByDeployId( 3006 ).get( "buttons" ); // Inn window deploy id 3006;
		for( j in 0...newButtonsArray.length )
		{
			var button:Button = newButtonsArray[ j ];
			var buttonHeroId:Hero.HeroID = button.get( "heroId" );
			if( haxe.EnumTools.EnumValueTools.equals( buttonHeroId, id ))
			{
				button.changeActiveStatus(); // choose button;
				var sprite:Sprite = button.get( "sprite" );
				sprite.blendMode = BlendMode.NORMAL;
			}
		}
	}

	private function _bindHeroAndButton( hero:Hero, button:Button ):Void
	{
		var heroId:Hero.HeroID = hero.get( "id" );
		button.setHeroId( heroId );

		//create new sprite with portrait of hero, and add it to new button;
		var buttonGraphics:GraphicsSystem = button.get( "graphics" );
		var heroDeployId:Hero.HeroDeployID = hero.get( "deployId" );
		var heroDeployConfig:Dynamic = this._parent.getSystem( "deploy" ).getHero( heroDeployId );
		var urlHeroPortrait:String = heroDeployConfig.imagePortraitURL;
		var heroPortraitSprite:Sprite = new Sprite();
		heroPortraitSprite.addChild( new Bitmap( Assets.getBitmapData( urlHeroPortrait )));
		buttonGraphics.setPortrait( heroPortraitSprite );

		var buttonName:String = button.get( "name" );
		if ( buttonName == "choosenHeroToDungeon" )
			return;
		// get needed strings from hero and add them to button;
		var fullHeroName:String = hero.get( "fullName" );
		var heroClass:String = hero.get( "name" );
		var heroBuyPrice:Player.Money = hero.get( "buyPrice" );
		buttonGraphics.setText( fullHeroName, "first" );
		buttonGraphics.setText( heroClass, "second" );

		if( buttonName == "recruitHeroButtonWhite" || buttonName == "recruitHeroButtonBlue" || buttonName == "recruitHeroButtonOrange" || buttonName == "recruitHeroButtonGreen" )
			buttonGraphics.setText( '$heroBuyPrice', "third" );

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

		var innBuilding:Building = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2010 ); //Inn building with 2010 deploy ID;
		innBuilding.addHero( hero );

		var ui:UserInterface = this._parent.getSystem( "ui" );
		var innWindow:Window = ui.getWindowByDeployId( 3006 ); // inn window with deploy id 3006;
		var rarity:String = hero.get( "rarity" );
		var heroButton:Button = null;
		switch( rarity )
		{
			case "common": heroButton = ui.createButton( 4019 );
			case "uncommon": heroButton = ui.createButton( 4020 );
			case "rare": heroButton = ui.createButton( 4021 );
			case "legendary": heroButton = ui.createButton( 4022 );
			default: throw 'Error in State.generateHeroesForBuilding. Can not create button with rarity: "$rarity"';
		}
		this._bindHeroAndButton( hero, heroButton );
		innWindow.addButton( heroButton );
		this._parent.getSystem( "event" ).addEvents( heroButton );
		this._updateInnText();
	}

	private function _checkBoxInStorageInventoryForItem():Bool
	{
		//TODO: check this :D
		return false;
	}

	private function _removeHeroFromRecruitBuilding( hero:Hero, button:Button ):Hero
	{
		var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 ); // recruit window have 3002 deploy id;
		recruitWindow.removeButton( button );
		var newHero:Hero = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2002 ).removeHero( hero );
		return newHero;
	}

	private function _findActiveRecruitButton():Button
	{
		var recruitWindow = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 ); // recruit window have 3002 deploy id;
		var buttonsArray:Array<Button> = recruitWindow.get( "buttons" );
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			if( button.get( "activeStatus") ) //find first active button, because we have expection - only 1 button is chosen;
				return button;
		}
		return null;
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

	private function _redrawListOfHeroesInInnBuilding():Void
	{
		var innWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ); //inn window deploy id 3006;
		var buttonsArray:Array<Button> = innWindow.get( "buttons" );
		var counter:Int = 0;
		var maxSize:Int = innWindow.get( "sprite" ).height;
		var lastTotalY:Float = 0.0;
		var innWindowFull:Bool = false;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var name:String = button.get( "name" );
			if( name == "innWindowHeroButtonOrange" || name == "innWindowHeroButtonBlue" || name == "innWindowHeroButtonWhite" || name == "innWindowHeroButtonGreen" )
			{
				var buttonSprite:Sprite = button.get( "sprite" );
				// we can get Deploy ID from button, get sprite.y and add it;
				var deployId:Button.ButtonDeployID = button.get( "deployId" );
				var newY:Int = this._parent.getSystem( "deploy" ).getButton( deployId ).y;

				if( !innWindowFull )
				{
					var totalY:Float = counter * buttonSprite.height + newY;
					if( totalY >= maxSize )
					{
						innWindowFull = true;
						buttonSprite.y = lastTotalY;
						buttonSprite.visible = false;
						continue;
					}

					buttonSprite.y = totalY;
					lastTotalY = totalY;
					counter++;
				}
				else
				{
					buttonSprite.y = lastTotalY;
					buttonSprite.visible = false;
				}
			}
		}
	}

	private function _findInnButtonById( id:Button.ButtonID ):Button
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var buttonsArray:Array<Button> = ui.getWindowByDeployId( 3006 ).get( "buttons" ); // inn window deploy id 3006;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			if( haxe.EnumTools.EnumValueTools.equals( button.get( "id" ), id ))
				return button;
		}

		return null;
	}

	private function _updateInnText():Void
	{
		var innBuilding:Building = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2010 ); //Inn building with 2010 deploy ID;
		var currentNumberOfHeroes:Int = innBuilding.get( "heroStorage" ).length;
		var maximumRoomForHeroes:Int = innBuilding.get( "heroStorageSlotsMax" );
		var textToInn:String = 'Inn | $currentNumberOfHeroes of $maximumRoomForHeroes';
		this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ).get( "graphics" ).setText( textToInn , "first" ); // Inn Window deploy id 3006;
	}

	private function _findHeroFromInnBuildingById( heroId:Hero.HeroID ):Hero
	{
		var innBuilding:Building = this._parent.getSystem( "scene" ).getSceneByName( "cityScene" ).getBuildingByDeployId( 2010 );//inn Building 2010 deploy ID;
		var heroStorage:Array<Hero> = innBuilding.get( "heroStorage" );
		for( j in 0...heroStorage.length )
		{
			var hero:Hero = heroStorage[ j ];
			if( haxe.EnumTools.EnumValueTools.equals( hero.get( "id" ), heroId ))
				return hero;
		}
		return null;
	}

	private function _findHeroFromRecruitBuilding( heroId:Hero.HeroID ):Hero
	{
		var recruitBuilding:Building = this._parent.getSystem( "scene" ).getActiveScene().getBuildingByDeployId( 2002 ); // recruit building deploy id 2002;
		var heroStorage:Array<Hero> = recruitBuilding.get( "heroStorage" );
		for( j in 0...heroStorage.length )
		{
			var hero:Hero = heroStorage[ j ];
			if( haxe.EnumTools.EnumValueTools.equals( hero.get( "id" ), heroId ))
				return hero;
		}

		return null;
	}

	private function _checkFullPartyHeroes():Bool
	{
		var buttonsArray:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3004 ).get( "buttons" ); //chooseHeroToDungeonWindow deploy id 3004;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			if( button.get( "heroId" ) != null )
				return false;
		}
		return true;
	}

	private function _findChoosenDungeon():Dynamic
	{
		var difficulty:String = "easy";
		var dungeon:String = "cave";
		return { "dungeon": dungeon, "difficulty": difficulty };
	}

	private function _findHeroToDungeon():Array<Hero>
	{
		var buttonsArray:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3004 ).get( "buttons" ); //chooseHeroToDungeonWindow deploy id 3004;
		var heroesArray:Array<Hero> = new Array<Hero>();
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var heroId:Hero.HeroID = button.get( "heroId" );
			if( heroId != null )
			{
				var hero:Hero = this._findHeroFromInnBuildingById( heroId );
				heroesArray.push( hero );
			}
		}
		return heroesArray;
	}

	private function _setPositionHeroesToDungeonFromArray( array:Array<Hero> ):Void
	{
		for( i in 0...array.length )
		{
			switch( i )
			{
				case 0: array[ i ].setPosition( "first" );
				case 1: array[ i ].setPosition( "second" );
				case 2: array[ i ].setPosition( "third" );
				case 3: array[ i ].setPosition( "fourth" );
				default: throw 'Error in State._setPositionHeroesToDungeonFromArray. Can not add position for "$i" in heroes array';
			}
		}
	}

}
