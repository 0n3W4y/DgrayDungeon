package;

typedef StatConfig =
{
	var Parent:Dynamic;
	var Hp:Int;
	var Acc:Int;
	var Ddg:Int;
	var Block:Int;
	var Cc:Int;
	var Def:Int;
	var Dmg:Int;
	var Spd:Int;
	var Stress:Int;
	var CritDmg:Int;
}

abstract HealthPoints( Int ) from Int
{
	@:op( a + b )	static function _( a:HealthPoints, b:HealthPoints ):HealthPoints;
	@:op( a - b )	static function _( a:HealthPoints, b:HealthPoints ):HealthPoints;
	@:op( a * b )	static function _( a:HealthPoints, b:HealthPoints ):HealthPoints;
	@:op( a < b )	static function _( a:HealthPoints, b:HealthPoints ):Bool;
	@:op( a > b )	static function _( a:HealthPoints, b:HealthPoints ):Bool;
	@:op( a == b )	static function _( a:HealthPoints, b:HealthPoints ):Bool;
}

abstract Accuracy( Int ) from Int
{
	@:op( a + b )	static function _( a:Accuracy, b:Accuracy ):Accuracy;
	@:op( a - b )	static function _( a:Accuracy, b:Accuracy ):Accuracy;
	@:op( a * b )	static function _( a:Accuracy, b:Accuracy ):Accuracy;
	@:op( a < b )	static function _( a:Accuracy, b:Accuracy ):Bool;
	@:op( a > b )	static function _( a:Accuracy, b:Accuracy ):Bool;
	@:op( a == b )	static function _( a:Accuracy, b:Accuracy ):Bool;
}

abstract Dodge( Int ) from Int
{
	@:op( a + b )	static function _( a:Dodge, b:Dodge ):Dodge;
	@:op( a - b )	static function _( a:Dodge, b:Dodge ):Dodge;
	@:op( a * b )	static function _( a:Dodge, b:Dodge ):Dodge;
	@:op( a < b )	static function _( a:Dodge, b:Dodge ):Bool;
	@:op( a > b )	static function _( a:Dodge, b:Dodge ):Bool;
	@:op( a == b )	static function _( a:Dodge, b:Dodge ):Bool;
}

abstract Block( Int ) from Int
{
	@:op( a + b )	static function _( a:Block, b:Block ):Block;
	@:op( a - b )	static function _( a:Block, b:Block ):Block;
	@:op( a * b )	static function _( a:Block, b:Block ):Block;
	@:op( a < b )	static function _( a:Block, b:Block ):Bool;
	@:op( a > b )	static function _( a:Block, b:Block ):Bool;
	@:op( a == b )	static function _( a:Block, b:Block ):Bool;
}

abstract CriticalChanse( Int ) from Int
{
	@:op( a + b )	static function _( a:CriticalChanse, b:CriticalChanse ):CriticalChanse;
	@:op( a - b )	static function _( a:CriticalChanse, b:CriticalChanse ):CriticalChanse;
	@:op( a * b )	static function _( a:CriticalChanse, b:CriticalChanse ):CriticalChanse;
	@:op( a < b )	static function _( a:CriticalChanse, b:CriticalChanse ):Bool;
	@:op( a > b )	static function _( a:CriticalChanse, b:CriticalChanse ):Bool;
	@:op( a == b )	static function _( a:CriticalChanse, b:CriticalChanse ):Bool;
}

abstract Defense( Int ) from Int
{
	@:op( a + b )	static function _( a:Defense, b:Defense ):Defense;
	@:op( a - b )	static function _( a:Defense, b:Defense ):Defense;
	@:op( a * b )	static function _( a:Defense, b:Defense ):Defense;
	@:op( a < b )	static function _( a:Defense, b:Defense ):Bool;
	@:op( a > b )	static function _( a:Defense, b:Defense ):Bool;
	@:op( a == b )	static function _( a:Defense, b:Defense ):Bool;
}

abstract Damage( Int ) from Int
{
	@:op( a + b )	static function _( a:Damage, b:Damage ):Damage;
	@:op( a - b )	static function _( a:Damage, b:Damage ):Damage;
	@:op( a * b )	static function _( a:Damage, b:Damage ):Damage;
	@:op( a < b )	static function _( a:Damage, b:Damage ):Bool;
	@:op( a > b )	static function _( a:Damage, b:Damage ):Bool;
	@:op( a == b )	static function _( a:Damage, b:Damage ):Bool;
}

abstract Speed( Int ) from Int
{
	@:op( a + b )	static function _( a:Speed, b:Speed ):Speed;
	@:op( a - b )	static function _( a:Speed, b:Speed ):Speed;
	@:op( a * b )	static function _( a:Speed, b:Speed ):Speed;
	@:op( a < b )	static function _( a:Speed, b:Speed ):Bool;
	@:op( a > b )	static function _( a:Speed, b:Speed ):Bool;
	@:op( a == b )	static function _( a:Speed, b:Speed ):Bool;
}

