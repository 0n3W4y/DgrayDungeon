package;

class EventSystem
{
	private var _parent:Dynamic;
	private var _events:Array<String>;

	private var _inited:Bool = false;
	private var _postInited:Bool = false;


	public function new():Void
	{

	}

	public function init( parent:Dynamic ):Void
	{
		this._parent = parent;
		if( parent == null )
			throw 'Error in EventSystem.init. Parent is: "$parent"';

		this._events = new Array<String>();
		this._inited = true;
	}

	public function postInit():Void
	{
		if( this._inited )
			throw 'Error in EventSystem.postInit. Init is FALSE';

		this._postInited = true;
	}

	public function addEvent( eventName:String ):Void
	{
		var checkEvent:Int = this._checkEvent( eventName );
		if( checkEvent != null )
			throw 'Error in Button.removeEvent. Button already have event with name: "$eventName"';
		this._events.push( eventName );
	}

	public function removeEvent( eventName:String ):Void
	{
		var checkEvent:Int = this._checkEvent( eventName );
		if( checkEvent == null )
			throw 'Error in Button.removeEvent. Button have not event with name: "$eventName"';
		
		this._events.splice( checkEvent, 1 );		
	}


	// PRIVATE


	private function _checkEvent( eventName:String ):Int
	{
		for( i in 0...this._events.length )
		{
			if( this._events[ i ] == eventName )
			{
				return i;
			}
		}
		return null;
	}
}