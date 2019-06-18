package;

class UI extends Component
{
	private var _isChoosen:Bool = false;



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