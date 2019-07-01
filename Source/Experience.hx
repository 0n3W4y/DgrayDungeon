package;

class Experience extends Component
{
	private var _lvl:Int;
	private var _exp:Int;
	private var _maxLvl:Int;

	private var _expToNextLvl:Int;
	private var _isMaxLvl:Bool = false;

	private function _levelUp():Void
	{
		// expToNext*2 - 25*lvl;
		// expToNext = 100;
		// 100*2 - 25*2 = 150;
		// 150*2 - 25*3  = 225;
		// 225*2 - 25*4 = 350;
		// 350*2 - 25*5 = 575;
		// 575*2 - 25*6 = 1000;
		this._lvl++;
		this._exp -= this._expToNextLvl;
		this._expToNextLvl = this._expToNextLvl*2 - 25*this._lvl;
		if( this._lvl == this._maxLvl )
			this._isMaxLvl = true;

		var statComponent = this._parent.getComponent( "stats" );
		if ( statComponent != null )
			statComponent.levelUp();
	}

	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "experiance" );
		this._lvl = params.lvl;
		this._expToNextLvl = params.expToNextLvl;
		this._exp = params.exp;
		this._maxLvl = maxLvl;
	}	

	public function addExp( value:Int ):Void
	{
		if( !this._isMaxLvl )
		{
			this._exp += value;
			if( this._exp >= this._expToNextLvl )
			{
				for( i in 0...this._maxLvl )
				{
					if( this._exp >= this._expToNextLvl && !this._isMaxLvl )
						this._levelUp();
					else
						break;
				}
				
			}
		}
	}

	public function get( value:String ):Int
	{
		switch( value )
		{
			case "lvl": return this._lvl;
			case "exp": return this._exp;
			default: return null;
		}
	}

	public function set( name:String, value:Int ):Void
	{
		switch( name )
		{
			case "lvl": this._lvl = value;
			case "exp": this._exp = value;
			case "maxLvl": this._maxLvl = value;
			case "expToNextLvl": this._expToNextLvl = value;
			case "isMaxLvl": { if( value == 0 ) this._isMaxLvl = false; else this._isMaxLvl = true; }
		}
	}
}