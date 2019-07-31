package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Graphics extends Component
{
	private var _img:Dynamic; // { "normal": { "x": 0, "y": 0, "url": "//..." }, "pushed": { x, y , url }};
	private var _text:Dynamic; // { 'text1': { "text": "yuppei",x: 1, y:2 }, 'text2': { "text": "yuppieey", x: 1, y:2 } };

	private var _x:Float;
	private var _y:Float;
	private var _queue:Int;


	private var _graphicsInstance:Sprite;

	private var _events:Array<String>;
	private var _currentEvent:String;
	private var _isCurrentEventDone:Bool;



	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "graphics" );
		this._img = params.img;
		this._text = params.text;
		this._x = params.x;
		this._y = params.y;
		this._queue = params.queue;
		this._graphicsInstance = null;
		this._events = new Array();
		this._currentEvent = null;
		this._isCurrentEventDone = false;
	}

	public function moveTo( x:Float, y:Float ):Void
	{
		this._x = x;
		this._y = y;
		this._graphicsInstance.x = x;
		this._graphicsInstance.y = y;
	}

	public function move( x:Float, y:Float ):Void
	{
		this._x += x;
		this._y += y;
		this._graphicsInstance.x += x;
		this._graphicsInstance.y += y;
	}

	public function getImg():Dynamic
	{
		return this._img;
	}

	public function getText():Dynamic
	{
		return this._text;
	}

	public function getQueue():Int
	{
		return this._queue;
	}

	public function getCoordinates():Dynamic
	{
		return { "x": this._x, "y": this._y };
	}

	public function setCoordinates( x:Float, y:Float ):Void
	{
		this._x = x;
		this._y = y;
	}

	public function getGraphicsCoordinates():Dynamic
	{
		return { "x": this._graphicsInstance.x, "y": this._graphicsInstance.y };
	}

	public function setGraphicsCoordinates( x:Float, y:Float ):Void
	{
		this._graphicsInstance.x = x;
		this._graphicsInstance.y = y;		
	}

	public function getGraphicsInstance():Sprite
	{
		return this._graphicsInstance;
	}

	public function setGraphicsInstance( gi:Sprite ):Void
	{
		this._graphicsInstance = gi;
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