package;

class Component 
{
	private var _name:String;
	private var _id:Int;

	private var _parent:Entity;

	public function new( parent:Entity, id:Int, name:String ):Void
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

	public function getName():String
	{
		return this._name;
	}

	public function getId():Int
	{
		return this._id;
	}

	public function setParent( parent:Entity ):Void
	{
		this._parent = parent;
	}

}