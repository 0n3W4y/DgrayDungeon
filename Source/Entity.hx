package;

class Entity
{
	private var _parent:EntitySystem;
	private var _id:String;
	private var _type:String;
	private var _name:String;
	private var _components:Array<Component> = new Array();

	public function new( parent:EntitySystem, id:String, type:String, name:String ):Void
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
		};
		return null;
	}

	public function getComponent( name:String ):Dynamic
	{
		for( i in 0...this._components.length )
		{
			var component = this._components[ i ];
			if( component.getName() == name )
				return component;
		};

		trace( "Error in Entity.getComponent, no component with name: " + name + "." );
		return null;
	}

	public function update( time:Float )
	{
		for( i in 0...this._components.length )
		{
			this._components[ i ].update( time );
		};
	}

	public function addComponent( component:Component ):Void
	{
		this.removeComponent( component.getName() ); //check if component exist. Remove it if need;
		component.setParent( this );
		this._components.push( component );
	}

	public function removeComponent( componentName:String ):Component
	{
		for( i in 0...this._components.length )
		{
			var newComponentName = this._components[ i ].getName();
			if( componentName == newComponentName )
			{
				var oldComponent = this._components[ i ];
				this._components.splice( i, 1 );
				return oldComponent;
			};

		};
		return null;
	}
}