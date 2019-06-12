package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.events.Event;


class EventSystem
{
	private var _parent:Game;
	private var _eventListeners:Array<Dynamic>;

	private function _addStartSceneButton( name:String, object:Sprite ):Void
	{
		var arrayOfEvents:Array<Dynamic> = new Array();
		switch( name )
		{
			case "startSceneStartButton": 
			{
				object.addEventListener( MouseEvent.CLICK, this._eventStartButtonClick );
				arrayOfEvents.push( { "event": MouseEvent.CLICK, "eventFunction": this._eventStartButtonClick } );
			}
			case "startSceneContinueButton":
			{
				object.addEventListener( MouseEvent.CLICK, this._eventContinueButtonClick );
				arrayOfEvents.push( { "event": MouseEvent.CLICK, "eventFunction": this._eventContinueButtonClick } );
			}
			case "startSceneOptionsButton":
			{
				 object.addEventListener( MouseEvent.CLICK, this._eventOptionButtonClick );
				 arrayOfEvents.push( { "event": MouseEvent.CLICK, "eventFunction": this._eventOptionButtonClick } );
			}
			case "startSceneAuthorsButton":
			{
				object.addEventListener( MouseEvent.CLICK, this._eventAuthorsButtonClick );
				arrayOfEvents.push( { "event": MouseEvent.CLICK, "eventFunction": this._eventAuthorsButtonClick } );
			}
			default: trace( "Error in EventSystem._addStartSceneButton, button with name " + name +", does not exist in case." );
		}

		object.addEventListener( MouseEvent.MOUSE_OVER, this._eventMouseOverButton );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_OVER , "eventFunction": this._eventMouseOverButton} );

		object.addEventListener( MouseEvent.MOUSE_OUT, this._eventMouseOutButton );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_OUT , "eventFunction": this._eventMouseOutButton} );

		object.addEventListener( MouseEvent.MOUSE_DOWN, this._eventMouseDownButton );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_DOWN , "eventFunction": this._eventMouseDownButton} );

		object.addEventListener( MouseEvent.MOUSE_UP, this._eventMouseUpButton );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_UP , "eventFunction": this._eventMouseUpButton} );

		var listener = { "name": name, "events": arrayOfEvents };
		this._eventListeners.push( listener );
		
	}

	private function _addBuildingsScene( name:String, object:Sprite ):Void
	{
		switch( name )
		{
			case "hospital", "tavern", "recruits", "storage", "merchant", "questman", "academy": object.addEventListener( MouseEvent.CLICK, this._eventMouseClickBuilding );
			default: trace( "Error in EventSystem._addBuildingsScene, bulding with name " + name + ", does not exist in case." );
		}

		object.addEventListener( MouseEvent.MOUSE_OVER, this._eventMouseOverBuilding );
		object.addEventListener( MouseEvent.MOUSE_OUT, this._eventMouseOutBuilding );
	}

	private function _eventStartButtonClick( e:MouseEvent ):Void
	{
		//check if save file available, if yes - push new window to user, 2 button yes, no -> yes - start new game, no - load saved file;
		var newScene = this._parent.getSystem( "scene" ).createScene( "cityScene" );
		this._parent.getSystem( "scene" ).doActiveScene( newScene );
	}

	private function _eventContinueButtonClick( e:MouseEvent ):Void
	{
		trace( " continue ... load saved game from file??? ");
	}

	private function _eventOptionButtonClick( e:MouseEvent ):Void
	{
		// create new options window with buttons, text e.t.c
		trace( " Options window ");
	}

	private function _eventAuthorsButtonClick( e:MouseEvent ):Void
	{
		// create new owindow with autors
		trace( " Authors window ");
	}

	private function _eventMouseOverButton( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.parent.getChildAt( 2 ).visible = true;
	}

	private function _eventMouseOutButton( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.parent.getChildAt( 2 ).visible = false;
	}

	private function _eventMouseDownButton( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.parent.getChildAt( 1 ).visible = true;
	}

	private function _eventMouseUpButton( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.parent.getChildAt( 1 ).visible = false;
	}

	private function _eventMouseOverBuilding( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.getChildAt( 1 ).visible = true; // new image;
		sprite.getChildAt( 2 ).visible = true; // text
		//sprite.getChildAt( 3 ).visible = true; // text
	}

	private function _eventMouseOutBuilding( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.getChildAt( 1 ).visible = false;
		sprite.getChildAt( 2 ).visible = false;
		//sprite.getChildAt( 3 ).visible = false;
	}

	private function _eventMouseClickBuilding( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		trace( "Click: " + sprite.name );
	}



	public function new( parent:Game ):Void
	{
		this._parent = parent;
		this._eventListeners = new Array();
	}

	public function addEvent( name:String, object:Sprite ):Void
	{
		switch( name )
		{
			case "startSceneStartButton", "startSceneContinueButton", "startSceneOptionsButton", "startSceneAuthorsButton" : this._addStartSceneButton( name, object );
			case "hospital" : this._addBuildingsScene( name, object );
			default: trace( "Error in EventSystem.addEvent, type of event can't be: " + name + "." );
		}
		
	}

	public function removeEvent( name:String, object:Sprite, eventName:String  ):Void
	{
		var newEvent = null;
		switch( eventName ) 
		{
			case "mCLICK": newEvent = MouseEvent.CLICK;
			case "mOUT": newEvent = MouseEvent.MOUSE_OUT;
			case "mOVER": newEvent = MouseEvent.MOUSE_OVER;
			case "mUP": newEvent = MouseEvent.MOUSE_UP;
			case "mDOWN": newEvent = MouseEvent.MOUSE_DOWN;
		}
		//remove all; { "name": "button1", "events": [ { "event": MouseEvent.CLICK, "eventFunction": this._buttonClick } ] };
		for( i in 0...this._eventListeners.length ) 
		{
			var listener = this._eventListeners[ i ];
			if( name == listener.name )
			{
				var array:Array<Dynamic> = listener.events;
				for( j in 0...array.length )
				{
					if( newEvent == null )
						object.removeEventListener( array[ j ].event, array[ j ].eventFunction );
					else if( newEvent == array[ j ].event )
					{
						object.removeEventListener( array[ j ].event, array[ j ].eventFunction );
						listener.events.splice( j, 1 );
						break;
					}
				}
				this._eventListeners.splice( i, 1 ); //remove object totally;
				break;
			}
		}
	}
}