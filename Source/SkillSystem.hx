package;

typedef SkillConfig =
{
	var Parent:Dynamic;
}

typedef Skill =
{
	var Type:String; // 'passive', 'active', 'camping';
	var Name:String; // 'base attack';
	var Active:Bool; // выбран ли скил для боевой сцены.
}

class SkillSystem
{
	private var _parent:Dynamic;
	private var _maxActiveSkills:Int;
	private var _maxStaticActiveSkills:Int;
	private var _currentStaticActiveSkills:Int;
	private var _maxPassiveSkills:Int;
	private var _maxStaticPassiveSkills:Int;
	private var _currentStaticPassiveSkills:Int;
	private var _maxCampingSkills:Int;
	private var _maxStaticCampingSkills:Int;
	private var _currentStaticCampingSkills:Int;

	public function new( config:SkillConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in SkillSystem.init';
	}

	public function postInit( error:String ):Void
	{
		var err:String = '$error. Error in SkillSystem.postInit';
	}
}
