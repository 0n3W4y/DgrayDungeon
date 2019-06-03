package;

import openfl.display.Bitmap;

class Graphics extends Component
{
	private var _url:String;
	private var _url2:String;
	private var _x:Float;
	private var _y:Float;
	private var _text:String;
	private var _tx:Float;
	private var _ty:Float;
	private var _graphicsInstance:Bitmap;

	private var _addiction:String;

	private function _init( params:Dynamic ):Void
	{
		
	}

	public function new( parent:Entity, id:Int, params ):Void
	{
		super( parent, id, "graphics" );
		this._init( params );
	}

	public function getUrl( value:Int ):String
	{
		if( value == 0 )
			return this._url;
		else
			return this._url2;
	}

	public function setUrl( url:Int value:String ):Void
	{
		if( url == 0 )
			this._url = value;
		else
			this._url2 = value;
	}

	public function getText():String
	{
		return this._text;
	}

	public function setText( value:String ):Void
	{
		this._text = text;
	}

	public function getCoordinates():Dynamic
	{
		return { "x": this._x, "y": this._y };
	}

	public function setCoordinates( obj:String, x:Float, y:Float ):Void
	{
		if( obj == "img" )
		{
			this._x = x;
			this._y = y;
		}
		else
		{
			this._tx = x;
			this._ty = y;
		}
		
	}

	public function getGraphicsInstance():Bitmap
	{
		return this._graphicsInstance;
	}

	public function setGraphicsInstance( gi: Bitmap ):Void
	{
		this._graphicsInstance = gi;
	}

	public function setAddiction( value:String ):Void
	{
		this._addiction = value;
	}

	public function getAddiction():Void
	{
		return this._addiction;
	}
}