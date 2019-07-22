package;

class Stats extends Component
{
	//baseStats
	private var _baseHp:Float;
	private var _baseAcc:Float;
	private var _baseDdg:Float;
	private var _baseCc:Float;
	private var _baseDef:Float;
	private var _baseDmg:Float;
	private var _baseSpd:Float;
	private var _baseStress:Float;
	private var _baseCritDamage:Float;

	//totalStats
	private var _totalHp:Float; // Health Points;
	private var _totalAcc:Float; // Accuricy % // choose number of damage, if acc 100% always use max damage;
	private var _totalDdg:Float; // Dodge %
	private var _totalCc:Float;
	private var _totalDef:Float;
	private var _totalDmg:Float;
	private var _totalSpd:Float;
	private var _totalStress:Float;
	private var _totalCritDamage:Float; // multiply damaga ( x2, x2,1 e.t.c ); //default 100 = 2x

	//current stats
	private var _currentHp:Float;	
	private var _currentAcc:Float;	
	private var _currentDdg:Float;	
	private var _currentCc:Float; // Critical Chanse
	private var _currentDef:Float; // defense
	private var _currentDmg:Float; // Damage	
	private var _currentSpd:Float; // Speed	
	private var _currentStress:Float; // stress :D
	private var _currentCritDamage:Float;

	//params for all resistance;

	//base resistance;
	private var _baseStunResist:Float;
	private var _basePoisonResist:Float;
	private var _baseBleedResist:Float;
	private var _baseDiseaseResist:Float;
	private var _baseDebuffResist:Float;
	private var _baseMoveResist:Float;
	private var _baseFireResist:Float;

	//current resistance;
	private var _currentStunResist:Float;
	private var _currentPoisonResist:Float;
	private var _currentBleedResist:Float;
	private var _currentDiseaseResist:Float;
	private var _currentDebuffResist:Float;
	private var _currentMoveResist:Float;
	private var _currentFireResist:Float;

	//total resistance;
	private var _totalStunResist:Float;	
	private var _totalPoisonResist:Float;	
	private var _totalBleedResist:Float;	
	private var _totalDiseasResist:Float;	
	private var _totalDebuffResist:Float;	
	private var _totalMoveResist:Float;	
	private var _totalFireResist:Float;	

	//params for level up;
	private var _upHp:Float;
	private var _upAcc:Float;
	private var _upDdg:Float;
	private var _upCc:Float;
	private var _upDef:Float;
	private var _upDmg:Float;
	private var _upSpd:Float;
	private var _upStress:Float;
	private var _upCritDamage:Float;
	private var _upStunResist:Float;
	private var _upPoisonResist:Float;
	private var _upBleedResist:Float;
	private var _upDiseaseResist:Float;
	private var _upDebuffResist:Float;
	private var _upMoveResist:Float;
	private var _upFireResist:Float;

	private var _effects:Array<Dynamic>; // [ { effect1 }, { effect2 } ... ];
	private var _position:Dynamic; // { "first": 75, "second": 80, "third": 100, "fourth": 90 }
	private var _target:Dynamic; // { "first": 100, "second": 80, "third": 90, "fourth": 70 }

	private var _currentPosition:String;


