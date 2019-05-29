package;

import openfl.display.Sprite;
import openfl.display.Bitmap;

class Scene extends Sprite
{
	private var _parent:SceneSystem;
	private var _id:Int;
	private var _name:String;
	private var _active:Bool = false;

	private var _aliveEntities:Array<Entity> = new Array(); //copy from EntitySystem, for fast access;
	private var _objectEntities:Array<Entity> = new Array();

	private var _backgroundGraphics:Bitmap;

	public function new( parent:SceneSystem, id:Int, name:String ):Void
	{
		super();
		this._parent = parent;
		this._id = id;
		this._name = name;
	}

	public function draw():Void
	{
		var mainSprite = this._parent.getParent().getMainSprite();
		addChild( this._backgroundGraphics );
		//TODO : draw all entities on this scene;
		//TODO: draw UI;
	}

	public function unDraw():Void
	{

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

	public function getBackgroundGraphics():Bitmap
	{
		return this._backgroundGraphics;
	}

	public function setBackgoundGraphics( bitmap:Bitmap ):Void
	{
		this._backgroundGraphics = bitmap;
	}

	public function changeActive( bool:Bool )
	{
		this._active = bool;
	}
}