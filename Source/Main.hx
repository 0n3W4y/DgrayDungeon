package;

import openfl.display.Sprite;

class Main extends Sprite
{
	private var _game:Game;
	private var _width:Int = 1920;
	private var _height:Int = 1080;
	private var _fps:Int = 60;

	public function new():Void
	{
		super();
		this._game = new Game( this._width, this._height, this._fps, this );
		//TODO: extends sprite with entity class, then we can use  global click function to find this object and run function after click;
	}
}
