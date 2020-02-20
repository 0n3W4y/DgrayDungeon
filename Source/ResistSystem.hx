package;

typedef ResistConfig =
{
  var Parent:Dynamic;
  var Stun:Int;
  var Poison:Int;
  var Bleed:Int;
  var Disease:Int;
  var Debuff:Int;
  var Move:Int;
  var Fire:Int;
  var Cold:Int;
}

abstract ResistStun( Int ) from Int
{

}

abstract ResistPoison( Int ) from Int
{

}

abstract ResistBleed( Int ) from Int
{

}

abstract ResistDisease( Int ) from Int
{

}

abstract ResistDebuff( Int ) from Int
{

}

abstract ResistMove( Int ) from Int
{

}


abstract ResistFire( Int ) from Int
{

}


abstract ResistCold( Int ) from Int
{

}

class ResistSystem
{
  private var _parent:Dynamic;

  private var _resistStun:Int;
	private var _resistPoison:Int;
	private var _resistBleed:Int;
	private var _resistDisease:Int;
	private var _resistDebuff:Int;
	private var _resistMove:Int;
	private var _resistFire:Int;
	private var _resistCold:Int;

  public inline function new( config:ResistConfig ):Void
  {
    this._parent = config.Parent;
    this._resistStun = config.Stun;
    this._resistPoison = config.Poison;
    this._resistBleed = config.Bleed;
    this._resistDisease = config.Disease;
    this._resistDebuff = config.Debuff;
    this._resistMove = config.Move;
    this._resistFire = config.Fire;
    this._resistCold = config.Cold;
  }

  public function init( error:String ):Void
  {
    var err:String = '$error. Error in ResistSystem.init';
    if( this._resistStun == null )
      throw '$err. Resist Stun is null';

    if( this._resistPoison == null )
      throw '$$err. Resist Posion is null';

    if( this._resistBleed == null )
      throw '$err. Resist Bleed is null';

    if( this._resistDisease == null )
      throw '$err. Resist Disease is null';

    if( this._resistDebuff == null )
      throw '$err. Resist Debuff is null';

    if( this._resistMove == null )
      throw '$err. Resist Move is null';

    if( this._resistFire == null )
      throw '$err. Resist Fire is null';

    if( this._resistCold == null )
      throw '$err. Resist Cold is null';
  }

  public function postInit( error:String ):Void
  {
    var err:String = '$error. Error in ResistSystem.postInit';
    if( this._resistStun < 0 )
      throw '$err. Resist stun is $_resistStun';
  }

  public function getBaseResist( resist:String ):Dynamic
  {
    switch( resist )
    {
      case "stun": return this._resistStun;
			case "poison": return this._resistPoison;
			case "bleed": return this._resistBleed;
			case "disease": return this._resistDisease;
			case "debuff": return this._resistDebuff;
			case "move": return this._resistMove;
			case "fire": return this._resistFire;
      case "cold": return this._resistCold;
      default: throw 'Error in ResistSystem.getBaseResist. Can not get $resist';
    }
  }

  public function getFullResist( resist:String ):Dynamic
  {
      switch( resist )
      {
        case "stun": return this._calculateStun();
        case "poison": return this._calculatePosion();
  			case "bleed": return this._calculateBleed();
  			case "disease": return this._calculateDisease();
  			case "debuff": return this._calculateDebuff();
  			case "move": return this._calculateMove();
  			case "fire": return this._calculateFire();
        case "cold": return this._calculateCold();
        default: throw 'Error in ResistSystem.getFullResist. Can not get $resist';
      }
  }


  //PRIVATE

  private function _calculateStun():ResistStun
  {
    return null;
  }

  private function _calculatePosion():ResistPoison
  {
    return null;
  }

  private function _calculateBleed():ResistBleed
  {
    return null;
  }

  private function _calculateDisease():ResistDisease
  {
    return null;
  }

  private function _calculateDebuff():ResistDebuff
  {
    return null;
  }

  private function _calculateMove():ResistMove
  {
    return null;
  }

  private function _calculateFire():ResistFire
  {
    return null;
  }

  private function _calculateCold():ResistCold
  {
    return null;
  }
}
