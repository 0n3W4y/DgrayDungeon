package;

class Scene
{
	private var _parent:SceneSystem;
	private var _id:Int;

	public function new( parent, id ):Void
	{
		_parent = parent;
		_id = id;
	}

	public function getId():Int
	{
		return _id;
	}

	public function getParent():SceneSystem
	{
		return _parent;
	}
}