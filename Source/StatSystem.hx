package;

typedef StatConfig =
{
	var Parent:Dynamic;
	var Hp:Float;
	var Acc:Float;
	var Ddg:FLoat;
	var Block:Float;
	var Cc:Float;
	var Def:Float;
	var Dmg:Float;
	var Spd:Float;
	var Stress:Float;
	var CritDmg:Float;
}

class Stats
{
	private var _hp:Float;// Health Points;
	private var _acc:Float;// Accuricy % // choose number of damage, if acc 100% always use max damage;
	private var _ddg:Float;// Dodge %
	private var _block:Float;// block with shield;
	private var _cc:Float;// Critical Chanse
	private var _def:Float;// defense
	private var _dmg:Float;// Damage
	private var _spd:Float; // Speed
	private var _stress:Float;// stress :D
	private var _critDmg:Float;// multiply damage ( x2, x2.1 e.t.c ); //default 100 = 2x


	public function new( config:StatConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function get( stat:String ):Float
	{
		switch( stat )
		{
			case "hp":
			case "acc":
			case "ddg":
			case "blk":
			case "cc":
			case "def":
			case "dmg":
			case "spd":
			case "stress":
			case "critDmg":
			default:  throw 'Error in Stats.get. No stat $stat was found';
		}
	}

	public function getPosition():Dynamic
	{
		return { "first": this._position.first, "second": this._position.second, "third": this._position.third, "fourth": this._position.fourth };
	}

	public function getTarget():Dynamic
	{
		return { "first": this._target.first, "second": this._target.second, "third": this._target.third, "fourth": this._target.fourth };
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
			// some traits can be use in some dungeons, need to check dungeon;
			var positiveTraits:Array<Dynamic> = taritsComponent.getPositiveTraits();
			var negativeTraits:Array<Dynamic> = taritsComponent.getNegativeTraits();
		}

	}
}
