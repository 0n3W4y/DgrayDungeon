package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;


class EventSystem
{
	private var _parent:Game;
	private var _listeners:Array<Entity>;


	private function _clickButton( entity:Entity ):Void
	{
		var entityName:String = entity.get( "name" );
		switch( entityName )
		{
			case "gameStart":
			{
				var newScene = this._parent.getSystem( "scene" ).createScene( "cityScene" );
				this._parent.getSystem( "scene" ).doActiveScene( newScene );
			}
			case "gameContinue": //TODO: Load game if in Starts Scene. or just continue game and close "options" window;
			case "gameAuthors":
			{
				//TODO : Open window or start titles;
				trace( "Author: Alexey Power" );
			}
			case "gameOptions":
			{
				//TODO: Open options window
				trace( "Andddddd opeeeeeeen options window... ( magic xD )" );
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
			case "startJourney":
			{
				var currentScene = this._parent.getSystem( "scene" ).getActiveScene();
				var sceneName = currentScene.getName();
				if( sceneName == "cityScene" )
					trace( "go to scene choose dungeon" );
			}
			default: trace( "Error in EventSustem._clickButton, no button with name: " + entityName );
		}
	}

	private function _clickBuilding( entity:Entity ):Void
	{
		var entityName:String = entity.get( "name" );
		switch( entityName )
		{
			case "hospital": {};
			case "tavern":{};
			case "recruits" : {};
			case "storage": {};
			case "graveyard": {};
			case "blacksmith": {};
			case "hermit": {};
			case "merchant": {};
			case "questman": {};
			case "fontain": {};
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
		entity.getComponent( "graphics" ).doneCurrentEvent();
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
				//entitySprite.getChildAt( 1 ).visible = false; // hover invisible;
				//entityTextSprite.alpha = 0; // becase all text in building in 1 sprite have alpha = 1;
			}
			case "button":
			{
				entitySprite.getChildAt( 1 ).visible = false; // hover invisible;
				entitySprite.getChildAt( 2 ).visible = false; // unpushed visible;
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
				//entitySprite.getChildAt( 1 ).visible = true; // hover visible;
				//entityTextSprite.alpha = 1; // becase all text in building in 1 sprite have alpha = 0;
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
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance();
		//var entityTextSprite:Sprite = entityGraphics.getTextInstance();
		switch( entityType )
		{
			case "building":
			{

			}
			case "button":
			{
				//graphicsSprite.getChildAt( 2 ).visible = false; // unpushed visible;
			}
		}
	}

	private function _mouseDown( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance();
		//var entityTextSprite:Sprite = entityGraphics.getTextInstance();
		switch( entityType )
		{
			case "building":
			{

			}
			case "button":
			{
				//graphicsSprite.getChildAt( 2 ).visible = true; // pushed visible;
			}
		}
	}



	public function new( parent:Game ):Void
	{
		this._parent = parent;
		this._listeners = new Array();
	}

	public function update( time:Float ):Void
	{
		for( i in 0...this._listeners.length )
		{
			var listener:Entity = this._listeners[ i ];
			var graphics:Dynamic = listener.getComponent( "graphics" );
			var event:String = graphics.getCurrentEvent();
			var isDone:Bool = graphics.isDoneCurrentEvent();
			if( event != null && !isDone )
				this._doEvent( event, listener );
		}
		
	}	

	public function addEvent( object:Entity, eventName:String ):Void
	{
		var objectGraphics:Dynamic = object.getComponent( "graphics" );
		var graphicsInstance:Sprite = objectGraphics.getGraphicsInstance();
		var event = null;
		var func = null;

		if( eventName == null )
		{
			graphicsInstance.addEventListener( MouseEvent.CLICK, objectGraphics.mouseClick.bind( objectGraphics ) );
			objectGraphics.addEvent( "mCLICK" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_OVER, objectGraphics.mouseOver.bind( objectGraphics ) );
			objectGraphics.addEvent( "mOVER" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_OUT, objectGraphics.mouseOut.bind( objectGraphics ) );
			objectGraphics.addEvent( "mOUT" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_DOWN, objectGraphics.mouseDown.bind( objectGraphics ) );
			objectGraphics.addEvent( "mDOWN" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_UP, objectGraphics.mouseUp.bind( objectGraphics ) );
			objectGraphics.addEvent( "mUP" );	
		}
		else
		{
			switch( eventName ) 
			{
				case "mCLICK": { event = MouseEvent.CLICK; func = objectGraphics.mouseClick.bind( objectGraphics ); } 
				case "mOUT": { event = MouseEvent.MOUSE_OUT; func = objectGraphics.mouseOut.bind( objectGraphics ); }
				case "mOVER": { event = MouseEvent.MOUSE_OVER; func = objectGraphics.mouseOver.bind( objectGraphics ); }
				case "mUP": { event = MouseEvent.MOUSE_UP; func = objectGraphics.mouseUp.bind( objectGraphics ); }
				case "mDOWN": { event = MouseEvent.MOUSE_DOWN; func = objectGraphics.mouseDown.bind( objectGraphics ); }
			}
			graphicsInstance.addEventListener( event, func );
			objectGraphics.addEvent( eventName );	
		}
		this._addToListeners( object );	
	}

	public function removeEvent( object:Entity, eventName:String  ):Void
	{
		var objectGraphics:Dynamic = object.getComponent( "graphics" );
		var graphicsInstance:Sprite = objectGraphics.getGraphicsInstance();
		var events:Array<String> = objectGraphics.getEvents();
		var event = null;
		var func = null;
		switch( eventName ) 
		{
			case "mCLICK": { event = MouseEvent.CLICK; func = objectGraphics.mouseClick.bind( objectGraphics ) ; } 
			case "mOUT": { event = MouseEvent.MOUSE_OUT; func = objectGraphics.mouseOut.bind( objectGraphics ); }
			case "mOVER": { event = MouseEvent.MOUSE_OVER; func = objectGraphics.mouseOver.bind( objectGraphics ); }
			case "mUP": { event = MouseEvent.MOUSE_UP; func = objectGraphics.mouseUp.bind( objectGraphics ); }
			case "mDOWN": { event = MouseEvent.MOUSE_DOWN; func = objectGraphics.mouseDown.bind( objectGraphics ); }
		}

		for( i in 0...events.length )
		{
			if( eventName == null )
			{
				switch ( events[ i ] )
				{
					case "mCLICK": graphicsInstance.removeEventListener( MouseEvent.CLICK, objectGraphics.mouseClick.bind( objectGraphics ) );
					case "mOUT": graphicsInstance.removeEventListener( MouseEvent.MOUSE_OUT, objectGraphics.mouseOut.bind( objectGraphics ) );
					case "mOVER": graphicsInstance.removeEventListener( MouseEvent.MOUSE_OVER, objectGraphics.mouseOver.bind( objectGraphics ) );
					case "mUP": graphicsInstance.removeEventListener( MouseEvent.MOUSE_UP, objectGraphics.mouseUp.bind( objectGraphics ) );
					case "mDOWN":  graphicsInstance.removeEventListener( MouseEvent.MOUSE_DOWN, objectGraphics.mouseDown.bind( objectGraphics ) );
				}
				objectGraphics.removeEvent( events[ i ] );
			}
			else
			{
				if( eventName == events[ i ] )
				{
					graphicsInstance.removeEventListener( event, func );
					objectGraphics.removeEvent( eventName );
					if( objectGraphics.getEvents().length == 0 )
						this._removeFromListeners( object );
					break;
				}
			}			
		}		
	}
}