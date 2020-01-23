package;

class Building
{
	private var _id:Int;
	private var _name:String;
	private var _deployId:Int;
	private var _type:String;

	private var _upgradeLevel:Int; // возможность купить апгрейд для здания. что бы увеличить количество слотов. или качество обслуживания.
	private var _upgradePrice:Int;

	public function new():Void
	{
		
	}

	public function init():String
	{
		return null;
	}

	public function postInit():String
	{
		return null;
	}
}