package;

import openfl.display.Sprite;

class Main extends Sprite
{
	private var _game:Game;
	private var _width:Int = 1920;
	private var _height:Int = 1080;
	private var _fps:Int = 60;

	private function _createGame():Void
	{
		this._game = new Game( _width, _height, _fps, this );
	}

	public function new():Void
	{
		super();
		this._createGame();
	}
}
