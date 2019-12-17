package;

class Component 
{
	private var _name:String;

	private var _parent:Entity;

	public function new( parent:Entity, name:String ):Void
	{
		this._name = name;
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

	public function setParent( parent:Entity ):Void
	{
		this._parent = parent;
	}

}