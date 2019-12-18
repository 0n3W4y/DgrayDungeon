package;

class UI extends Component
{
	private var _isChoosen:Bool;
	private var _parentWindow:String;
	private var _currentOpen:String;
	private var _heroId:String;


	public function new( parent:Entity, params:Dynamic ):Void
	{
		super( parent, "ui" );
		this._isChoosen = false;
		this._parentWindow = params.parentWindow;
		this._currentOpen = null;
		this._heroId = null;
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

	public function getParentWindow():String
	{
		return this._parentWindow;
	}

	public function getCurrentOpen():String
	{
		return this._currentOpen;
	}

	public function setCurrentOpen( value:String ):Void
	{
		this._currentOpen = value;
	}

	public function setHeroId( value:String ):Void
	{
		this._heroId = value;
	}

	public function getHeroId():String
	{
		return this._heroId;
	}
}