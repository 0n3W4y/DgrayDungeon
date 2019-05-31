package;

class Entity
{
	private var _parent:EntitySystem;
	private var _id:Int;
	private var _type:String;
	private var _name:String;
	private var _components:Array<Component> = new Array();

	public function new( parent:EntitySystem, id:Int, type:String, name:String ):Void
	{
		this._parent = parent;
		this._id = id;
		this._type = type;
		this._name = name;
	}

	public function get( type:String ):Dynamic
	{
		switch( type )
		{
			case "parent": return this._parent;
			case "id": return this._id;
			case "type": return this._type;
			case "name": return this._name;
			default: trace( "Error in Entity.get, type can't be: " + type + "." );
		}
		return null;
	}

	public function getComponent( name:String ):Dynamic
	{
		for( i in 0...this._components.length )
		{
			var component = this._components[ i ];
			if( component.getName() == name )
				return component;
		}

		trace( "Error in Entity.getComponent, no component with name: " + name + "." );
		return null;
	}

	public function update( time:Float )
	{
		for( i in 0...this._components.length )
		{
			this._components[ i ].update( time );
		}
	}
}