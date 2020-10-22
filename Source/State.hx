package;

import Button.ButtonID;
import Window;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

typedef StateConfig =
{
	var Parent:Game;
}

typedef SelectedDungeon =
{
	var DungeonType:String;
	var DungeonDifficulty:String;
}

class State
{
	private var _parent:Game;
	private var _selectedDungeon:SelectedDungeon;


	public inline function new( config:StateConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		this._selectedDungeon = { DungeonType: null, DungeonDifficulty: null };

		if( this._parent == null )
			throw error + 'parent is null!';
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
		this._parent.createPlayer( 100 , "test player" );

		// start new game - create both scenes;
		var scene:Scene = sceneSystem.createScene( 1001 ); // main city scene;
		sceneSystem.createScene( 1002 );  // choose dungeon scene;

		sceneSystem.changeSceneTo( scene );
	}

	public function continueGame():Void
	{
		//TODO: show loading window();
		// get json file from save directory;
		// get all keys from json file;
		// create player, load his fields;
		// create cityScene, load all buildings,
		// 
	}

	public function optionsGame():Void
	{

	}

	// transfer this function into UI;
	public function openWindow( deployId:Int ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var activeWindow:Window = ui.findChildCitySceneMainWindow();
		switch( deployId )
		{
			case 3002, 3011, 3012, 3013, 3014, 3016, 3017, 3018, 3019, 3020: 
			{
				if( activeWindow == null )// значит на экране нет октрытых окон;
				{
					ui.showUiObject( WindowDeployID( 3001 )); // открываем главное окно сцены.
					ui.showUiObject( WindowDeployID( deployId )); // открываем дополнительное окно.
				}
				else
				{
					var activeWindowDeployId = activeWindow.get( "deployId" );
					ui.hideUiObject( activeWindowDeployId ); // скрываем ранее открытое окно.
					ui.showUiObject( WindowDeployID( deployId )); // открываем вызванное окно.
				}
				
			}
			case 3100: ui.showUiObject( WindowDeployID( deployId ));
			default: throw 'Error in State.openWindow. Can not open window "$deployId"';
		}
	}
	// transfer this function into UI;
	public function closeWindow( deployId:Int ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		switch( deployId )
		{
			case 3001: ui.closeAllActiveWindows();
			case 3100: this._closeWarningWindow();
			default: throw 'Error in State.closeWindow. Can not close window "$deployId"';
		}
	}

	public function startJourney():Void
	{
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		var currentSceneName:String = sceneSystem.getActiveScene().get( "name" );
		if( currentSceneName == "cityScene" )
		{
			var dungeonScene:Scene = sceneSystem.getSceneByName( "chooseDungeonScene" );
			sceneSystem.changeSceneTo( dungeonScene );
		}
		else
		{

			var choosenDungeon:Int = this._findChoosenDungeon(); // find active button in all windows on scene; { "dungeon": "cave", "difficulty": "easy" };
			if( choosenDungeon == null )
			{
				this._openWarninWindow( 'Please choose a dungeon');
				// или выбать первую кнопку, которая будет в списке :)
				return;
			}

			trace( choosenDungeon );


			var check:Bool = this._checkFullPartyHeroes();
			if( !check )
			{
				//TODO: сделать окно, которое спросит у игрока, хочет ли он продолжать в неполном составе.
				// показать окно, забиндить клавиши как ( cancel - closeWindow; "ok" - this._prepareToJourney; );
			}

			var heroes:Array<Hero> = this._findHeroToDungeon();
			this._prepareJourneyToDungeon( heroes, choosenDungeon );
		}
	}

	public function backToCitySceneFromChooseDungeon():Void
	{
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		var cityScene:Scene = sceneSystem.getSceneByName( "cityScene" );
		sceneSystem.changeSceneTo( cityScene );
	}

