package;

import openfl.display.Sprite;

class Main extends Sprite
{
	private var _game:Game;
	private var _width:Int;
	private var _height:Int;
	private var _fps:Int;

	private function _createGame():Void
	{
		_game = new Game( _width, _height, _fps );
	}

	public function new():Void
	{
		super();
		_createGame();
	}
}
