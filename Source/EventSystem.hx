package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;


class EventSystem
{
	private var _parent:Game;
	private var _listeners:Array<Entity>;


	private function _buyRecruit( sceneSystem:SceneSystem ):Void
	{
		//TODO: Button with check if some buttons with hero choose, then collect total price, check inventory money, check slots in inn - then do function buy;
		var arrayOfButtons:Array<Entity> = sceneSystem.getActiveScene().getEntities( "ui" ).button; //choose active scene, because this button available on 1 scene;
		var arrayOfChoosenButtons:Array<Entity> = new Array();
		for( i in 0...arrayOfButtons.length )
		{
			var button:Entity = arrayOfButtons[ i ];
			if( button.get( "name" ) == "recruitWindowHeroButton" && button.getComponent( "ui" ).isChoosen() )
			{
				arrayOfChoosenButtons.push( button );
			}
		}

		if( arrayOfChoosenButtons.length > 0 )
		{
			//TODO: buy items in array -> TODO function buy something;
			var innBuildingInventory:Inventory = null;
			var recruitBuildingInventory:Inventory = null;
			var arrayOfBuildings:Array<Entity> = sceneSystem.getActiveScene().getEntities( "object" ).building;
			for( j in 0...arrayOfBuildings.length )
			{
				var building:Entity = arrayOfBuildings[ j ];
				if( building.get( "name" ) == "inn" )
				{
					innBuildingInventory = building.getComponent( "inventory" );
					//trace( "inn inventory found");
				}
				else if( building.get( "name" ) == "recruits" )
				{
					recruitBuildingInventory = building.getComponent( "inventory" );
					//trace( "recruit inventory found" );
				}
				else
				{
					if( innBuildingInventory != null && recruitBuildingInventory != null )
						break;
				}
			}
			var freeSlotsInInventory:Int = 0;
			var innBuildingInventoryArray:Array<Dynamic> = innBuildingInventory.getInventory();
			for( k in 0...innBuildingInventoryArray.length )
			{
				if( innBuildingInventoryArray[ k ].item == null )
					freeSlotsInInventory++;
			}
			//trace ( "inventory = " + freeSlotsInInventory + "; length = " + arrayOfChoosenButtons.length + "; inventory = " + innBuildingInventoryArray );
			if( freeSlotsInInventory >= arrayOfChoosenButtons.length )
			{
				var recruitBuildingInventoryArray:Array<Dynamic> = recruitBuildingInventory.getInventory();
				var recruitArrayToTransfer:Array<Dynamic> = new Array<Dynamic>();
				for( h in 0...recruitBuildingInventoryArray.length )
				{
					var recruit:Entity = recruitBuildingInventoryArray[ h ].item;
					var recruitName:String = recruit.getComponent( "name" ).get( "fullName" );
					var recruitType:String = recruit.get( "name" );
					for( g in 0...arrayOfChoosenButtons.length )
					{
						var buttonGraphicsText:Dynamic = arrayOfChoosenButtons[ g ].getComponent( "graphics" ).getText();
						var buttonRecruitName = buttonGraphicsText.name.text;
						var buttonRecruitType = buttonGraphicsText.type.text;
						if( recruitName == buttonRecruitName && recruitType == buttonRecruitType )
						{
							var choosenButton:Entity = arrayOfChoosenButtons[ g ];
							recruitArrayToTransfer.push( [ recruit, choosenButton ] );
							break;
						}
					}
				}
				//trace( recruitArrayToTransfer );
				for( l in 0...recruitArrayToTransfer.length )
				{
					var heroButtonArray:Dynamic = recruitArrayToTransfer[ l ];
					innBuildingInventory.setItemInSlot( heroButtonArray[ 0 ], null ); // [ 0 ] - because we ha put recruit entity into array with button on 0 index;
					recruitBuildingInventory.removeItemFromSlot( heroButtonArray[ 0 ], null );
					//TODO: create buttons for Inn ;
					//TODO: remove buttons in recruit building;
					trace( "heroes stored into inventory Inn" );
				}
				//trace( innBuildingInventoryArray );
			}
			else
			{
				//TODO: open widnow to user, can't recruit - inn slots are full;
			}
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
				sceneSystem.doActiveScene( newScene );
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
			case "startStartJourney":
			{
				var currentScene = this._parent.getSystem( "scene" ).getActiveScene();
				var sceneName = currentScene.getName();
				if( sceneName == "cityScene" )
					trace( "go to scene choose dungeon" );
				else
				{
					//TODO: check all heroes in window, check choose dungeon, if OK -> open inventory + merchant;
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
					//TODO: clear choosen heroes to buy **;
					// for( i in 0...buttons.length ) button.getComponent("ui").isChoosen(false);
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
		var graphicsInstance:Sprite = objectGraphics.getGraphicsInstance();
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
		var graphicsInstance:Sprite = objectGraphics.getGraphicsInstance();
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