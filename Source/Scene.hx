package;

import openfl.display.Sprite;

class Scene extends Sprite
{
	private var _parent:SceneSystem;
	private var _id:Int;
	private var _name:String;


	private var _aliveEntities:Array<Entity> = new Array(); //copy from EntitySystem, for fast access;
	private var _objectEntities:Array<Entity> = new Array();
	private var _uiEntities:Array<Entity> = new Array(); // buttons, windows e.t.c

	private var _backgroundImageURL:String;

	public function new( parent:SceneSystem, id:Int, name:String ):Void
	{
		super();
		this._parent = parent;
		this._id = id;
		this._name = name;
	}

	public function draw():Void
	{
		this._parent.getParent().getSystem( "graphics" ).drawScene( this );
	}

	public function unDraw():Void
	{

	}

	public function addEntity( type:String, entity:Entity ):Void
	{	
		switch( type )
		{
			case "button", "window" : this._uiEntities.push( entity );
			default: trace( "Error in Scene.addEntity, can't add entity with type: " + type + "." );
		}
	}

	public function getId():Int
	{
		return _id;
	}

	public function getParent():SceneSystem
	{
		return _parent;
	}

	public function getName():String
	{
		return this._name;
	}

	public function getBackgroundImaheURL():String
	{
		return this._backgroundImageURL;
	}

	public function setBackgroundImageURL( url:String ):Void
	{
		this._backgroundImageURL = url;
	}
}