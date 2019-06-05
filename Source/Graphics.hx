package;

import openfl.display.Sprite;

class Graphics extends Component
{
	private var _url:String; // for buttons unpushed;
	private var _url2:String; // for buttons pushed;
	private var _x:Float;
	private var _y:Float;
	private var _text:Dynamic; // { 'text1': { "text": "yuppei",x: 1, y:2 }, 'text2': { "text": "yuppieey", x: 1, y:2 } };
	private var _addiction:String;
	private var _queue:Int;

	private var _graphicsInstance:Sprite;



	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "graphics" );
		this._url = params.url;
		this._url2 = params.url2;
		this._x = params.x;
		this._y = params.y;
		this._text = params.text;
		this._addiction = params.addiciton;
		this._queue = params.queue;
		this._graphicsInstance = params.graphicsInstance;
	}

	public function getUrl( value:Int ):String
	{
		if( value == 0 )
			return this._url;
		else
			return this._url2;
	}

	public function setUrl( url:Int, value:String ):Void
	{
		if( url == 0 )
			this._url = value;
		else
			this._url2 = value;
	}

	public function getText():Dynamic
	{
		return this._text;
	}

	public function setText( value:Dynamic ):Void
	{
		this._text = value;
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

	public function getGraphicsInstance():Sprite
	{
		return this._graphicsInstance;
	}

	public function setGraphicsInstance( gi:Sprite ):Void
	{
		this._graphicsInstance = gi;
	}

	public function getAddiction():String
	{
		return this._addiction;
	}

	public function getQueue():Int
	{
		return this._queue;
	}
}