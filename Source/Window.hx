package;

class Window
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _status:String; // opened, closed

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;



	public function new():Void
	{

	}

	public function preInit():Array<Dynamic>
	{
		this._graphics = new GraphicsSystem();
		if( this._graphics == null )
			return [ null, "Error in Window.preInit. GraphicsSystem in NULL" ];

		this._preInited = true;
		return [ true, null ];
	}

	public function init():Void
	{

	}

	public function postInit():Void
	{

	}

	public function update( time:Float ):Void
	{
		for( i in 0...this._buttonChildren.length )
		{
			this._buttonChildren[ i ].update( time );
		}
	}

	public function appendChild( button:Button ):Array<Dynamic>
	{
		var buttonName:String = button.getName();
		var buttonId:String = button.getId();
		for( i in 0...this._buttonChildren.length )
		{
			var oldButton:Button = this._buttonChildren[ i ];
			var oldButtonName:String = oldButton.getName();
			var oldButtonId:Int = oldButton.getId();
			if( oldButtonName == buttonName && oldButtonId == buttonId )
				return [ null, "Error in Window.appendChild. Button with name: '" + buttonName + "' already exist" ];
		}
		this._buttonChildren.push( button );
		return [ true, null ];
	}

}