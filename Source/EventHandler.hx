package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;


class EventHandler
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;
	private var _parent:Game;
	private var _listeners:Array<Dynamic>;

	public function new():Void
	{

	}

	public function preInit():String
	{
		this._listeners = new Array();
		this._preInited = true;
		return "ok";
	}

	public function init( parent:Game ):String
	{	
		this._parent = parent;
		if( this._parent == null )
			return "Error in EventHandler.preInit. Parent - Game = NULL";

		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		this._postInited = true;
		return "ok";
	}

	public function addRemoveEvent( object:Dynamic, eventName:String, job:String ):String
	{
		var result:String;
		if( job == "add" )
		{
			if( eventName == "all" )
				result = this._addEvents( object );
			else 
				result = this._addEvent( object, eventName );
		}
		else
		{
			if( eventName == "all" )
				result = this._removeEvents( object );
			else
				result = this._removeEvent( object, eventName );
		}
		return result;
	}

	public function update():Void
	{
		for( i in 0...this._listeners.length )
		{
			var listener:Dynamic = this._listeners[ i ];
			var eventSystem:EventSystem = listener.get( "event" );
			var currentEvent:String = eventSystem.getCurrentEvent();
			var isDone:Bool = eventSystem.isCurrentEventDone();
			if( currentEvent != null && !isDone )
				this._doEvent( currentEvent, listener );
		}
		
	}





	// PRIVATE


	private function _addEvent( object:Dynamic, eventName:String ):String
	{
		var sprite:Sprite = object.get( "sprite" );
		var eventSystem:Dynamic = object.get( "event" );
		switch( eventName ) 
		{
			case "mCLICK": sprite.removeEventListener( MouseEvent.CLICK, eventSystem.mouseClick.bind( eventSystem ) );
			case "mOUT": sprite.removeEventListener( MouseEvent.MOUSE_OUT, eventSystem.mouseOut.bind( eventSystem ) );
			case "mOVER": sprite.removeEventListener( MouseEvent.MOUSE_OVER, eventSystem.mouseOver.bind( eventSystem ) );
			case "mUP": sprite.removeEventListener( MouseEvent.MOUSE_UP, eventSystem.mouseUp.bind( eventSystem ) );
			case "mDOWN":  sprite.removeEventListener( MouseEvent.MOUSE_DOWN, eventSystem.mouseDown.bind( eventSystem ) );
			default: return "Error in EventHandler._addEvent. Event can't be: " + eventName; 
		}
		eventSystem.addEvent( "eventName" );

		this._addToListeners( object );	
		return "ok";
	}

	private function _addEvents( object:Dynamic ):String
	{
		var sprite:Sprite = object.get( "sprite" );
		if( sprite == null )
			return "Error in EventHandler._addEvents. Sprite is Null";
		var eventSystem:Dynamic = object.get( "event" );
		if( eventSystem == null )
			return "Error in EventHandler._addEvents. EventSystem is Null";

		sprite.addEventListener( MouseEvent.CLICK, eventSystem.mouseClick.bind( eventSystem ) );
		eventSystem.addEvent( "mCLICK" );

		sprite.addEventListener( MouseEvent.MOUSE_OVER, eventSystem.mouseOver.bind( eventSystem ) );
		eventSystem.addEvent( "mOVER" );

		sprite.addEventListener( MouseEvent.MOUSE_OUT, eventSystem.mouseOut.bind( eventSystem ) );
		eventSystem.addEvent( "mOUT" );

		sprite.addEventListener( MouseEvent.MOUSE_DOWN, eventSystem.mouseDown.bind( eventSystem ) );
		eventSystem.addEvent( "mDOWN" );

		sprite.addEventListener( MouseEvent.MOUSE_UP, eventSystem.mouseUp.bind( eventSystem ) );
		eventSystem.addEvent( "mUP" );

		this._addToListeners( object );
		return "ok";
	}

	private function _removeEvent( object:Dynamic, eventName:String ):String
	{
		var sprite:Sprite = object.get( "sprite" );
		if( sprite == null )
			return "Error in EventHandler._addEvents. Sprite is Null";
		var eventSystem:Dynamic = object.get( "event" );
		if( eventSystem == null )
			return "Error in EventHandler._addEvents. EventSystem is Null";

		switch( eventName ) 
		{
			case "mCLICK": sprite.removeEventListener( MouseEvent.CLICK, eventSystem.mouseClick.bind( eventSystem ) );
			case "mOUT": sprite.removeEventListener( MouseEvent.MOUSE_OUT, eventSystem.mouseOut.bind( eventSystem ) );
			case "mOVER": sprite.removeEventListener( MouseEvent.MOUSE_OVER, eventSystem.mouseOver.bind( eventSystem ) );
			case "mUP": sprite.removeEventListener( MouseEvent.MOUSE_UP, eventSystem.mouseUp.bind( eventSystem ) );
			case "mDOWN":  sprite.removeEventListener( MouseEvent.MOUSE_DOWN, eventSystem.mouseDown.bind( eventSystem ) );
			default: return "Error in EventHandler._removeEvent. Event can't be: " + eventName;
		}

		eventSystem.removeEvent( eventName );
		if( eventSystem.getEvents().length == 0 )
			this._removeFromListeners( object );

		return "ok";
	}

	private function _removeEvents( object:Dynamic ):String
	{
		var sprite:Sprite = object.get( "sprite" );
		if( sprite == null )
			return "Error in EventHandler._addEvents. Sprite is Null";
		var eventSystem:Dynamic = object.get( "event" );
		if( eventSystem == null )
			return "Error in EventHandler._addEvents. EventSystem is Null";

		var eventsArray:Array<String> = eventSystem.getEvents();
		for( i in 0...eventsArray.length )
		{
			switch( eventsArray[ i ] ) 
			{
				case "mCLICK": sprite.removeEventListener( MouseEvent.CLICK, eventSystem.mouseClick.bind( eventSystem ) );
				case "mOUT": sprite.removeEventListener( MouseEvent.MOUSE_OUT, eventSystem.mouseOut.bind( eventSystem ) );
				case "mOVER": sprite.removeEventListener( MouseEvent.MOUSE_OVER, eventSystem.mouseOver.bind( eventSystem ) );
				case "mUP": sprite.removeEventListener( MouseEvent.MOUSE_UP, eventSystem.mouseUp.bind( eventSystem ) );
				case "mDOWN":  sprite.removeEventListener( MouseEvent.MOUSE_DOWN, eventSystem.mouseDown.bind( eventSystem ) );
				default: return "Error in EventHandler._removeEvent. Event can't be: " + eventsArray[ i ];
			}
		}

		eventSystem.cleanEventList();
		this._removeFromListeners( object );
		return "ok";
	}

	private function _addToListeners( object:Dynamic ):Void
	{
		for( i in 0...this._listeners.length ) // chek if listener already in array;
		{
			var listener:Dynamic = this._listeners[ i ];
			if( listener.get( "id" ) == object.get( "id" ) )
				return;
		}
		this._listeners.push( object );
	}

	private function _removeFromListeners( object:Dynamic ):Void
	{
		for( i in 0...this._listeners.length )
		{
			if( object.get( "id" ) == this._listeners[ i ].get( "id" ) )
				this._listeners.splice( i, 1 );
		}
	}

	private function _doEvent( event:String, object:Dynamic ):Void
	{
		switch( event )
		{
			case "mCLICK": this._mouseClick( object );
			case "mUP": this._mouseUp( object );
			case "mOUT": this._mouseOut( object );
			case "mDOWN": this._mouseDown( object );
			case "mOVER": this._mouseOver( object );
			default: trace( "Error in EventHandler._doEvent. In object with name: '" + object.get( "name" ) + "', deploy id: '" + object.get( "deployId" ) + "' can't do event witn name: '" + event + "'" );
		}
		object.get( "event" ).doneCurrentEvent();
	}

	private function _mouseClick( object:Dynamic ):Void
	{
		var objectType:String = object.get( "type" );
		switch( objectType )
		{
			case "window": this._mouseClickWindow( object );
			case "button": this._mouseClickButton( object );
			case "hero": this._mouseClickHero( object );
			case "item": this._mouseClickItem( object );
			case "building": this._mouseClickBuilding( object );
			case "enemy": this._mouseClickEnemy( object );
			default: trace( "Error in EventHandler._mouseClick. Object type: '" + objectType + "' is not defined" );
		}
	}

	private function _mouseUp ( object:Dynamic ):Void
	{
		var objectType:String = object.get( "type" );
		switch( objectType )
		{
			case "window": this._mouseUpWindow( object );
			case "button": this._mouseUpButton( object );
			case "hero": this._mouseUpHero( object );
			case "item": this._mouseUpItem( object );
			case "building": this._mouseUpBuilding( object );
			case "enemy": this._mouseUpEnemy( object );
			default: trace( "Error in EventHandler._mouseUp. Object type: '" + objectType + "' is not defined" );
		}
	}

	private function _mouseDown ( object:Dynamic ):Void
	{
		var objectType:String = object.get( "type" );
		switch( objectType )
		{
			case "window": this._mouseDownWindow( object );
			case "button": this._mouseDownButton( object );
			case "hero": this._mouseDownHero( object );
			case "item": this._mouseDownItem( object );
			case "building": this._mouseDownBuilding( object );
			case "enemy": this._mouseDownEnemy( object );
			default: trace( "Error in EventHandler._mouseDown. Object type: '" + objectType + "' is not defined" );
		}
	}

	private function _mouseOut ( object:Dynamic ):Void
	{
		var objectType:String = object.get( "type" );
		switch( objectType )
		{
			case "window": this._mouseOutWindow( object );
			case "button": this._mouseOutButton( object );
			case "hero": this._mouseOutHero( object );
			case "item": this._mouseOutItem( object );
			case "building": this._mouseOutBuilding( object );
			case "enemy": this._mouseOutEnemy( object );
			default: trace( "Error in EventHandler._mouseOut. Object type: '" + objectType + "' is not defined" );
		}
	}

	private function _mouseOver ( object:Dynamic ):Void
	{
		var objectType:String = object.get( "type" );
		switch( objectType )
		{
			case "window": this._mouseOverWindow( object );
			case "button": this._mouseOverButton( object );
			case "hero": this._mouseOverHero( object );
			case "item": this._mouseOverItem( object );
			case "building": this._mouseOverBuilding( object );
			case "enemy": this._mouseOverEnemy( object );
			default: trace( "Error in EventHandler._mouseOver. Object type: '" + objectType + "' is not defined" );
		}
	}

	private function _mouseClickButton( object:Dynamic ):Void
	{

	}

	private function _mouseClickWindow( object:Dynamic ):Void
	{

	}

	private function _mouseClickHero( object:Dynamic ):Void
	{

	}

	private function _mouseClickItem( object:Dynamic ):Void
	{

	}

	private function _mouseClickBuilding( object:Dynamic ):Void
	{

	}

	private function _mouseClickEnemy( object: Dynamic ):Void
	{

	}

	private function _mouseUpButton( object:Dynamic ):Void
	{

	}

	private function _mouseUpWindow( object:Dynamic ):Void
	{

	}

	private function _mouseUpHero( object:Dynamic ):Void
	{

	}

	private function _mouseUpItem( object:Dynamic ):Void
	{

	}

	private function _mouseUpBuilding( object:Dynamic ):Void
	{

	}

	private function _mouseUpEnemy( object: Dynamic ):Void
	{

	}

	private function _mouseDownButton( object:Dynamic ):Void
	{

	}

	private function _mouseDownWindow( object:Dynamic ):Void
	{

	}

	private function _mouseDownHero( object:Dynamic ):Void
	{

	}

	private function _mouseDownItem( object:Dynamic ):Void
	{

	}

	private function _mouseDownBuilding( object:Dynamic ):Void
	{

	}

	private function _mouseDownEnemy( object: Dynamic ):Void
	{

	}

	private function _mouseOutButton( object:Dynamic ):Void
	{

	}

	private function _mouseOutWindow( object:Dynamic ):Void
	{

	}

	private function _mouseOutHero( object:Dynamic ):Void
	{

	}

	private function _mouseOutItem( object:Dynamic ):Void
	{

	}

	private function _mouseOutBuilding( object:Dynamic ):Void
	{

	}

	private function _mouseOutEnemy( object: Dynamic ):Void
	{

	}

	private function _mouseOverButton( object:Dynamic ):Void
	{

	}

	private function _mouseOverWindow( object:Dynamic ):Void
	{

	}

	private function _mouseOverHero( object:Dynamic ):Void
	{

	}

	private function _mouseOverItem( object:Dynamic ):Void
	{

	}

	private function _mouseOverBuilding( object:Dynamic ):Void
	{

	}

	private function _mouseOverEnemy( object: Dynamic ):Void
	{

	}

	

	/*
	private function _buyRecruit( sceneSystem:SceneSystem ):Void
	{
		//TODO: Button with check if some buttons with hero choose, then collect total price, check inventory money, check slots in inn - then do function buy;
		var entitySystem:EntitySystem = this._parent.getSystem( "entity" );
		var sceneButtonsArray:Array<Entity> = sceneSystem.getActiveScene().getEntities( "ui" ).button; // get active scene;
		var chooseButton:Array<Dynamic> = new Array(); // put buttons with @choosen@ to array;
		for( i in 0...sceneButtonsArray.length )
		{
			var button:Entity = sceneButtonsArray[ i ];
			if( button.get( "name" ) == "recruitWindowHeroButton" && button.getComponent( "ui" ).isChoosen() )
			{
				chooseButton.push( button );
			}
		}


		if( chooseButton.length == 0 ) // no buttons are choosen;
		{
			//trace( "No buttons have been choosed" );
			return;
		}

		// Find inventory of 2 buildings;
		var innInventory:Inventory = null;
		var recruitInventory:Inventory = null;
		var innBuilding:Entity = null;
		var arrayOfBuildings:Array<Entity> = sceneSystem.getActiveScene().getEntities( "object" ).building;
		for( j in 0...arrayOfBuildings.length )
		{
			var building:Entity = arrayOfBuildings[ j ];
			switch( building.get( "name" ) )
			{
				case "inn": { innInventory = building.getComponent( "inventory" ); innBuilding = building; }
				case "recruits": recruitInventory = building.getComponent( "inventory" );
				default:
				{
					if( innInventory != null && recruitInventory != null )
						break;
				}
			}
		}

		//check free slots on inn inventory;
		var freeSlotsInInventory:Int = 0;
		var innInventoryArray:Array<Dynamic> = innInventory.getInventory();
		for( k in 0...innInventoryArray.length )
		{
			if( innInventoryArray[ k ].item == null && innInventoryArray[ k ].isAvailable )
				freeSlotsInInventory++;
		}
		if( freeSlotsInInventory == 0 )
		{
			//open window with error" can't buy, cause no room in Inn for recruit";
			//trace( "No room in Inn for recruit." );
			return;
		}

		var recruitInventoryArray:Array<Dynamic> = recruitInventory.getInventory();
		var arrayForTransfer:Array<Dynamic> = new Array();
		for( g in 0...chooseButton.length )
		{
			var heroButton:Entity = chooseButton[ g ];
			var buttonHeroId:String = heroButton.getComponent( "ui" ).getHeroId();
			for( f in 0...recruitInventoryArray.length )
			{
				var hero:Entity = recruitInventoryArray[ f ].item;
				if( hero == null )
					continue;
				var heroId:String = hero.get( "id" );
				if( heroId == buttonHeroId )
				{
					arrayForTransfer.push( [ hero, heroButton ] );
					break;
				}
			}
		}

		//now we can do safe transfer and remove recruit button, create InnHeroButton;
		var uiSystem:UserInterface = this._parent.getSystem( "ui" );
		var recruitWindow:Entity = uiSystem.getWindow( "recruitWindow" );
		var recruitWindowSprite:Sprite = recruitWindow.getComponent( "graphics" ).getGraphicsInstance();
		var innWindowSprite:Sprite = innBuilding.getComponent( "graphics" ).getGraphicsInstance();
		for( o in 0...arrayForTransfer.length )
		{

			var array:Array<Dynamic> = arrayForTransfer[ o ];
			var transferHero:Entity = array[ 0 ]; // because hero entity in 0 index;
			var buttonToKill:Entity = array[ 1 ];
			innInventory.setItemInSlot( transferHero, null ); //set hero in first free slot;
			recruitInventory.removeItemFromSlot( transferHero, null ); //remove hero from inventory;
			var buttonSprite:Sprite = buttonToKill.getComponent( "graphics" ).getGraphicsInstance(); 
			recruitWindowSprite.removeChild( buttonSprite );
			entitySystem.removeEntity( buttonToKill );// kill button at all;
			var innButton:Entity = entitySystem.createInnHeroButton( transferHero );
			var scene:Scene = sceneSystem.getActiveScene();
			entitySystem.addEntityToScene( innButton, scene );
			var innButtonSprite:Sprite = this._parent.getSystem( "graphics" ).createObject( innButton );
			var multiplier:Int = -1; // because first we do mechanic, then graphic;
			for( p in 0...innInventoryArray.length )
			{
				var slot:Dynamic = innInventoryArray[ p ];
				if( slot.item != null )
					multiplier++;
			}
			if( multiplier == 0 )
				innButtonSprite.y += innButtonSprite.height * multiplier;
			else
				innButtonSprite.y = innButtonSprite.height * multiplier;

			innWindowSprite.addChild( innButtonSprite );
			var text:String = ( multiplier + 1 ) + "/" + innInventoryArray.length;
			innBuilding.getComponent( "graphics" ).getText().second = text;
			var innSprite:DisplayObjectContainer = innBuilding.getComponent( "graphics" ).getGraphicsInstance();
			var innSpriteTextField:TextField = innBuilding.getComponent( "graphics" ).getGraphicsInstance().getChildAt( 1 ).getChildAt( 1 );
			var innTextSprite:DisplayObjectContainer = this._parent.getSystem( "graphics" ).createTextSprite( innBuilding );
			innSpriteTextField.text = text;
			//trace( multiplier + "; " + innButtonSprite.y + "; " + innWindowSprite + "; " + innButtonSprite );
		}
	}
*/
/*
	private function _clickButton( entity:Entity ):Void
	{
		// graphics component -> graphicsInstance have child[0] - graphics, child[1] - text
		// text child -> 0, 1, 2, 3 - by queue;
		var entityName:String = entity.get( "name" );
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		switch( entityName )
		{
			case "gameStart":
			{
				var newScene = sceneSystem.createScene( "cityScene" );
				sceneSystem.switchSceneTo( newScene );
				newScene.draw();
			}
			case "gameContinue": //TODO: Load game if in Starts Scene. or just continue game and close "options" window;
			case "gameOptions":
			{
				//TODO: Open options window
				trace( "Aaaaaaaaaaand opeeeeeeen options window... ( magic xD )" );
			}
			case "innUp":
			{
				//TODO: list up heroes in ui window INN;
				trace( "hero list up" );
			}
			case "innDown":
			{
				//TODO: list down in ui window INN;
				trace( "hero list down" );
			}
			case "gameStartJourney":
			{
				var currentScene = sceneSystem.getActiveScene();
				var sceneName = currentScene.getName();
				if( sceneName == "cityScene" )
				{
					//TODO: check chooseDungeonScene in scenes array; create scene if need, draw scene;
					var chooseDungeonScene:Scene = sceneSystem.getScene( "chooseDungeonScene" );
					if( chooseDungeonScene == null )
					{
						var newScene:Scene = sceneSystem.createScene( "chooseDungeonScene" );
						sceneSystem.switchSceneTo( chooseDungeonScene );
					}
					else
					{
						sceneSystem.switchSceneTo( chooseDungeonScene );
					}
				}
				else
				{
					//TODO: check heroes in window ( check is choosen button on Inn window ) need 4 heroes to start journey, then check if choosen dungeon;
					trace( "Ok" );
				}
			}
			case "citySceneMainWindowClose" :
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );

				if( currentOpen == "recruitWindow")
				{
					var buttons:Array<Entity> = sceneSystem.getActiveScene().getEntities( "ui" ).button;
					for( i in 0...buttons.length )
					{
						var button:Entity = buttons[ i ];
						if( button.getComponent( "ui" ).isChoosen() && button.get( "name" ) ==  "recruitWindowHeroButton" )
							button.getComponent( "ui" ).setIsChoosen();
					}
				}
				ui.hideUiObject( "citySceneMainWindow" );
			}
			case "recruitHeroButton": //buy recruit;
			{
				this._buyRecruit( sceneSystem );
			}
			case "recruitWindowHeroButton":
			{
				entity.getComponent( "ui" ).setIsChoosen();
			}
			default: trace( "Error in EventSustem._clickButton, no button with name: " + entityName );
		}
	}

	private function _clickBuilding( entity:Entity ):Void
	{
		var entityName:String = entity.get( "name" );
		var ui:UserInterface = this._parent.getSystem( "ui" );

		switch( entityName )
		{
			case "academy":
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "hospital": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "tavern":
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "recruits": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );

				window.getComponent( "ui" ).setCurrentOpen( "recruitWindow" );
				ui.showUiObject( "citySceneMainWindow" );
				ui.showUiObject( "recruitWindow" );
			};
			case "storage": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "graveyard": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "blacksmith": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "hermit": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "merchant": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "questman": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );
			};
			case "fontain": 
			{
				var window:Entity = ui.getWindow( "citySceneMainWindow" );
				var currentOpen:String = window.getComponent( "ui" ).getCurrentOpen();
				if( currentOpen != null )
					ui.hideUiObject( currentOpen );
				window.getComponent( "ui" ).setCurrentOpen( null );
				ui.showUiObject( "citySceneMainWindow" );

			};
			default: trace( "Click this: " + entityName );
		}
	}

	private function _clickHero( entity:Entity ):Void
	{

	}

	private function _clickWindow ( entity:Entity ):Void
	{

	}

	

	

	

	private function _mouseClick( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" ); // hero, button, window, e.t.c;
		switch( entityType )
		{
			case "window": this._clickWindow( entity );
			case "button": this._clickButton( entity ); 
			case "building": this._clickBuilding( entity );
			case "hero": this._clickHero( entity );
		}
		this._mouseUp( entity );
	}

	private function _mouseOut( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 0 );
		var entityTextSprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 1 );
		switch( entityType )
		{
			case "building":
			{
				entitySprite.getChildAt( 1 ).visible = false; // hover invisible;
				entityTextSprite.alpha = 0; // becase all text in building in 1 sprite have alpha = 1;
			}
			case "button":
			{
				if( !entity.getComponent( "ui" ).isChoosen() )
				{
					entitySprite.getChildAt( 1 ).visible = false; // hover invisible;
					entitySprite.getChildAt( 2 ).visible = false; // unpushed visible;
				}				
			}
		}
	}

	private function _mouseOver( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 0 );
		var entityTextSprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 1 );
		switch( entityType )
		{
			case "building":
			{
				entitySprite.getChildAt( 1 ).visible = true; // hover visible;
				entityTextSprite.alpha = 1; // becase all text in building in 1 sprite have alpha = 0;
			}
			case "button":
			{
				entitySprite.getChildAt( 1 ).visible = true; // hover visible;
			}
		}
	}

	private function _mouseUp( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 0 );
		var entityTextSprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 1 );
		switch( entityType )
		{
			case "building": {}//do nothing;
			case "button":
			{
				if( !entity.getComponent( "ui" ).isChoosen() )
					entitySprite.getChildAt( 2 ).visible = false; // unpushed invisible;
			}
		}
	}

	private function _mouseDown( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 0 );
		var entityTextSprite:Sprite = entityGraphics.getGraphicsInstance().getChildAt( 1 );
		switch( entityType )
		{
			case "building":
			{

			}
			case "button":
			{
				entitySprite.getChildAt( 2 ).visible = true; // pushed visible;
			}
		}
	}





		

	

	
	*/
}