abstract Stress( Int ) from Int
{
	@:op( a + b )	static function _( a:Stress, b:Stress ):Stress;
	@:op( a - b )	static function _( a:Stress, b:Stress ):Stress;
	@:op( a * b )	static function _( a:Stress, b:Stress ):Stress;
	@:op( a < b )	static function _( a:Stress, b:Stress ):Bool;
	@:op( a > b )	static function _( a:Stress, b:Stress ):Bool;
	@:op( a == b )	static function _( a:Stress, b:Stress ):Bool;
}

abstract CriticalDamage( Int ) from Int
{
	@:op( a + b )	static function _( a:CriticalDamage, b:CriticalDamage ):CriticalDamage;
	@:op( a - b )	static function _( a:CriticalDamage, b:CriticalDamage ):CriticalDamage;
	@:op( a * b )	static function _( a:CriticalDamage, b:CriticalDamage ):CriticalDamage;
	@:op( a < b )	static function _( a:CriticalDamage, b:CriticalDamage ):Bool;
	@:op( a > b )	static function _( a:CriticalDamage, b:CriticalDamage ):Bool;
	@:op( a == b )	static function _( a:CriticalDamage, b:CriticalDamage ):Bool;
}

class StatSystem
{
	private var _parent:Dynamic;

	private var _hp:HealthPoints;// Health Points;
	private var _acc:Accuracy;// Accuricy % // choose number of damage, if acc 100% always use max damage;
	private var _ddg:Dodge;// Dodge %
	private var _block:Block;// block with shield;
	private var _cc:CriticalChanse;// Critical Chanse
	private var _def:Defense;// defense
	private var _dmg:Damage;// Damage
	private var _spd:Speed; // Speed
	private var _stress:Stress;// stress :D
	private var _critDmg:CriticalDamage;// multiply damage ( x2, x2.1 e.t.c ); //default 100 = 2x


	public function new( config:StatConfig ):Void
	{
		this._parent = config.Parent;
		this._hp = config.Hp;
		this._acc = config.Acc;
		this._ddg = config.Ddg;
		this._block = config.Block;
		this._cc = config.Cc;
		this._def = config.Def;
		this._dmg = config.Dmg;
		this._spd = config.Spd;
		this._stress = config.Stress;
		this._critDmg = config.CritDmg;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in StatSystem.init';
		if( this._hp == null )
			throw '$err. Health points is null';

		if( this._acc == null )
			throw '$err. Accuracy is null';

		if( this._ddg == null )
			throw '$err. Dodge is null';

		if( this._block == null )
			throw '$err. Block is null';

		if( this._cc == null )
			throw '$err. Critical chanse is null';

		if( this._def == null )
			throw '$err. Defense is null';

		if( this._dmg == null )
			throw '$err. Damage is null';

		if( this._spd == null )
			throw '$err. Speed is null';

		if( this._stress == null )
			throw '$err. Stress is null';

		if( this._critDmg == null )
			throw '$err. Crititcal damage is null';
	}

	public function postInit( error:String ):Void
	{
		var err:String = '$error. Error in StatSystem.postInit';
		if( this._hp < 0 )
			throw '$err. Health points is $_hp';
	}

	public function getBaseStat( stat:String ):Dynamic
	{
		switch( stat )
		{
			case "hp": return this._hp;
			case "acc": return this._acc;
			case "ddg": return this._ddg;
			case "block": return this._block;
			case "cc": return this._cc;
			case "def": return this._def;
			case "dmg": return this._dmg;
			case "spd": return this._spd;
			case "stress": return this._stress;
			case "critDmg": return this._critDmg;
			default:  throw 'Error in Stats.get. Ca not get $stat';
		}
	}

	public function getFullStat( stat:String ):Dynamic
	{
			// функция, которая должна собрать всю информацию о текущих значения героя включая инвентарь, пассивные скилы + активные скилы + эффекты.
		switch ( stat )
		{
			case "hp": return this._calculateHp();
			case "acc": return this._calculateAcc();
			case "ddg": return this._calculateDdg();
			case "block": return this._calculateBlock();
			case "cc": return this._calculateCc();
			case "def": return this._calculateDef();
			case "dmg": return this._calculateDmg();
			case "spd": return this._calculateSpd();
			case "stress": return this._calculateStress();
			case "critDmg": return this._calculateCritDmg();
			default: throw 'Error in StatSystem.getFullStat. Can not get $stat';
		}
	}

	//PRIVATE

	private function _calculateHp():HealthPoints
	{
		return null;
	}

	private function _calculateAcc():Accuracy
	{
		return null;
	}

	private function _calculateDdg():Dodge
	{
		return null;
	}

	private function _calculateBlock():Block
	{
		return null;
	}

	private function _calculateCc():CriticalChanse
	{
		return null;
	}

	private function _calculateDef():Defense
	{
		return null;
	}

	private function _calculateDmg():Damage
	{
		return null;
	}

	private function _calculateSpd():Speed
	{
		return null;
	}

	private function _calculateStress():Stress
	{
		return null;
	}

	private function _calculateCritDmg():CriticalDamage
	{
		return null;
	}
}
