package;

class Graphics extends Component
{
	private var _url:String; // unpushed
	private var _url2:String; // pushed
	private var _x:Float;
	private var _y:Float;
	private var _text:String;

	public function new( parent:Entity, id:Int ):Void
	{
		super( parent, id, "graphics" );
	}

	public function getUrl( value ):String
	{
		if( value == 0 )
			return this._url;
		else
			return this._url2;
	}

	public function getText():String
	{
		return this._text;
	}

	public function getCoordinates():Dynamic
	{
		return { "x": this._x, "y": this._y };
	}

	public function setUrl( url:Int, value:String ):Void
	{
		if( url == 0 )
			this._url = value;
		else
			this._url2 = value;
	}

	public function setCoordinates( x:Float, y:Float ):Void
	{
		this._x = x;
		this._y = y;
	}

	public function setText( value:String ):Void
	{
		this._text = text;
	}

}