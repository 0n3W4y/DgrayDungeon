package;

import openfl.display.Sprite;

class Graphics extends Component
{
	private var _img:Dynamic; // { "normal": { "x": 0, "y": 0, "url": "//..." }, "pushed": { x, y , url }};
	private var _text:Dynamic; // { 'text1': { "text": "yuppei",x: 1, y:2 }, 'text2': { "text": "yuppieey", x: 1, y:2 } };

	private var _x:Float;
	private var _y:Float;
	private var _queue:Int;


	private var _graphicsInstance:Sprite;



	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "graphics" );
		this._img = params.img;
		this._text = params.text;
		this._x = params.x;
		this._y = params.y;
		this._queue = params.queue;
		this._graphicsInstance = null;
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

	public function setImg( value:Dynamic ):Void
	{
		this._img = value;
	}

	public function getText():Dynamic
	{
		return this._text;
	}

	public function setText( value:Dynamic ):Void
	{
		this._text = value;
	}

	public function getQueue():Int
	{
		return this._queue;
	}

	public function getCoordinates():Dynamic
	{
		return { "x": this._x, "y": this._y };
	}

	public function setCoordinates( coords:Dyanmic ):Void
	{
		this._x = coords.x;
		this._y = coords.y;
		if( this._graphicsInstance != null )
		{
			this._graphicsInstance.x = coords.x;
			this._graphicsInstance.y = coords.y;
		}
	}

	public function getGraphicsCoordinates():Dynamic
	{
		return { "x": this._graphicsInstance.x, "y": this._graphicsInstance.y };
	}

	public function setGraphicsCoordinates( coords:Dynamic ):Void
	{
		this._graphicsInstance.x = coords.x;
		this._graphicsInstance.y = coords.y;
		this._x = coords.x;
		this._y = coords.y;
	}

	public function getGraphicsInstance():Sprite
	{
		return this._graphicsInstance;
	}

	public function setGraphicsInstance( gi:Sprite ):Void
	{
		this._graphicsInstance = gi;
	}
}