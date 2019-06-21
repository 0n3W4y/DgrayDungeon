package;

class Skills extends Component
{
	private var _active:Array<Dynamic>;
	private var _passive:Array<Dynamic>;
	private var _camping:Array<Dynamic>;

	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "traits" );
		
	}
}