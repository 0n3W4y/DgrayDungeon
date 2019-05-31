package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.events.Event;

class EventSystem
{
	private var _parent:Game;


	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function addEventListener( object:Sprite, type:String ):Void
	{
		switch( type )
		{
			case "MOUSE_DOWN": object.addEventListener( MouseEvent.MOUSE_DOWN, this.eventListenerMouseDown );
			case "MOUSE_UP": object.addEventListener( MouseEvent.MOUSE_UP, this.eventListenerMouseDown );
			case "MOUSE_CLIKC": object.addEventListener( MouseEvent.CLICK, this.eventListenerMouseDown );
			default: trace( "Error in EventSystem.addEventListener, type of event can't be: " + type + "." );
		}
		
	}

	public function eventListenerMouseDown( e:MouseEvent ):Void
	{
		trace( "Mouse down" );

	}

	public function eventListenerMouseUp( e:MouseEvent ):Void
	{
		trace( "Mouse up" );
	}

	public function eventListenerMouseClick( e:MouseEvent ):Void
	{
		trace( "mouse click" );
	}

	public function removeEventListener( object:Sprite, type:String ):Void
	{
		
	}
}