	public function innHeroListUp():Void
	{
		var buttonsArray:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ).get( "buttons" );
		var firstVisible:Button = null;
		var firstInvivisble:Button = null;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var buttonName:String = button.get( "name" );
			if( buttonName == "innWindowHeroButtonOrange" || buttonName == "innWindowHeroButtonGreen" || buttonName == "innWindowHeroButtonBlue" || buttonName == "innWindowHeroButtonWhite" )
			{
				var sprite:Sprite = button.get( "sprite" );
				if( sprite.visible && firstVisible == null ) // сначала ищем первого не скрытого.
					firstVisible = button;

				if( !sprite.visible && firstInvivisble == null && firstVisible != null ) // после ищем первого скрытого. По нему и ориентируемся.
				{
					firstInvivisble = button;
					break;
					// делаем брик, так как в списке последние будут скрытые - всегда. В аррее все стоит на своих местах и по аррэю отрисовываю
				}					
			}
			else
				continue;
		}

		if( firstInvivisble == null ) // мы дошли до конца списка и не обнаружили скрытых - значит мы у конца списка - ничего не делаем.
			return;

		var firstVisibleSprite:Sprite = firstVisible.get( "sprite" );
		firstVisibleSprite.visible = false;
		var firstInvivisbleSprite:Sprite = firstInvivisble.get( "sprite" );
		firstInvivisbleSprite.visible = true;
		this._redrawListOfHeroesInInnBuilding();
	}

	public function innHeroListDown():Void
	{
		var buttonsArray:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ).get( "buttons" );
		var firstVisible:Button = null;
		var lastInvivisble:Button = null;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var buttonName:String = button.get( "name" );
			if( buttonName == "innWindowHeroButtonOrange" || buttonName == "innWindowHeroButtonGreen" || buttonName == "innWindowHeroButtonBlue" || buttonName == "innWindowHeroButtonWhite" )
			{
				var sprite:Sprite = button.get( "sprite" );
				if( !sprite.visible )
					lastInvivisble = button;
				else
				{
					firstVisible = button;
					break; // тормозим, так как мы нашли первого видимого, теперь проверяем, есть ли перед ним невидимый. если нет - возвращаемся.
				}
					
			}
		}

		if( lastInvivisble == null )
			return; // список вниз больше не должен идти, так как мы достигли 1-й кнопки.
		else
		{
			var sprite:Sprite = lastInvivisble.get( "sprite" );
			sprite.visible = true;
		}			

		this._redrawListOfHeroesInInnBuilding();
	}

	public function chooseButton( name:String, id:Button.ButtonID ):Void
	{
		switch( name )
		{
			case "recruitHeroButtonWhite",
			"recruitHeroButtonBlue",
			"recruitHeroButtonGreen",
			"recruitHeroButtonOrange": this._chooseRecruitHeroButton( id );
			case "innWindowHeroButtonOrange",
			"innWindowHeroButtonBlue",
			"innWindowHeroButtonWhite",
			"innWindowHeroButtonGreen": this._chooseInnHeroButton( id );
			case "dungeonButtonEasy",
				 "dungeonButtonNormal",
				 "dungeonButtonHard",
				 "dungeonButtonExtreme": this._chooseDungeonButton( id );
			default: throw 'Error in State.chooseButton. Can not choose "$name"';
		}	
	}

	public function unchooseButton( name:String, id:Button.ButtonID ):Void
	{
		switch( name )
		{
			case "recruitHeroButtonWhite",
			"recruitHeroButtonBlue",
			"recruitHeroButtonGreen",
			"recruitHeroButtonOrange": this._unchooseRecruitHeroButton( id );
			case "innWindowHeroButtonOrange",
			"innWindowHeroButtonBlue",
			"innWindowHeroButtonWhite",
			"innWindowHeroButtonGreen": this._unchooseInnHeroButton( id );
			case "dungeonButtonEasy",
				 "dungeonButtonNormal",
				 "dungeonButtonHard",
				 "dungeonButtonExtreme": this._unchooseDungeonButton( id );
			default: throw 'Error in State.unchooseButton. Can not unchoose "$name"';
		}	
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
			this._openWarninWindow( '$error not enough money' );
			this._unchooseRecruitHeroButton( button.get( "id" ));
			return;
		}

		if( !this._checkRoomInInnInventoryForHero() )
		{
			this._openWarninWindow( '$error not enough room in Inn' );
			this._unchooseRecruitHeroButton( button.get( "id" ));
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

	public function generateItemsForMerchantBuilding():Void
	{
		var scene:Scene = this._parent.getSystem( "scene" ).getSceneByName( "cityScene" );
		var building:Building = scene.getBuildingByDeployId( 2004 );
		var merchantWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3011 );
		// очищаем кнопки из окна мерчанта
		this._clearItemsfromMerchantBuilding( building, merchantWindow );

		var itemSlots:Int = building.get( "itemStorageMaxSlots" );

		for( i in 0...itemSlots )
		{
			var rarity:String = this._generateItemRarityForMerchantBuilding( building );
			var type:String = this._generateItemTypeForMerchantBuilding( building );
		}
		


		this._redrawListOfItemsInMerchantBuilding();
		var time:Float = this._parent.getSystem( "deploy" ).getBuilding( building.get( "deployId" )).generateItemEventTime;
		//this._parent.getSystem( "scene" ).createBuildingEvent( scene.get( "id" ), building.get( "id" ), "updateListOfItems", time );
	}

	public function generateHeroesForRecruitBuilding():Void
	{
		var scene:Scene = this._parent.getSystem( "scene" ).getSceneByName( "cityScene" );
		var building:Building = scene.getBuildingByDeployId( 2002 );
		var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 );
		// очищаем кнопки с окна и героев внутри здания
		this._clearHeroFromRecruitBuilding( building, recruitWindow );

		var heroSystem:HeroSystem = this._parent.getSystem( "hero" );
		var heroSlots:Int = building.get( "heroStorageSlotsMax" );
		var buildingLevel:Int = building.get( "upgradeLevel" );
		var rarityArray:Array<String> = this._parent.getSystem( "hero" ).get( "rarity" );
		var inverseLevel:Int = rarityArray.length - buildingLevel; // Высокий уровень здания добавит возможность добалять легендарных героев и ниже.
		// 1 lvl - only common; 2 lvl - common + uncommon; 3 lvl common + uncommon + rare; 4 lvl common + uncommon + rare + legendary;
		for( i in 0...heroSlots )
		{
			var rarityIndex:Int = Math.floor( Math.random() * ( rarityArray.length - inverseLevel ));
			var rarity:String = rarityArray[ rarityIndex ];
			var hero:Hero = heroSystem.generateHero( "random", rarity );
			building.addHero( hero );

			var heroButton:Button = this._createHeroButtonForRecruitBuilding( rarity );
			this._bindHeroAndButton( hero, heroButton );
			recruitWindow.addButton( heroButton );
		}
		// запускаем таймер на следюущую смену героев.
		this._redrawListOfHeroesInRecruitBuilding();
		var time:Float = this._parent.getSystem( "deploy" ).getBuilding( building.get( "deployId" )).generateHeroEventTime;
		this._parent.getSystem( "scene" ).createBuildingEvent( scene.get( "id" ), building.get( "id" ), "updateListOfRecruits", time );
	}


	public function unchooseActiveRecruitHeroButton():Void
	{
		var array:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 ).get( "buttons");//recruit window
		for( i in 0...array.length )
		{
			var button:Button = array[ i ];
			if( button.get( "activeStatus" ))
			{
				button.changeActiveStatus();
				var sprite:Sprite = button.get( "sprite" ).getChildAt( 0 );
				sprite.getChildAt( 2 ).visible = false;
				break; // Выбрана может быть только 1 кнопка.

			}
		}
	}

	public function clearAllChooseHeroToDungeonButton():Void
	{
		var buttons:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3004 ).get( "buttons" ); // chooseHeroToDungeon Window deploy id is 3004;
		for( i in 0...buttons.length )
		{
			var button:Button = buttons[ i ];
			var heroId:Hero.HeroID = button.get( "heroId" );
			if( heroId != null )
				this._unchooseInnHeroButton( button.get( "id" ));
		}
	}


	public function unchooseActiveInnHeroButtonInCityScene():Void
	{
		var alreadyChoosenButton:Button = this._findChoosenInnHeroButtonInCityScene();
		if( alreadyChoosenButton != null )
		{
			this._unchooseInnHeroButton( alreadyChoosenButton.get( "id" ));
		}
	}

	public function unchooseHeroToDungeon( id:Button.ButtonID ):Void
	{
		//TODO: найти кнопку с id  героем, как у той, что кликнули и запустить функцию "убрать heroInnButton". Она запустит дальше цепочку функций.
		trace( 'ping' );
	}




	//PRIVATE


	private function _prepareJourneyToDungeon( array:Array<Hero>, dungeon:Int ):Void
	{
			//TODO:
			//1. open shop window, to buy staff for dungeon, like water, food, bandages, healthkits, shovel, e.t.c
			//2. Create dungeon by config,
			//3. Copy heroes to dungeon scene ( do shadow copy of each hero )
			//	this._setPositionHeroesToDungeonFromArray( array );
			return;
			trace( "go" );
			var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
			var scene:Scene = sceneSystem.createScene( dungeon );
			sceneSystem.changeSceneTo( scene );
	}


	private function _chooseHeroToDungeon( buttonId:Button.ButtonID ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var button:Button = this._findInnButtonById( buttonId );
		
		if( button.get( "activeStatus" ) )
		{
			this._unchooseInnHeroButton( buttonId );
			return;
		}

		var id:Hero.HeroID = button.get( "heroId" );
		var buttonsArray:Array<Button> = ui.getWindowByDeployId( 3004 ).get( "buttons" ); // chooseheroToDungeon Window deploy id 3004; 
		var isOk:Bool = false;
		for( i in 0...buttonsArray.length ) //  у  данного окна всего 4 кнопки.
		{
			var dungeonButton:Button = buttonsArray[ i ];
			var heroId:Hero.HeroID = dungeonButton.get( "heroId" );
			if( heroId == null )
			{
				dungeonButton.setHeroId( id );
				var hero:Hero = this._findHeroFromInnBuildingById( id );
				this._bindHeroAndButton( hero, dungeonButton );
				this._parent.getSystem( "event" ).addEvents( dungeonButton );
				isOk = true;
				break;
			}
		}

		if( !isOk )
			return; // no room for heroes into dungeon;

		// меняем статус кнопки героя в Inn Building. Для того, что бы он не был добавлен дважды.
		button.changeActiveStatus();
		var sprite:Sprite = button.get( "sprite" );
		sprite.x -= 40.0;
	}

	private function _unchooseHeroToDungeon( button:Button ):Void
	{
		if( button == null )
			throw 'Error in State._unchooseHeroToDungeon. Hero id is NULL!';


		button.setHeroId( null );
		button.get( "graphics" ).removeGraphicsAt( 2 ); // 2 index is portrait;
		this._parent.getSystem( "event" ).removeEvents( button ); // убираем ивенты с кнопки, что бы лишний раз не вызывать функции.

	}

	private function _bindHeroAndButton( hero:Hero, button:Button ):Void
	{
		var heroId:Hero.HeroID = hero.get( "id" );
		button.setHeroId( heroId );

		this._addHeroPortraitToButton( hero, button );

		var buttonName:String = button.get( "name" );
		if ( buttonName == "choosenHeroToDungeon" )
			return;
		
		this._addHeroTextToButton( hero, button );
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
		var heroButton:Button = this._createHeroButtonForInnBuilding( rarity );		
		this._bindHeroAndButton( hero, heroButton );
		innWindow.addButton( heroButton );
		
		// получаем знанчение со здания и записываем их в окно.
		var currentNumberOfHeroes:Int = innBuilding.get( "heroStorage" ).length;
		var maximumRoomForHeroes:Int = innBuilding.get( "heroStorageSlotsMax" );
		var textToInn:String = 'Inn | $currentNumberOfHeroes of $maximumRoomForHeroes';
		ui.setTextToWindow( 3006, textToInn , "counter" ); // Inn Window deploy id 3006;
	}

	private function _checkBoxInStorageInventoryForItem():Bool
	{
		//TODO: check this :D
		return false;
	}

	private function _removeHeroFromRecruitBuilding( hero:Hero, button:Button ):Hero
	{
		this._parent.getSystem( "event" ).removeEvents( button );
		var recruitWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 ); // recruit window have 3002 deploy id;
		recruitWindow.removeButton( button );
		this._parent.getSystem( "scene" ).getSceneByName( "cityScene" ).getBuildingByDeployId( 2002 ).removeHero( hero );
		return hero;
	}

	private function _removeItemFromMerchantBuilding( item:Item, button:Button ):Item
	{
		this._parent.getSystem( "event" ).removeEvents( button );
		var merchantWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3011); // merchant
		merchantWindow.removeButton( button );
		this._parent.getSystem( "scene" ).getSceneByName( "cityScene" ).getBuildingByDeployId( 2004 ).removeItem( item );
		return item;
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

	private function _redrawListOfItemsInMerchantBuilding():Void
	{
		var merchantWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3011 );
		var merchantWindowSprite:Sprite = merchantWindow.get( "sprite" );
		var windowWidth:Float = merchantWindowSprite.width;
		var buttonsArray:Array<Button> = merchantWindow.get( "buttons" );
		var counetrX:Int = 0;
		var counterY:Int = 0;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var name:String = button.get( "name" );
			if( name == "itemButton" )
			{
				var buttonSprite:Sprite = button.get( "sprite" );
				var deployId:Button.ButtonDeployID = button.get( "deployId" );
				var x:Float = this._parent.getSystem( "deploy" ).getButton( deployId ).x;
				var y:Float = this._parent.getSystem( "deploy" ).getButton( deployId ).y;
				var newX:Float = x + counetrX * buttonSprite.width;
				if( newX + buttonSprite.width >= windowWidth )
				{
					counterY++;
					counetrX = 0;
					newX = x;
					
				}
				var newY:Float = y + counterY * buttonSprite.height;
				buttonSprite.x = newX;
				buttonSprite.y = newY;
			}
		}
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
		var innWindowSprite:Sprite = innWindow.get( "sprite" );
		var maxSize:Float = innWindowSprite.height;
		var lastTotalY:Float = 0.0;
		var innWindowFull:Bool = false;
		for( i in 0...buttonsArray.length )
		{
			var button:Button = buttonsArray[ i ];
			var name:String = button.get( "name" );
			var buttonSprite:Sprite = button.get( "sprite" );
			if(( name == "innWindowHeroButtonOrange" || name == "innWindowHeroButtonBlue" || name == "innWindowHeroButtonWhite" || name == "innWindowHeroButtonGreen" ) && buttonSprite.visible )
			{
				// we can get Deploy ID from button, get sprite.y and add it;
				var deployId:Button.ButtonDeployID = button.get( "deployId" );
				var newY:Int = this._parent.getSystem( "deploy" ).getButton( deployId ).y;
				
				if( !innWindowFull )
				{
					var totalY:Float = counter * buttonSprite.height + newY;
					var nextTotalY:Float = ( counter + 1 ) * buttonSprite.height + newY;
					if( nextTotalY >= maxSize )
					{
						innWindowFull = true;
						buttonSprite.y = lastTotalY;
						buttonSprite.visible = false;
						continue;
					}
					else
					{
						buttonSprite.y = totalY;
						lastTotalY = totalY;
						counter++;
					}
				}
				else
				{
					buttonSprite.y = lastTotalY;
					buttonSprite.visible = false;
				}
			}
		}
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

	private function _findChoosenDungeon():Int
	{
		//TODO: Find active button, then find window where this button placed;
		// switch founded optiouns
		var difficulty:String = this._selectedDungeon.DungeonDifficulty;
		var dungeon:String = this._selectedDungeon.DungeonType;

		var difficultyNumber:Int = null;
		switch( difficulty )
		{
			case "easy": difficultyNumber = 0;
			case "normal": difficultyNumber = 1;
			case "hard": difficultyNumber = 2;
			case "extreme": difficultyNumber = 3;
			default: throw 'Error in State._findChoosenDungeon. There is no difficulty "$difficulty" in this dungeon';
		}

		switch( dungeon )
		{
			case "caveOne": return ( 1100 + difficultyNumber ); // in deployScene все сцены пронумерованы по возрастанию сложности.
			case "caveTwo": return null;
			default: throw 'Error in State._findChoosenDungeon. No dungeon found with name "$dungeon"';
		}

		return null;
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

	private function _findRecruitButtonById( id:Button.ButtonID ):Button
	{
		return this._parent.getSystem( "ui" ).getWindowByDeployId( 3002 ).getButtonById( id ); //recruit window
	}

	private function _findInnButtonById( id:Button.ButtonID ):Button
	{
		return this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 ).getButtonById( id ); //inn window
	}

	private function _chooseRecruitHeroButton( id:Button.ButtonID ):Void
	{
		var button:Button = this._findRecruitButtonById( id );
		this.unchooseActiveRecruitHeroButton();
		button.changeActiveStatus();
		var sprite:Sprite = button.get( "sprite" ).getChildAt( 0 );
		sprite.getChildAt( 2 ).visible = true;

	}

	private function _unchooseRecruitHeroButton( id:Button.ButtonID ):Void
	{
		var button:Button = this._findRecruitButtonById( id );
		button.changeActiveStatus();
	}	

	private function _chooseInnHeroButton( id:Button.ButtonID ):Void
	{
		var activeScene:Scene = this._parent.getSystem( "scene" ).getActiveScene();
		var sceneName:String = activeScene.get( "name" );
		//var ui:UserInterface = this._parent.getSystem( "ui" );
		var button:Button = this._findInnButtonById( id ); // кнопка, на которую нажали.
		if( sceneName == "cityScene" )
		{
			this.unchooseActiveInnHeroButtonInCityScene();

			button.changeActiveStatus();
			var buttonSprite:Sprite = button.get( "sprite" );
			buttonSprite.x -= 40.0; // выдвигаем кнопку влево на 40px;

			var activeWindow:Window = this._parent.getSystem( "ui" ).findChildCitySceneMainWindow();
			if( activeWindow == null )
			{
				// ни одного окна не открыто. Открываем стандартное окно для персонажа ( статистика. характеристики );
				this.openWindow( 3020 );
			}
			else
			{
				var activeWindowName:String = activeWindow.get( "name" );
				var activeWindowDeployId:Int = activeWindow.get( "deployId" );
				switch( activeWindowName )
				{
					case "citySceneHeroPropertiesWindow": trace( "ping" ); // TODO:
					default:
					{
						this.closeWindow( activeWindowDeployId ); // close activewindow neither citySceneheroProp
						this.openWindow( 3020 ); // citySceneHeroProp
					}
				}
			}
			//TODO: fill window new hero; Here;
			
		}
		else // chooseDungeonScene;
		{
			this._chooseHeroToDungeon( id );
		}
	}

	private function _unchooseInnHeroButton( id:Button.ButtonID ):Void
	{
		var activeScene:Scene = this._parent.getSystem( "scene" ).getActiveScene();
		var sceneName:String = activeScene.get( "name" );
		
		var button:Button = this._findInnButtonById( id );	
		button.changeActiveStatus();
		var buttonSprite:Sprite = button.get( "sprite" );
		buttonSprite.x = buttonSprite.x + 40.0; // задвигаем кнопку обратно

		// приходится обманывать так haxe. так как он нихуя не понимает вызов getChildAt(0).getChildAt(1);
		var buttonGraphicsSprite:Sprite = button.get( "sprite" ).getChildAt( 0 );
		buttonGraphicsSprite.getChildAt( 2 ).visible = false; // убираем подсветку о выбранной кнопке.

		if( sceneName == "chooseDungeonScene" )
		{
			var buttonHeroId:Hero.HeroID = button.get( 'heroId' );
			var buttonsArray:Array<Button> = this._parent.getSystem( "ui" ).getWindowByDeployId( 3004 ).get( "buttons" ); // chooseHeroToDungeon Window deploy id 3004;
			var dungeonButton:Button = null;
			for( i in 0...buttonsArray.length ) //находим кнопку, которая соответсвуте кнопки в окне с выбором героя в данж.
			{
				dungeonButton = buttonsArray[ i ];
				var heroId:Hero.HeroID = dungeonButton.get( "heroId" );
				if( heroId == buttonHeroId )
					break;	// после того, как кнопка найдена, прерываем цикл и отправяем кнопку в функцию.
			}
			this._unchooseHeroToDungeon( dungeonButton );		
		}
	}

	private function _chooseDungeonButton( id:Button.ButtonID ):Void
	{
		var choosenDungeon:SelectedDungeon = { DungeonType: null, DungeonDifficulty: null };
		var windowAndButton:Dynamic = this._findWindowAndButtonOnChooseDungeonScene( id );
		if( windowAndButton == null )
			throw 'Error in State._chooseDungeonButton. Can not find button with id: "$id" on Choose Dungeon Scene';

		var buttonName:String = windowAndButton.button.get( "name" );
		switch( buttonName )
		{
			case "dungeonButtonEasy": choosenDungeon.DungeonDifficulty = "easy";
			case "dungeonButtonNormal": choosenDungeon.DungeonDifficulty = "normal";
			case "dungeonButtonHard": choosenDungeon.DungeonDifficulty = "hard";
			case "dungeonButtonExtreme": choosenDungeon.DungeonDifficulty = "extreme";
			default: throw 'Error in State._chooseDungeonButton. Can not find difficulty for button with name: "$buttonName".';
		}

		var windowName:String = windowAndButton.window.get( "name" );
		switch( windowName )
		{
			case "dungeonCaveOneWindow": choosenDungeon.DungeonType = "caveOne";
			default: throw 'Error in State._chooseDungeonButton. Can not find type of dungeon with window: "$windowName".';
		}

		//TODO: add text quest into quest window, add reward into quest window, add reward into state "reward" and add end poin of quest into state;
	}

	private function _unchooseDungeonButton( id:Button.ButtonID ):Void
	{
		this._selectedDungeon = { DungeonType: null, DungeonDifficulty: null };
		//TDOD: remove text quest from window ( clear ), remove reward from quest window ( clear ), remove end poind and reward from state;
	}

	private function _findChoosenInnHeroButtonInCityScene():Button
	{
		var innWindow:Window = this._parent.getSystem( "ui" ).getWindowByDeployId( 3006 );
		var buttonArray:Array<Button> = innWindow.get( "buttons" );
		for( i in 0...buttonArray.length )
		{
			var button:Button = buttonArray[ i ];
			var activeStatus:Bool = button.get( "activeStatus" );
			if( activeStatus )
				return button;
		}
		return null;
	}


	private function _addHeroPortraitToButton( hero:Hero, button:Button ):Void
	{
		var buttonGraphics:GraphicsSystem = button.get( "graphics" );
		var heroDeployId:Hero.HeroDeployID = hero.get( "deployId" );
		var heroDeployConfig:Dynamic = this._parent.getSystem( "deploy" ).getHero( heroDeployId );
		var urlHeroPortrait:String = heroDeployConfig.imagePortraitURL;
		var heroPortraitBitmap:Bitmap = new Bitmap( Assets.getBitmapData( urlHeroPortrait ));
		buttonGraphics.addGraphics( heroPortraitBitmap );
	}

	private function _addHeroTextToButton( hero:Hero, button:Button ):Void
	{
		var buttonName:String = button.get( "name" );
		var buttonGraphics:GraphicsSystem = button.get( "graphics" );
		var fullHeroName:String = hero.get( "fullName" );
		var heroClass:String = hero.get( "name" );
		var heroBuyPrice:Player.Money = hero.get( "buyPrice" );
		buttonGraphics.setText( fullHeroName, "first" );
		buttonGraphics.setText( heroClass, "second" );

		if( buttonName == "recruitHeroButtonWhite" || buttonName == "recruitHeroButtonBlue" || buttonName == "recruitHeroButtonOrange" || buttonName == "recruitHeroButtonGreen" )
			buttonGraphics.setText( '$heroBuyPrice', "third" );
	}

	private function _createHeroButtonForRecruitBuilding( rarity:String ):Button
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var button:Button = null;
		// создаем кнопку на основе легендарности героя ( отличие оконтовка )
		switch( rarity )
		{
			case "common": button = ui.createButton( 4015 );
			case "uncommon": button = ui.createButton( 4016 );
			case "rare": button = ui.createButton( 4017 );
			case "legendary": button = ui.createButton( 4018 );
			default: throw 'Error in State.generateHeroesForBuilding. Can not create button with rarity: "$rarity"';
		}
		this._parent.getSystem( "event" ).addEvents( button );
		return button;
	}

	private function _createHeroButtonForInnBuilding( rarity:String ):Button
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var button:Button = null;
		switch( rarity )
		{
			case "common": button = ui.createButton( 4019 );
			case "uncommon": button = ui.createButton( 4020 );
			case "rare": button = ui.createButton( 4021 );
			case "legendary": button = ui.createButton( 4022 );
			default: throw 'Error in State.generateHeroesForBuilding. Can not create button with rarity: "$rarity"';
		}
		this._parent.getSystem( "event" ).addEvents( button );
		return button;
	}

	private function _closeWarningWindow():Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var warningWindow:Window = ui.getWindowByDeployId( 3100 ); // warningWindow Deploy ID;
		ui.removeWindowFromUi( warningWindow.get( "deployId" ));
		ui.destroyWindow( warningWindow.get( "deployId" ));
	}

	private function _openWarninWindow( error:String ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var warningWindow:Window = ui.createWindow( 3100 ); // warningWindow Deploy ID;
		warningWindow.get( "graphics" ).setText( error, "first" );
		ui.addWindowOnUi( warningWindow.get( "deployId" ));
		this.openWindow( 3100 );
		// создать окно, доабвить на ui ( что бы у него был приоритет по z-index ), показать. Кнопка получит ивент на закрытие.
		
	}

	private function _clearHeroFromRecruitBuilding( building:Building, window:Window ):Void
	{
		var recruitWindowButtons:Array<Button> = window.get( "buttons" );
		var index:Int = 0;
		for( j in 0...recruitWindowButtons.length )
		{
			var button:Button = recruitWindowButtons[ index ];
			var buttonName:String = button.get( "name" );
			if( buttonName == "recruitHeroButtonWhite" || buttonName == "recruitHeroButtonBlue" || buttonName == "recruitHeroButtonOrange" || buttonName == "recruitHeroButtonGreen" )
			{
				var hero:Hero = building.getHeroById( button.get( "heroId" ));
				this._removeHeroFromRecruitBuilding( hero, button );
				continue;
			}
			index++;
		}	
	}

	private function _clearItemsfromMerchantBuilding( building:Building, window:Window ):Void
	{
		var merchantWindowButtons:Array<Button> = window.get( "buttons" );
		var index:Int = 0;
		for( i in 0...merchantWindowButtons.length )
		{
			var button:Button = merchantWindowButtons[ index ];
			var buttonName:String = button.get( "name" );
			if( buttonName == "itemButton" )
				{
					var item:Item = building.getItemById( button.get( "itemId" ));
					this._removeItemFromMerchantBuilding( item, button );
				}
			continue;
		}
		index++;

		//TODO;
	}

	private function _generateItemRarityForMerchantBuilding( building:Building ):String
	{
		//var itemSystem:ItemSystem = this._parent.getSystem( "item" );
		var buildingLevel:Int = building.get( "upgradeLevel" );
		//var rarityArray:Array<String> = itemSystem.get( "rarity" ); // я точно знаю, что всего 4 степени.
		// lvl 1 75% common, 25% uncommon;
		// lvl 2 50% common, 50% uncommon;
		// lvl 3 34% common, 33% uncommon, 33% rare;
		// lvl 4 25% common, 25% uncommon, 25% rare, 25% legendary;
		var rarity:String = "common";
		var randomNumber:Int = Math.floor( Math.random() * 100 ); // [ 0 - 99 ];
		switch( buildingLevel )
		{
			case 1: 
			{
				if ( randomNumber >= 75 )
					rarity = "uncommon";
			}
			case 2:
			{
				if( randomNumber >= 50 )
					rarity = "uncommon";
			}				
			case 3:
			{
				if( randomNumber < 33 )
					rarity = "uncommon";
				else if( randomNumber >= 67 )
					rarity = "rare";
			}
			case 4:
			{
				if( randomNumber < 25 )
					rarity = "uncommon";
				else if( randomNumber >= 50 && randomNumber < 75 )
					rarity = "rare";
				else if( randomNumber >= 75 )
					rarity = "legendary";
			}
		}
		return rarity;
		
	}

	private function _generateItemTypeForMerchantBuilding( building:Building ):String
	{
		var typesArray:Array<String> = [ "weapon", "armor", "acessory1", "acessory2" ];
		var randomType:String = typesArray[ Math.floor( Math.random() * typesArray.length )];
		return randomType;
	}

	private function _findWindowAndButtonOnChooseDungeonScene( id:Button.ButtonID ):Dynamic
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var windowsOnUi:Array<Window> = ui.get( "objectsOnUi" ); // all windows on scene;
		for( i in 0...windowsOnUi.length )
		{
			var window:Window = windowsOnUi[ i ];
			var button:Button = window.getButtonById( id );
			if( button != null )
				return { "window": window, "button": button };
		}

		return null;
	}

}
