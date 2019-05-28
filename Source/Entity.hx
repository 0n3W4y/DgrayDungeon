package;

class Entity
{
	private var _parent:EntityManager;
	private var _id:Int;

	public function new( parent:EntityManager, id:Int ):Void
	{
		this._parent = parent;
		this._id = id;
	}

	public function getParent():EntityManager
	{
		return this._parent;
	}
}