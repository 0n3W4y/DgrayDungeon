package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextField;


class EventSystem
{
	private var _parent:Game;
	private var _listeners:Array<Entity>;


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

	private function _doEvent( event:String, entity:Entity ):Void
	{
		switch( event )
		{
			case "mCLICK": this._mouseClick( entity );
			case "mUP": this._mouseUp( entity );
			case "mOUT": this._mouseOut( entity );
			case "mDOWN": this._mouseDown( entity );
			case "mOVER": this._mouseOver( entity );
		}
		entity.getComponent( "event" ).doneCurrentEvent();
	}

	private function _addToListeners( object:Entity ):Void
	{
		for( i in 0...this._listeners.length ) // chek if listener already in array;
		{
			var listener:Entity = this._listeners[ i ];
			if( listener.get( "id" ) == object.get( "id" ) )
				return;
		}
		this._listeners.push( object );
	}

	private function _removeFromListeners( object:Entity ):Void
	{
		for( i in 0...this._listeners.length )
		{
			if( object.get( "id" ) == this._listeners[ i ].get( "id" ) )
				this._listeners.splice( i, 1 );
		}
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



	public function new( parent:Game ):Void
	{
		this._parent = parent;
		this._listeners = new Array();
	}

	public function update():Void
	{
		for( i in 0...this._listeners.length )
		{
			var listener:Entity = this._listeners[ i ];
			var entityEvent:Event = listener.getComponent( "event" );
			var event:String = entityEvent.getCurrentEvent();
			var isDone:Bool = entityEvent.isDoneCurrentEvent();
			if( event != null && !isDone )
				this._doEvent( event, listener );
		}
		
	}	

	public function addEvent( object:Entity, eventName:String ):Void
	{
		var objectEvent:Dynamic = object.getComponent( "event" );
		var objectGraphics:Graphics = object.getComponent( "graphics" );
		var graphicsInstance:DisplayObjectContainer = objectGraphics.getGraphicsInstance();
		var event = null;
		var func = null;

		if( eventName == null )
		{
			graphicsInstance.addEventListener( MouseEvent.CLICK, objectEvent.mouseClick.bind( objectEvent ) );
			objectEvent.addEvent( "mCLICK" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_OVER, objectEvent.mouseOver.bind( objectEvent ) );
			objectEvent.addEvent( "mOVER" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_OUT, objectEvent.mouseOut.bind( objectEvent ) );
			objectEvent.addEvent( "mOUT" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_DOWN, objectEvent.mouseDown.bind( objectEvent ) );
			objectEvent.addEvent( "mDOWN" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_UP, objectEvent.mouseUp.bind( objectEvent ) );
			objectEvent.addEvent( "mUP" );	
		}
		else
		{
			switch( eventName ) 
			{
				case "mCLICK": { event = MouseEvent.CLICK; func = objectEvent.mouseClick.bind( objectEvent ); } 
				case "mOUT": { event = MouseEvent.MOUSE_OUT; func = objectEvent.mouseOut.bind( objectEvent ); }
				case "mOVER": { event = MouseEvent.MOUSE_OVER; func = objectEvent.mouseOver.bind( objectEvent ); }
				case "mUP": { event = MouseEvent.MOUSE_UP; func = objectEvent.mouseUp.bind( objectEvent ); }
				case "mDOWN": { event = MouseEvent.MOUSE_DOWN; func = objectEvent.mouseDown.bind( objectEvent ); }
			}
			graphicsInstance.addEventListener( event, func );
			objectEvent.addEvent( eventName );	
		}
		this._addToListeners( object );	
	}

	public function removeEvent( object:Entity, eventName:String  ):Void
	{
		var objectEvent:Dynamic = object.getComponent( "event" );
		var events:Array<String> = objectEvent.getEvents();
		var objectGraphics:Graphics = object.getComponent( "graphics" );
		var graphicsInstance:DisplayObjectContainer = objectGraphics.getGraphicsInstance();
		var event = null;
		var func = null;
		switch( eventName ) 
		{
			case "mCLICK": { event = MouseEvent.CLICK; func = objectEvent.mouseClick.bind( objectEvent ) ; } 
			case "mOUT": { event = MouseEvent.MOUSE_OUT; func = objectEvent.mouseOut.bind( objectEvent ); }
			case "mOVER": { event = MouseEvent.MOUSE_OVER; func = objectEvent.mouseOver.bind( objectEvent ); }
			case "mUP": { event = MouseEvent.MOUSE_UP; func = objectEvent.mouseUp.bind( objectEvent ); }
			case "mDOWN": { event = MouseEvent.MOUSE_DOWN; func = objectEvent.mouseDown.bind( objectEvent ); }
		}

		for( i in 0...events.length )
		{
			if( eventName == null )
			{
				switch ( events[ i ] )
				{
					case "mCLICK": graphicsInstance.removeEventListener( MouseEvent.CLICK, objectEvent.mouseClick.bind( objectEvent ) );
					case "mOUT": graphicsInstance.removeEventListener( MouseEvent.MOUSE_OUT, objectEvent.mouseOut.bind( objectEvent ) );
					case "mOVER": graphicsInstance.removeEventListener( MouseEvent.MOUSE_OVER, objectEvent.mouseOver.bind( objectEvent ) );
					case "mUP": graphicsInstance.removeEventListener( MouseEvent.MOUSE_UP, objectEvent.mouseUp.bind( objectEvent ) );
					case "mDOWN":  graphicsInstance.removeEventListener( MouseEvent.MOUSE_DOWN, objectEvent.mouseDown.bind( objectEvent ) );
				}
				//trace( events[ i ] + ";  " + object.get( "name" ) + "; " + events.length );
			}
			else
			{
				if( eventName == events[ i ] )
				{
					graphicsInstance.removeEventListener( event, func );
					objectEvent.removeEvent( eventName );
					if( objectEvent.getEvents().length == 0 )
						this._removeFromListeners( object );
					break;
				}
			}			
		}

		if( eventName == null )
		{
			objectEvent.cleanEventList();
			this._removeFromListeners( object );
		}
	}
}