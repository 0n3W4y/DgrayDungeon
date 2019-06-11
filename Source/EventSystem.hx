package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.events.Event;


class EventSystem
{
	private var _parent:Game;

	private function _addStartSceneButton( name:String, object:Sprite ):Void
	{
		switch( name )
		{
			case "startSceneStartButton": object.addEventListener( MouseEvent.CLICK, this._eventStartButtonClick );
			case "startSceneContinueButton": object.addEventListener( MouseEvent.CLICK, this._eventContinueButtonClick );
			case "startSceneOptionsButton": object.addEventListener( MouseEvent.CLICK, this._eventOptionButtonClick );
			case "startSceneAuthorsButton": object.addEventListener( MouseEvent.CLICK, this._eventAuthorsButtonClick );
			default: trace( "Error in EventSystem._addStartSceneButton, button with name " + name +", does not exist in case." );
		}

		object.addEventListener( MouseEvent.MOUSE_OVER, this._eventMouseOverButton );
		object.addEventListener( MouseEvent.MOUSE_OUT, this._eventMouseOutButton );
		object.addEventListener( MouseEvent.MOUSE_DOWN, this._eventMouseDownButton );
		object.addEventListener( MouseEvent.MOUSE_UP, this._eventMouseUpButton );
		
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
	}

	private function _eventMouseOutBuilding( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		sprite.getChildAt( 1 ).visible = false;
		sprite.getChildAt( 2 ).visible = false;
	}

	private function _eventMouseClickBuilding( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		trace( "Click: " + sprite.name );
	}



	public function new( parent:Game ):Void
	{
		this._parent = parent;
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

	public function removeEvent( object:Sprite, type:String ):Void
	{
		//object.hasEventListener( type: String );
		//object.removeEventListener( type: String );
	}
}