	private function _reCalculateTotalStats():Void
	{
		//TODO: get inventory and add all properties from items in slots;
		//TODO: get traits and add all extra stats drom traits;
	}


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "stats" );
		this._effects = new Array();

		for( key in Reflect.fields ( params ) )
		{
			var value:Float = Reflect.getProperty( params, key );
			var value2:Dynamic = null;
			if( key == "position" || key == "target" )
				value2 = Reflect.getProperty( params, key );

			switch( key )
			{
				case "hp": {this._currentHp = value; this._totalHp = value; this._baseHp = value;}
				case "acc": {this._currentAcc = value; this._totalAcc = value;this._baseAcc = value;}
				case "ddg": {this._currentDdg = value; this._totalDdg = value;this._baseDdg = value;}
				case "cc": {this._currentCc = value; this._totalCc = value;this._baseCc = value;}
				case "def": {this._currentDef = value; this._totalDef = value;this._baseDef = value;}
				case "dmg": {this._currentDmg = value; this._totalDmg = value;this._baseDmg = value;}
				case "spd": {this._currentSpd = value; this._totalSpd = value;this._baseSpd = value;}
				case "stress": {this._currentStress = value; this._totalStress = value;this._baseStress = value;}
				case "cd": {this._currentCritDamage = value; this._totalCritDamage = value;this._baseCritDamage = value;}
				case "stun": {this._currentStunResist = value; this._totalStunResist = value;this._baseStunResist = value;}
				case "poison": {this._currentPoisonResist = value; this._totalPoisonResist = value;this._basePoisonResist = value;}
				case "bleed": {this._currentBleedResist = value; this._totalBleedResist = value;this._baseBleedResist = value;}
				case "diseas": {this._currentDiseaseResist = value; this._totalDiseasResist = value;this._baseDiseaseResist = value;}
				case "debuff": {this._currentDebuffResist = value; this._totalDebuffResist = value;this._baseDebuffResist = value;}
				case "move": {this._currentMoveResist = value; this._totalMoveResist = value;this._baseMoveResist = value;}
				case "fire": {this._currentFireResist = value; this._totalFireResist = value;this._baseFireResist = value;}
				case "upHp": this._upHp = value;
				case "upAcc": this._upAcc = value;
				case "upDdg": this._upDdg = value;
				case "upCc": this._upCc = value;
				case "upDef": this._upDef = value;
				case "upDmg": this._upDmg = value;
				case "upSpd": this._upSpd = value;
				case "upStress": this._upStress = value;
				case "upCd": this._upCritDamage = value;
				case "upStun": this._upStunResist = value;
				case "upPoison": this._upPoisonResist = value;
				case "upBleed": this._upBleedResist = value;
				case "upDiseas": this._upDiseaseResist = value;
				case "upDebuff": this._upDebuffResist = value;
				case "upMove": this._upMoveResist = value;
				case "upFire": this._upFireResist = value;
				case "position": this._position = value2;
				case "target": this._target = value2;
				default: trace( "Error in Stats.setCurrent, name can't be: " + key );
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
			case "stress": this._currentStress = value;
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
			case "stress": this._totalStress = value;
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
			case "stress": {if( type == "total" ) return this._totalStress; else return this._currentStress;}
			case "cd": {if( type == "total" ) return this._totalCritDamage; else return this._currentCritDamage;}
			case "stun": {if( type == "total" ) return this._totalStunResist; else return this._currentStunResist;}
			case "poison": {if( type == "total" ) return this._totalPoisonResist; else return this._currentPoisonResist;}
			case "bleed": {if( type == "total" ) return this._totalBleedResist; else return this._currentBleedResist;}
			case "diseas": {if( type == "total" ) return this._totalDiseasResist; else return this._currentDiseaseResist;}
			case "debuff": {if( type == "total" ) return this._totalDebuffResist; else return this._currentDebuffResist;}
			case "move": {if( type == "total" ) return this._totalMoveResist; else return this._currentMoveResist;}
			case "fire": {if( type == "total" ) return this._totalFireResist; else return this._currentFireResist;}
			default: { trace( "Error in Stats.get, name can't be: " + name + ", with type: " + type ); return null; }
		}
	}

	public function getEffects():Array<Dynamic>
	{
		return this._effects;
	}

	public function addEffect( effect:Dynamic ):Void
	{
		//TODO: add new effetc, calculate _current stats or add value from _current stats
	}

	public function removeEffect( effect:String ):Void
	{
		//TODO: remove effect, calculate _current stats or remove value from _current stats
	}

	public function levelUp():Void
	{
		this._baseHp += this._upHp;
		this._baseAcc += this._upAcc;
		this._baseDdg += this._upDdg;
		this._baseCc += this._upCc;
		this._baseDef += this._upDef;
		this._baseDmg += this._upDmg;
		this._baseSpd += this._upSpd;
		this._baseStress += this._upStress;
		this._baseStunResist += this._upStunResist; 
		this._basePoisonResist += this._upPoisonResist;
		this._baseBleedResist += this._upBleedResist;
		this._baseDiseasResist += this._upDiseaseResist;
		this._baseDebuffResist += this._upDebuffResist;
		this._baseMoveResist += this._upMoveResist;
		this._baseFireResist += this._upFireResist;

		this._reCalculateTotalStats();
	}
}