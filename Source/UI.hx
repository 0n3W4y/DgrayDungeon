package;

class UI extends Component
{
	private var _isChoosen:Bool;
	private var _parentWindow:String;
	private var _currentOpen:String;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "ui" );
		this._isChoosen = false;
		this._parentWindow = params.parentWindow;
		this._currentOpen = null;
	}

	public function isChoosen():Bool
	{
		return this._isChoosen;
	}

	public function setIsChoosen():Void
	{
		if( this._isChoosen )
			this._isChoosen = false;
		else
			this._isChoosen = true;
	}
}