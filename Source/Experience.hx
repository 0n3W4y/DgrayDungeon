package;

class Experience extends Component
{
	private var _lvl:Int;
	private var _exp:Int;

	private var _expToNextLvl:Int;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "experiance" );
	}

	public function levelUp():Void
	{
		// lvl * expToNext + (lvl-1) * expToNext;
		// 1* 100 + 0 = 100;
		// 2*100 + 1*100 = 300;
		// 3*100 + 2*100 = 500;
		// 4*100 + 3*100 = 700;
		var currentLvl = this._lvl;
		var expToNextLvl = this._expToNextLvl;
		var currentExp = this._exp;


	}
}