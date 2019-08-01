package;

import openfl.events.MouseEvent;

class Event extends Component
{
	private var _events:Array<String>;
	private var _currentEvent:String;
	private var _isCurrentEventDone:Bool;




	public function new(parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "event" );
		this._events = new Array();
		this._currentEvent = null;
		this._isCurrentEventDone = false;
	}

	public function getCurrentEvent():String
	{
		return this._currentEvent;
	}

	public function doneCurrentEvent():Void
	{
		this._isCurrentEventDone = true;
	}

	public function isDoneCurrentEvent():Bool
	{
		return this._isCurrentEventDone;
	}

	public function getEvents():Array<String>
	{
		return this._events;
	}

	public function addEvent( event:String ):Void
	{
		this._events.push( event );
	}

	public function removeEvent( event:String ):Void
	{	
		for( i in 0...this._events.length )
		{
			if( this._events[ i ] == event )
				this._events.splice( i, 1 );
		}
	}

	public function mouseClick( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mCLICK" && this._isCurrentEventDone )
			return;
		this._currentEvent = "mCLICK";
		this._isCurrentEventDone = false;
	}

	public function mouseUp( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mUP" && this._isCurrentEventDone )
			return;
		this._currentEvent = "mUP";
		this._isCurrentEventDone = false;
	}

	public function mouseDown( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mDOWN" && this._isCurrentEventDone )
			return;
		this._currentEvent = "mDOWN";
		this._isCurrentEventDone = false;
	}

	public function mouseOut( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mOUT" && this._isCurrentEventDone )
			return;
		this._currentEvent = "mOUT";
		this._isCurrentEventDone = false;
	}

	public function mouseOver( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mOVER" && this._isCurrentEventDone )
			return;
		this._currentEvent = "mOVER";
		this._isCurrentEventDone = false;
	}

}
