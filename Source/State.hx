package;

typedef StateConfig = 
{
	var Parent:Game;
}

class State
{
	private var _parent:Game;


	public inline function new( config:StateConfig ):Void
	{
		
	}

	public function init( error:String ):Void
	{
		
	}

	public function postInot():Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "parent": return this._parent;
			default: throw 'Error in State.get. No "$value" found.';
		}
	}
}