package;

class GeneratorSystem
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _nextId:Int;
	private var _parent:Game;

	private var _itemDeploy:Dynamic;
	private var _windowDeploy:Dynamic;
	private var _buttonDeploy:Dynamic;
	private var _heroDeploy:Dynamic;
	private var _buildingDeploy:Dynamic;
	private var _sceneDeploy:Dynamic;

	private var _heroNames:Dynamic; // { "m": [ "Alex"], "w": [ "Stella" ]};
	private var _heroSurnames:Dynamic; // [ "Goldrich", "Duckman" ];


	public function new()
	{

	}

	public function preInit( parent:Game ):Array<Dynamic>
	{
		this._netxId = 0;
		this._parent = parent;
		if( this._parent == null )
			return [ null, "Error in GeneratorSystem.preInit. Parent is NULL" ];
		this._preInited = true;
	}

	public function init():Array<Dynamic>
	{

	}

	public function postInit():Array<Dynamic>
	{

	}

	public function generateHero():Array<Dynamic>
	{

	}

	public function generateBuilding():Array<Dynamic>
	{

	}

	public function generateItem():Array<Dynamic>
	{

	}

	public function generateScene():Array<Dynamic>
	{

	}

	public function generateWindow():Array<Dynamic>
	{

	}

	public function generateButton():Array<Dynamic>
	{

	}

	private function createId():Int
	{
		var result:Int = this._nextId;
		this._nextId++;
		return result;
	}

}