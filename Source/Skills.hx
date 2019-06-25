package;

class Skills extends Component
{
	private var _active:Array<Dynamic>;
	private var _passive:Array<Dynamic>;
	private var _camping:Array<Dynamic>;

	private var _maxActiveSkills:Int = 0;
	private var _maxStaticActiveSkills:Int = 0;
	private var _maxPassiveSkills:Int = 0;
	private var _maxStaticPassiveSkills:Int = 0;

	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "traits" );
		
	}
}