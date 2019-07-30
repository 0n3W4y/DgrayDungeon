package;

import openfl.display.Sprite;

class Scene
{
	private var _parent:SceneSystem;
	private var _id:String;
	private var _name:String;
	private var _sceneSprite:Sprite;

	private var _aliveEntities:Dynamic;
	private var _objectEntities:Dynamic;
	private var _uiEntities:Dynamic;

	private var _backgroundImageURL:String;

	public function new( parent:SceneSystem, id:String, name:String ):Void
	{
		this._parent = parent;
		this._id = id;
		this._name = name;

		this._aliveEntities = 
		{
			"hero": new Array<Entity>(),
			"enemy": new Array<Entity>()
		};
		this._objectEntities = 
		{
			"buildings": new Array<Entity>(),
			"treasures": new Array<Entity>()
		};
		this._uiEntities = 
		{
			"windows": new Array<Entity>(),
			"buttons": new Array<Entity>()
		};
		this._sceneSprite = new Sprite();
	}

	public function update( time:Float ):Void
	{
		// update all Entities;
	}

	public function draw():Void //draw all scene
	{
		this._parent.getParent().getSystem( "graphics" ).drawScene( this );
	}

	public function unDraw():Void
	{
		this._parent.getParent().getSystem( "graphics" ).undrawScene( this );
	}

	public function showUi( uiName:String ):Void
	{
		this._parent.getParent().getSystem( "graphics" ).showUiObject( this, uiName );
	}

	public function hideUi( uiName:String ):Void
	{
		this._parent.getParent().getSystem( "graphics" ).hideUiObject( this, uiName );
	}

	public function show():Void
	{
		this._parent.getParent().getSystem( "graphics" ).showScene( this );
	}

	public function hide():Void
	{
		this._parent.getParent().getSystem( "graphics" ).hideScene( this );
	}

	public function getId():String
	{
		return this._id;
	}

	public function getParent():SceneSystem
	{
		return this._parent;
	}

	public function getName():String
	{
		return this._name;
	}

	public function getBackgroundImageURL():String
	{
		return this._backgroundImageURL;
	}

	public function setBackgroundImageURL( url:String ):Void
	{
		this._backgroundImageURL = url;
	}

	public function getSprite():Sprite
	{
		return this._sceneSprite;
	}

	public function getEntities( type:String ):Dynamic
	{
		switch( type )
		{
			case "ui": return this._uiEntities;
			case "alive": return this._aliveEntities;
			case "object": return this._objectEntities;
			default: trace( "Error in Scene.getEntites, can't get array with type: " + type + "." );
		}

		return null;
	}
}