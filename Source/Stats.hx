package;

class Stats extends Component
{
	//baseStats
	private var _baseHp:Float;// Health Points;
	private var _baseAcc:Float;// Accuricy % // choose number of damage, if acc 100% always use max damage;
	private var _baseDdg:Float;// Dodge %
	private var _baseBlock:Float; // block with shield;
	private var _baseCc:Float;// Critical Chanse
	private var _baseDef:Float;// defense
	private var _baseDmg:Float; // Damage
	private var _baseSpd:Float; // Speed	
	private var _baseStress:Float;// stress :D
	private var _baseCritDamage:Float;// multiply damage ( x2, x2.1 e.t.c ); //default 100 = 2x

	//totalStats
	private var _totalHp:Float; 
	private var _totalAcc:Float; 
	private var _totalDdg:Float;
	private var _totalBlock:Float;
	private var _totalCc:Float;
	private var _totalDef:Float;
	private var _totalDmg:Float;
	private var _totalSpd:Float;
	private var _totalStress:Float;
	private var _totalCritDamage:Float; 

	//current stats
	private var _currentHp:Float;
	private var _currentAcc:Float;
	private var _currentDdg:Float;
	private var _currentBlock:Float;
	private var _currentCc:Float; 
	private var _currentDef:Float; 
	private var _currentDmg:Float;	
	private var _currentSpd:Float;
	private var _currentStress:Float; 
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
	private var _totalDiseaseResist:Float;	
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
	private var _currentPosition:String; // "second";
	private var _target:Dynamic; // { "first": 100, "second": 80, "third": 90, "fourth": 70 }


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "stats" );
		this._effects = new Array();
		this._currentPosition = null;

		for( key in Reflect.fields ( params ) )
		{
			var value:Float = Reflect.getProperty( params, key );
			var value2:Dynamic = null;
			if( key == "position" || key == "target" )
				value2 = Reflect.getProperty( params, key );

			switch( key )
			{
				case "hp": this._baseHp = value;
				case "acc": this._baseAcc = value;
				case "ddg": this._baseDdg = value;
				case "blk": this._baseBlock = value;
				case "cc": this._baseCc = value;
				case "def": this._baseDef = value;
				case "dmg": this._baseDmg = value;
				case "spd": this._baseSpd = value;
				case "stress": this._baseStress = value;
				case "cd": this._baseCritDamage = value;
				case "stun": this._baseStunResist = value;
				case "poison": this._basePoisonResist = value;
				case "bleed": this._baseBleedResist = value; 
				case "diseas": this._baseDiseaseResist = value;
				case "debuff": this._baseDebuffResist = value;
				case "move": this._baseMoveResist = value;
				case "fire": this._baseFireResist = value;
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
		this.reCalculateTotalStats();
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
			case "diseas": this._totalDiseaseResist = value;
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
			case "blk": {if( type == "total" ) return this._totalBlock; else return this._currentBlock;}
			case "cc": {if( type == "total" ) return this._totalCc;  else return this._currentCc;}
			case "def": {if( type == "total" ) return this._totalDef;  else return this._currentDef;}
			case "dmg": {if( type == "total" ) return this._totalDmg;  else return this._currentDmg;}
			case "spd": {if( type == "total" ) return this._totalSpd;  else return this._currentSpd;}
			case "stress": {if( type == "total" ) return this._totalStress; else return this._currentStress;}
			case "cd": {if( type == "total" ) return this._totalCritDamage; else return this._currentCritDamage;}
			case "stun": {if( type == "total" ) return this._totalStunResist; else return this._currentStunResist;}
			case "poison": {if( type == "total" ) return this._totalPoisonResist; else return this._currentPoisonResist;}
			case "bleed": {if( type == "total" ) return this._totalBleedResist; else return this._currentBleedResist;}
			case "disease": {if( type == "total" ) return this._totalDiseaseResist; else return this._currentDiseaseResist;}
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

	public function setCurrentPosition( value:String ):Void
	{
		this._currentPosition = value;
	}

	public function getCurrentPosition( value:String ):String
	{
		return this._currentPosition;
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
		this._baseCritDamage += this._upCritDamage;
		this._baseStunResist += this._upStunResist; 
		this._basePoisonResist += this._upPoisonResist;
		this._baseBleedResist += this._upBleedResist;
		this._baseDiseaseResist += this._upDiseaseResist;
		this._baseDebuffResist += this._upDebuffResist;
		this._baseMoveResist += this._upMoveResist;
		this._baseFireResist += this._upFireResist;

		this.reCalculateTotalStats();
	}

	public function reCalculateTotalStats():Void
	{
		//TODO: get inventory and add all properties from items in slots;
		//TODO: get traits and add all extra stats drom traits;
		this._totalHp = this._baseHp;
		this._totalAcc = this._baseAcc;
		this._totalDdg = this._baseDdg;
		this._totalBlock = this._baseBlock;
		this._totalCc = this._baseCc;
		this._totalDef = this._baseDef;
		this._totalDmg = this._baseDmg;
		this._totalSpd = this._baseSpd;
		this._totalStress = this._baseStress;
		this._totalCritDamage = this._baseCritDamage;
		this._totalStunResist = this._baseStunResist;
		this._totalPoisonResist = this._basePoisonResist;
		this._totalBleedResist = this._baseBleedResist;
		this._totalDiseaseResist = this._baseDiseaseResist;
		this._totalDebuffResist = this._baseDebuffResist;
		this._totalMoveResist = this._baseMoveResist; 
		this._totalFireResist = this._baseFireResist;

		var setCurrentFromTotal = function()
		{
			this._currentHp = this._totalHp;
			this._currentAcc = this._totalAcc;
			this._currentDdg = this._totalDdg;
			this._currentBlock = this._totalBlock;
			this._currentCc = this._totalCc;
			this._currentDef = this._totalDef;
			this._currentDmg = this._totalDmg;
			this._currentSpd = this._totalSpd;
			this._currentStress = this._totalStress;
			this._currentCritDamage = this._totalCritDamage;
			this._currentStunResist = this._totalStunResist;
			this._currentPoisonResist = this._totalPoisonResist;
			this._currentBleedResist = this._totalBleedResist;
			this._currentDiseaseResist = this._totalDiseaseResist;
			this._currentDebuffResist = this._totalDebuffResist;
			this._currentMoveResist = this._totalMoveResist; 
			this._currentFireResist = this._totalFireResist;
		}

		if( this._parent == null )
		{
			setCurrentFromTotal();
			return;
		}

		var inventoryComponent:Dynamic = this._parent.getComponent( "inventory" );
		if( inventoryComponent != null )
		{
			var inventory:Array<Dynamic> = inventoryComponent.getInventory();
			for( i in 0...inventory.length )
			{
				var slot = inventory[ i ];
				var item = slot.item;
				if( item != null )
				{
					//TODO: get item params; and add it to total;
				}
				else
					continue;
			}
		}
		
		var skillsComponent:Dynamic = this._parent.getComponent( "skills" );
		if( skillsComponent != null )
		{
			var passiveSkills:Array<Dynamic> = this._parent.getComponent( "skills" ).getSkills( "passive" );
			for( key in Reflect.fields( passiveSkills ) )
			{
				var value:Dynamic = Reflect.getProperty( passiveSkills, key );
				var target:Array<Int> = value.target;
				var type:String = value.type;
				var action:String = value.action;
				var valueType:String = value.valueType;
				var targetStat:Array<String> = value.targetStat;
				var damageValue:Array<Int> = value.value;
				var dmgValue:Float = Math.floor( damageValue[ 0 ] + Math.random() * ( damageValue[ 1 ] - damageValue[ 0 ] + 1) );
				if( target[ 0 ] == 0 && type == "forever" && value.isStatic ) // we have array in target like [ 0 ] or [ 1, 2, 3 ] of [ -12340 ]; 0 == self
				{
					for( i in 0...targetStat.length )
					{
						switch( targetStat[ i ] )
						{
							case "hp": 
							{
								if( valueType == "percent")
									dmgValue = this._totalHp * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalHp += dmgValue;
							}
							case "def":
							{
								if( valueType == "percent")
									dmgValue = this._totalDef * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalDef += dmgValue;
							}
							case "acc":
							{
								if( valueType == "percent")
									dmgValue = this._totalAcc * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalAcc += dmgValue;
							}
							case "spd":
							{
								if( valueType == "percent")
									dmgValue = this._totalSpd * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalSpd += dmgValue;
							}
							case "ddg":
							{
								if( valueType == "percent")
									dmgValue = this._totalDdg * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalDdg += dmgValue;
							}
							case "blk":
							{
								if( valueType == "percent")
									dmgValue = this._totalBlock * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalBlock += dmgValue;
							}	
							case "critDmg":
							{
								if( valueType == "percent")
									dmgValue = this._totalCritDamage * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalCritDamage += dmgValue;
							}
							case "stress":
							{
								if( valueType == "percent")
									dmgValue = this._totalStress * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalStress += dmgValue;
							}
							case "cc":
							{
								if( valueType == "percent")
									dmgValue = this._totalCc * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalCc += dmgValue;
							}
							case "stun":
							{
								if( valueType == "percent")
									dmgValue = this._totalStunResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalStunResist += dmgValue;
							}
							case "posion":
							{
								if( valueType == "percent")
									dmgValue = this._totalPoisonResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalPoisonResist += dmgValue;
							}
							case "fire":
							{
								if( valueType == "percent")
									dmgValue = this._totalFireResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalFireResist += dmgValue;
							}
							case "move":
							{
								if( valueType == "percent")
									dmgValue = this._totalMoveResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalMoveResist += dmgValue;
							}
							case "bleed":
							{
								if( valueType == "percent")
									dmgValue = this._totalBleedResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalBleedResist += dmgValue;
							}
							case "debuff":
							{
								if( valueType == "percent")
									dmgValue = this._totalDebuffResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalDebuffResist += dmgValue;
							}
							case "disease":
							{
								if( valueType == "percent")
									dmgValue = this._totalDiseaseResist * dmgValue / 100;

								if( action == "substarct" )
									dmgValue = -dmgValue;

								this._totalDiseaseResist += dmgValue;
							}
						}
					}
				}
			}
		}
		var taritsComponent:Dynamic = this._parent.getComponent( "traits" );
		if( taritsComponent != null )
		{
			//TODO: firts do postive, than negative;
			// some traits can be use is some dungeons, need to check dungeon;
			var positiveTraits:Array<Dynamic> = this._parent.getComponent( "traits" ).getPositiveTraits();
			var negativeTraits:Array<Dynamic> = this._parent.getComponent( "traits" ).getNegativeTraits();
		}
		
	}
}