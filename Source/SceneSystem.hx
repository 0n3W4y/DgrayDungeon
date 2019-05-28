package;

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array;
	private var _activeScene:Scene;

	private var _nextId:int = 0;

	private function _createId():Int
	{
		var id = _nextId;
		_nextId++;
		return id;
	}

	private function _addScene( scene:Scene ):Void
	{
		_scenesArray.push( scene );
	}



	public function new( parent:Game ):Void
	{
		_parent = parent;
		_scenesArray = new Array();
	}

	public function createScene():Scene;
	{
		var id = _createId();
		var scene = new Scene( this, id );
		return scene;
	}

	public function removeScene( scene:Scene ):Void
	{

	}

	public function doActiveScene( scene:Scene ):Void
	{
		if( _activeScene )
		{
			_activeScene.changeActive( false );
			_activeScene.unDraw();
		}

		_activeScene = scene;
		_activeScene.chageActive( true );
		_activeScene.draw();
	}

	


}