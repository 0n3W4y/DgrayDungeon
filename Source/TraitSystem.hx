package;

typedef TraitConfig =
{
	var Parent:Dynamic;
}

typedef Trait =
{
	var Type:String; // 'nevative', 'positiive';
	var Name:String; // 'goodboy';
	var Status:String; //'locked', 'unlocked';
}

class TraitSystem
{
	private var _parent:Dynamic;


	public function new( config:TraitConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in TraitSystem.init';
	}

	public function postInit( error:String ):Void
	{
		var err:String = '$error. Error in TraitSystem.postInit';
	}

	public function addTrait(  ):Void
	{

	}

	public function removeTrait( ):Void
	{

	}

	public function getTrait(  ):Trait
	{
		return null;
	}

	public function setStaticTrait(  ):Void
	{

	}
}
