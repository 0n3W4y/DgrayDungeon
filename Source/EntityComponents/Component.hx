package;

class Component 
{
	private var _name:String;
	private var _id:Int;

	private var _parent:Entity;

	public function new( name:String, id:Int, parent:Entity ):Void
	{
		this._name = name;
		this._id = id;
		this._parent = parent;
	}

	public function update( time:Float ):Void
	{
		
	}

	public function getParent():Entity
	{
		return this._parent;
	}

}