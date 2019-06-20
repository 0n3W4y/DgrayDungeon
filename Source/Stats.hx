package;

class Stats extends Component
{
	private var _totalHp:Float; // Health Points;
	private var _currentHp:Float;
	private var _totalAcc:Float; // Accuricy %
	private var _currentAcc:Float;
	private var _totalDdg:Float; // Dodge %
	private var _currentDdg:Float;
	private var _currentCc:Float; // Critical Chanse
	private var _totalDef:Float;
	private var _currentDef:Float;
	private var _totalDmg:Float;
	private var _currentDmg:Float;
	private var _totalSpd:Float;
	private var _currentSpd:Float;
	private var _totalTiredness:Float;
	private var _currentTiredness:Float;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "traits" );
		for( key in Reflect.fields ( params ) )
		{
			var value = Reflect.getProperty( params, key );

		}

	}

	public function setCurrent( name:String, value:Float ):Void
	{
		switch( name )
		{
			case "hp": this._currentHp = value;
			case "acc": this._currentAcc = value;
			case "ddg": this._currentDdg = value;
			case "cc": this._currentCc = value;
			case "def": this._currentDef = value;
			case "dmg": this._currentDmg = value;
			case "spd": this._currentSpd = value;
			case "trd": this._currentTiredness = value;
			default: trace( "Error in Stats.setCurrent, name can't be: " + name );
		}
	}

	public function setTotal( name:String, value:Float ):Void
	{
		switch( name )
		{
			case "hp": this._totalHp = value;
			case "acc": this._totalAcc = value;
			case "ddg": this._totalDdg = value;
			case "cc": this._totalCc = value;
			case "def": this._totalDef = value;
			case "dmg": this._totalDmg = value;
			case "spd": this._totalSpd = value;
			case "trd": this._totalTiredness = value;
			default: trace( "Error in Stats.setTotal, name can't be: " + name );
		}
	}

	public function get( name:String, type:String ):Float
	{
		switch( name )
		{
			case "hp": if( type == "total" ) return this._totalHp = value; else return this._currentHp;
			case "acc": if( type == "total" ) return this._totalAcc = value; else return this._currentAcc;
			case "ddg": if( type == "total" ) return this._totalDdg = value;  else return this._currentDdg;
			case "cc": if( type == "total" ) return this._totalCc = value;  else return this._currentCc;
			case "def": if( type == "total" ) return this._totalDef = value;  else return this._currentDef;
			case "dmg": if( type == "total" ) return this._totalDmg = value;  else return this._currentDmg;
			case "spd": if( type == "total" ) return this._totalSpd = value;  else return this._currentSpd;
			case "trd": if( type == "total" ) return this._totalTiredness = value;
			default: trace( "Error in Stats.get, name can't be: " + name + ", with type: " + type ); 
		}
	}
}