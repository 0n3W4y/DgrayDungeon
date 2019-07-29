package;

import openfl.display.Sprite;

class Graphics extends Component
{
	private var _img:Dynamic; // { "normal": { "x": 0, "y": 0, "url": "//..." }, "pushed": { x, y , url }};
	private var _text:Dynamic; // { 'text1': { "text": "yuppei",x: 1, y:2 }, 'text2': { "text": "yuppieey", x: 1, y:2 } };

	private var _x:Float;
	private var _y:Float;

	private var _addiction:String;

	private var _graphicsInstance:Sprite;
	private var _textInstance:Sprite;



	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "graphics" );
		this._img = params.img;
		this._text = params.text;
		this._x = params.x;
		this._y = params.y;
		this._addiction = params.addiction;
		this._graphicsInstance = params.graphicsInstance;
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

	public function getTextInstance():Sprite
	{
		return this._textInstance;
	}

	public function setTextInstance( ti:Sprite ):Void
	{
		this._textInstance = ti;
	}

	public function getAddiction():String
	{
		return this._addiction;
	}
}