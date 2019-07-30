package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;


class EventSystem
{
	private var _parent:Game;
	private var _listeners:Array<Entity>;


	private function _clickButton( entity:Entity ):Void
	{
		var entityName:String = entity.get( "name" );
		switch( entityName )
		{
			case "startGame":
			{
				var newScene = this._parent.getSystem( "scene" ).createScene( "cityScene" );
				this._parent.getSystem( "scene" ).doActiveScene( newScene );
			}
			case "continueGame": //TODO: Load game if in Starts Scene. or just continue game and close "options" window;
			case "authorsGame":
			{
				//TODO : Open window or start titles;
				trace( "Author: Alexey Power" );
			}
			case "optionsGame":
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
		entity.getComponent( "graphics" ).clearCurrentEvent();
	}

	private function _addToListeners( object ):Void
	{
		this._listeners.push( object );
	}

	private function _removeFromListeners( object ):Void
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
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance();
		var entityTextSprite:Sprite = entityGraphics.getGraphicsText();
		switch( entityType )
		{
			case "building":
			{
				entitySprite.getChildAt( 1 ).visible = false; // hover invisible;
				entityTextSprite.alpha = 0; // becase all text in building in 1 sprite have alpha = 1;
			}
		}
	}

	private function _mouseOver( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance();
		var entityTextSprite:Sprite = entityGraphics.getGraphicsText();
		switch( entityType )
		{
			case "building":
			{
				entitySprite.getChildAt( 1 ).visible = true; // hover visible;
				entityTextSprite.alpha = 1; // becase all text in building in 1 sprite have alpha = 0;
			}
		}
	}

	private function _mouseUp( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance();
		var entityTextSprite:Sprite = entityGraphics.getGraphicsText();
		switch( entityType )
		{
			case "building":
			{

			}
		}
	}

	private function _mouseDown( entity:Entity ):Void
	{
		var entityType:String = entity.get( "type" );
		var entityGraphics:Dynamic = entity.getComponent( "graphics" );
		var entitySprite:Sprite = entityGraphics.getGraphicsInstance();
		var entityTextSprite:Sprite = entityGraphics.getGraphicsText();
		switch( entityType )
		{
			case "building":
			{

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
			if( event != null )
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
			graphicsInstance.addEventListener( MouseEvent.CLICK, objectGraphics.mouseClick.bind( object ) );
			objectGraphics.addEvent( "mCLICK" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_OVER, objectGraphics.mouseOver.bind( object ) );
			objectGraphics.addEvent( "mOVER" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_OUT, objectGraphics.mouseOut.bind( object ) );
			objectGraphics.addEvent( "mOUT" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_DOWN, objectGraphics.mouseDown.bind( object ) );
			objectGraphics.addEvent( "mDOWN" );

			graphicsInstance.addEventListener( MouseEvent.MOUSE_UP, objectGraphics.mouseUp.bind( object ) );
			objectGraphics.addEvent( "mUP" );	
		}
		else
		{
			switch( eventName ) 
			{
				case "mCLICK": { event = MouseEvent.CLICK; func = objectGraphics.mouseClick.bind( object ); } 
				case "mOUT": { event = MouseEvent.MOUSE_OUT; func = objectGraphics.mouseOut.bind( object ); }
				case "mOVER": { event = MouseEvent.MOUSE_OVER; func = objectGraphics.mouseOver.bind( object ); }
				case "mUP": { event = MouseEvent.MOUSE_UP; func = objectGraphics.mouseUp.bind( object ); }
				case "mDOWN": { event = MouseEvent.MOUSE_DOWN; func = objectGraphics.mouseDown.bind( object ); }
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
			case "mCLICK": { event = MouseEvent.CLICK; func = objectGraphics.mouseClick; } 
			case "mOUT": { event = MouseEvent.MOUSE_OUT; func = objectGraphics.mouseOut; }
			case "mOVER": { event = MouseEvent.MOUSE_OVER; func = objectGraphics.mouseOver; }
			case "mUP": { event = MouseEvent.MOUSE_UP; func = objectGraphics.mouseUp; }
			case "mDOWN": { event = MouseEvent.MOUSE_DOWN; func = objectGraphics.mouseDown; }
		}

		for( i in 0...events.length )
		{
			if( eventName == null )
			{
				switch ( events[ i ] )
				{
					case "mCLICK": graphicsInstance.removeEventListener( MouseEvent.CLICK, objectGraphics.mouseClick );
					case "mOUT": graphicsInstance.removeEventListener( MouseEvent.MOUSE_OUT, objectGraphics.mouseOut );
					case "mOVER": graphicsInstance.removeEventListener( MouseEvent.MOUSE_OVER, objectGraphics.mouseOVER );
					case "mUP": graphicsInstance.removeEventListener( MouseEvent.MOUSE_UP, objectGraphics.mouseUp );
					case "mDOWN":  graphicsInstance.removeEventListener( MouseEvent.MOUSE_DOWN, objectGraphics.mouseDown );
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