package;

class Component 
{
	public var name:String;
	public var id:String;

	private var _parent:Entity;

	public function new( name:String, id:Int, parent:Entity ):Void
	{
		this.name = name;
		this.id = id;
		_parent = parent;
	}

	public function update(time:Float):Void
	{

	}

	public function getParent():Entity
	{
		return _parent;
	}

	public function setParent(parent:Entity):Void
	{
		_parent = parent;
	}
}