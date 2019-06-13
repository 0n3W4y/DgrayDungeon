package;

import openfl.display.Sprite;

class Entity extends Sprite
{
	private var __parent:EntitySystem;
	private var __id:String;
	private var __type:String;
	private var _name:String;
	private var __components:Array<Component> = new Array();

	public function new( parent:EntitySystem, id:String, type:String, name:String ):Void
	{
		super();
		this.__parent = parent;
		this.__id = id;
		this.__type = type;
		this._name = name;
	}

	public function get( type:String ):Dynamic
	{
		switch( type )
		{
			case "parent": return this.__parent;
			case "id": return this.__id;
			case "type": return this.__type;
			case "name": return this._name;
			default: trace( "Error in Entity.get, type can't be: " + type + "." );
		};
		return null;
	}

	public function getComponent( name:String ):Dynamic
	{
		for( i in 0...this.__components.length )
		{
			var component = this.__components[ i ];
			if( component.getName() == name )
				return component;
		};

		trace( "Error in Entity.getComponent, no component with name: " + name + "." );
		return null;
	}

	public function update( time:Float )
	{
		for( i in 0...this.__components.length )
		{
			this.__components[ i ].update( time );
		};
	}

	public function addComponent( component:Component ):Void
	{
		this.removeComponent( component.getName() ); //check if component exist. Remove it if need;
		component.setParent( this );
		this.__components.push( component );
	}

	public function removeComponent( componentName:String ):Component
	{
		for( i in 0...this.__components.length )
		{
			var newComponentName = this.__components[ i ].getName();
			if( componentName == newComponentName )
			{
				var oldComponent = this.__components[ i ];
				this.__components.splice( i, 1 );
				return oldComponent;
			};

		};
		return null;
	}
}