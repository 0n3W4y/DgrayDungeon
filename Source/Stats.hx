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
	private var _currentDef:Float; // defense
	private var _totalDmg:Float;
	private var _currentDmg:Float; // Damage
	private var _totalSpd:Float;
	private var _currentSpd:Float; // Speed
	private var _totalTiredness:Float;
	private var _currentTiredness:Float; // Tiredness :D
	private var _totalCritDamage:Float;
	private var _currentCritDamage:Float;

	private var _totalStunResist:Float;
	private var _currentStunResist:Float;
	private var _totalPoisonResist:Float;
	private var _currentPoisonResist:Float;
	private var _totalBleedResist:Float;
	private var _currentBleedResist:Float;
	private var _totalDiseasResist:Float;
	private var _currentDiseaseResist:Float;
	private var _totalDebuffResist:Float;
	private var _currentDebuffResist:FLoat;
	private var _totalMoveResist:Float;
	private var _currentMoveResist:Float;
	private var _totalFireResist:FLoat;
	private var _currentFireResist:Float;

	private var _effects:Array<Dynamic>;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "stats" );
		this._effects = new Array();

		for( key in Reflect.fields ( params ) )
		{
			var value = Reflect.getProperty( params, key );
			switch( key )
			{
				case "hp": {this._currentHp = value; this._totalHp = value;}
				case "acc": {this._currentAcc = value; this._totalAcc = value;}
				case "ddg": {this._currentDdg = value; this._totalDdg = value;}
				case "cc": {this._currentCc = value; this._totalCc = value;}
				case "def": {this._currentDef = value; this._totalDef = value;}
				case "dmg": {this._currentDmg = value; this._totalDmg = value;}
				case "spd": {this._currentSpd = value; this._totalSpd = value;}
				case "trd": {this._currentTiredness = value; this._totalTiredness = value;}
				case "cd": {this._currentCritDamage = value; this._totalCritDamage = value;}
				case "stun": {this._currentStunResist = value; this._totalStunResist = value;}
				case "poison": {this._currentPoisonResist = value; this._totalPoisonResist = value;}
				case "bleed": {this._currentBleedResist = value; this._totalBleedResist = value;}
				case "diseas": {this._currentDiseaseResist = value; this._totalDiseasResist = value;}
				case "debuff": {this._currentDebuffResist = value; this._totalDebuffResist = value;}
				case "move": {this._currentMoveResist = value; this._totalMoveResist = value;}
				case "fire": {this._currentFireResist = value; this._totalFireResist = value;}
				default: trace( "Error in Stats.setCurrent, name can't be: " + name );
			}
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
			case "stun": this._currentStunResist = value;
			case "poison": this._currentPoisonResist = value;
			case "bleed": this._currentBleedResist = value;
			case "diseas": this._currentDiseaseResist = value;
			case "debuff": this._currentDebuffResist = value;
			case "move": this._currentMoveResist = value;
			case "fire": this._currentFireResist = value;
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
			case "stun": this._totalStunResist = value; 
			case "poison": this._totalPoisonResist = value;
			case "bleed": this._totalBleedResist = value;
			case "diseas": this._totalDiseasResist = value;
			case "debuff": this._totalDebuffResist = value;
			case "move": this._totalMoveResist = value;
			case "fire": this._totalFireResist = value;
			default: trace( "Error in Stats.setTotal, name can't be: " + name );
		}
	}

	public function get( name:String, type:String ):Float
	{
		switch( name )
		{
			case "hp": {if( type == "total" ) return this._totalHp; else return this._currentHp;}
			case "acc": {if( type == "total" ) return this._totalAcc; else return this._currentAcc;}
			case "ddg": {if( type == "total" ) return this._totalDdg;  else return this._currentDdg;}
			case "cc": {if( type == "total" ) return this._totalCc;  else return this._currentCc;}
			case "def": {if( type == "total" ) return this._totalDef;  else return this._currentDef;}
			case "dmg": {if( type == "total" ) return this._totalDmg;  else return this._currentDmg;}
			case "spd": {if( type == "total" ) return this._totalSpd;  else return this._currentSpd;}
			case "trd": {if( type == "total" ) return this._totalTiredness; else return this._currentTiredness;}
			case "cd": {if( type == "total" ) return this._totalCritDamage; else return this._currentCritDamage;}
			case "stun": {if( type == "total" ) return this._totalStunResist; else return this._currentStunResist;}
			case "poison": {if( type == "total" ) return this._totalPoisonResist; else return this._currentPoisonResist;}
			case "bleed": {if( type == "total" ) return this._totalBleedResist; else return this._currentBleedResist;}
			case "diseas": {if( type == "total" ) return this._totalDiseasResist; else return this._currentDiseaseResist;}
			case "debuff": {if( type == "total" ) return this._totalDebuffResist; else return this._currentDebuffResist;}
			case "move": {if( type == "total" ) return this._totalMoveResist; else return this._currentMoveResist;}
			case "fire": {if( type == "total" ) return this._totalFireResist; else return this._currentFireResist;}
			default: trace( "Error in Stats.get, name can't be: " + name + ", with type: " + type ); 
		}
	}

	public function getEffects():Array
	{
		return this._effects;
	}

	public function addEffect( effect:Dynamic ):Void
	{

	}

	public function removeEffect( effect:String ):Void
	{

	}
}