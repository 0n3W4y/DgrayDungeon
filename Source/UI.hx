package;

class UI extends Component
{
	private var _isChoosen:Bool = false;
	//private var _currentChildOpen:String = null;
	// this is child window is opened on parent window;



	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "ui" );
	}

	public function isChoosen():Bool
	{
		return this._isChoosen;
	}

	public function setIsChoosen( value:Bool ):Void
	{
		this._isChoosen = value;
	}
}