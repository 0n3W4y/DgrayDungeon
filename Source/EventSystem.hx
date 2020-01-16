package;

import openfl.events.MouseEvent;

class EventSystem
{
	private var _events:Array<String>;
	private var _currentEvent:String;
	private var _isCurrentEventDone:Bool;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;
	private var _parent:Dynamic;


	public function new():Void
	{
		
	}

	public function init( parent:Dynamic ):String
	{
		this._parent = parent;
		if( this._parent == null )
			return "Error in EventSystem.init. Parent is NULL";

		this._events = new Array();
		this._currentEvent = null;
		this._isCurrentEventDone = false;
		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in EventSystem.postInit. Init is FALSE";

		this._postInited = true;
		return "ok";
	}

	public function getCurrentEvent():String
	{
		return this._currentEvent;
	}

	public function doneCurrentEvent():Void
	{
		this._isCurrentEventDone = true;
	}

	public function isCurrentEventDone():Bool
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
		if( this._currentEvent == "mCLICK" )
			return;
		this._currentEvent = "mCLICK";
		this._isCurrentEventDone = false;
	}

	public function mouseUp( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mUP" )
			return;
		this._currentEvent = "mUP";
		this._isCurrentEventDone = false;
	}

	public function mouseDown( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mDOWN" )
			return;
		this._currentEvent = "mDOWN";
		this._isCurrentEventDone = false;
	}

	public function mouseOut( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mOUT" )
			return;
		this._currentEvent = "mOUT";
		this._isCurrentEventDone = false;
	}

	public function mouseOver( e:MouseEvent ):Void
	{
		if( this._currentEvent == "mOVER" )
			return;
		this._currentEvent = "mOVER";
		this._isCurrentEventDone = false;
	}

	public function cleanEventList():Void
	{
		this._events = new Array();
	}

}
