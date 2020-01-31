package;

import openfl.display.Sprite;

import Window;
import Button;

class UserInterface
{
	private var _parent:Game;
	private var _objectsOnUi:Array<Window>;
	private var _objects:Array<Window>;
	private var _sprite:Sprite;

	public inline function new( config:UIConfig ):Void
	{
		this._parent = config.Parent;
		this._sprite = config.GraphicsSprite;
		this._buttonDeploy = config.Button;
		this._windowDeploy = config.Widnow;
	}

	public function init():String
	{
		if( this._parent == null )
			return 'Error in UserInterface.init. Game is "$this._parent"';

		if( this._uiSprite == null )
			return 'Error in UserInterface.init. Sprite is "$this._uiSprite"';

		if( !this._buttonDeploy.exist( 4000 ) )
			return 'Error in UserInterface.init. Button deploy config is not valid!';

		if( !this._windowDeploy.exist( 3000 ) )
			return 'Error in UserInterface.init. Window deploy config is not valid!';

		this._objectsOnUi = new Array<Window>();
		this._objects = new Array<Window>();
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function addWindowOnUi( deployId:WindowdeployID ):Void
	{
		var exist:Int = this._checkWindowInObjectsOnUi( deployId );
		if( exist != null )
			throw 'Error in UserInterface.addWindowOnUi. Window with deploy id: "$deployId" already on UI!';

		var check:Int = this._checkWidnowInObjects( deployId );
		if( check == null )
			throw 'Error in UserInterface.addWindowOnUi. Window with deploy id: "$deployId" not exist!';

		var window:Window = this._objects[ check ];
		var sprite:Sprite = window.get( "sprite" );
		var eventHandler:EventHandler = this._parent.getSystem( "event" );
		var alwaysActive:Bool = window.get( "alwaysActive" );
		if( !alwaysActive )
			sprite.visible = false;

		var buttonContinueDeployId:ButtonDeployID = 4011;
		var windowChilds:Array<Button> = object.get( "childs" );
		for( j in 0...windowChilds.length )
		{
			var button:Button = windowChilds[ j ];
			var buttonDeployId:ButtonDeployID = button.get( "deployId" );
			if( buttonDeployId == buttonContinueDeployId ) // проверяем на наличие последнего сохранение игрока. Если его нет. Кнопка "Continue" не активна.
			{ //TODO: сделать отдельную функцию проверки кнопок и запихивание на них ивентов.
				var saveGame:Dynamic = this._parent.getLastSave();
				if( saveGame == null )
					continue;
			}
			eventHandler.addEvents( button );
		}

		this._objectsOnUi.push( window );
		this._sprite.addChild( sprite );
	}

	public function removeWindowFromUi( deployId:WindowDeployID ):Void
	{
		var exist:Int = this._checkWindowInObjectsOnUi( deployId );
		if( exist == null )
			throw 'Error in UserInterface.removeWindowOnUi. Window with deploy id: "$deployId" not exist on UI!';

		var check:Int = this._checkWidnowInObjects( deployId );
		if( check == null )
			throw 'Error in UserInterface.removeWindowOnUi. Window with deploy id: "$deployId" not exist!';

		var window:Window = this._objects[ check ];
		var sprite:Sprite = window.get( "sprite" );
		var eventHandler:EventHandler = this._parent.getSystem( "event" );
		var windowChilds:Array<Button> = window.get( "childs" );
		for( j in 0...windowChilds.length )
		{
			var button:Button = windowChilds[ j ];
			eventHandler.removeEvents( button );
		}
		this._objectsOnUi.splice( exist, 1 ); // убираем окно по индексу check, одно.
		this._sprite.removeChild( sprite );
	}

	public function destroyWindow( deployid:WindowDeployID ):Window
	{
		var exist:Int = this._checkWindowInObjectsOnUi( deployId );
		if( exist != null )
			throw 'Error in UserInterface.destroyWindow. Window with deploy id: "$deployId" Can not kill window, while it on UI';

		var check:Int = this._checkWidnowInObjects( deployId );
		if( check == null )
			throw 'Error in UserInterface.destroyWindow. Window with deploy id: "$deployId" not exist!';

		var window:Window = this._objects[ check ];
		this._objects.splice( check, 1 );
		return window;
	}

	public function showUiObject( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var check:Int = this._checkObjectForExist( object );
		if( check == null )
			throw 'Error in UserInterface.showUiObject. Object with name: "$name" does not exist.';	

		this._objectsOnUi[ check ].get( "sprite" ).visible = true;
		object.changeActiveStatus();
	}

	public function hideUiObject( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var check:Int = this._checkObjectForExist( object );
		if( check == null )
			throw 'Error in UserInterface.hideUiObject. Object with name: "$name" does not exist.';	

		this._objectsOnUi[ check ].get( "sprite" ).visible = false;
		object.changeActiveStatus();
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "sprite": return this._sprite;
			case "objectsOnUi": return this._objectsOnUi;
			case "objects": return this._objects;
		}
	}

	public function hide():Void
	{
		this._uiSprite.visible = false;
	}

	public function show():Void
	{
		this._uiSprite.visible = true;
	}

	public function createWindow( deployId:Int ):Array<Dynamic>
	{
		var config:Deploy.WindowDeploy = this._parent.get( "deploy" ).get( "window", deployId );
		
		var id:Game.ID = this._parent.createId();
		var sprite:Sprite = new Sprite();
		sprite.x = config.x;
		sprite.y = config.y;

		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForWindow:WindowConfig =
		{
			ID: id,
			Name: config.name,
			DeployID: WindowDeployID( config.deployId ),
			GraphicsSprite: sprite,
			AlwaysActive: config.alwaysActive
		};
		var window:Window = new Window( configForWindow );
		var err:String = window.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.createWindow. $err' ];

		if( config.button != null )
		{
			for( i in 0...config.button.length )
			{
				var buttonDeployId:Int = config.button[ i ];
				var createButton:Array<Dynamic> = this.createButton( buttonDeployId );
				var button:Button = createButton[ 0 ];
				var bErr:String = createButton[ 1 ];
				if( bErr != null )
					return [ null, 'Error in GeneratorSystem.createWindow. $bErr' ];
				window.addChild( button );
				var buttonSprite:Sprite = button.get( "sprite" );
				sprite.addChild( buttonSprite );
			}
		}

		this._objects.push( window );

		return [ window, null ];
	}

	public function createButton( deployId:Int ):Array<Dynamic>
	{
		var config:Deploy.ButtonDeploy = this._parent.get( "deploy" ).get( "button", deployId );
		
		var id:ID = this._parent.createId();
		var sprite:Sprite = new Sprite();
		sprite.x = config.x;
		sprite.y = config.y;

		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForButton:ButtonConfig =
		{ 
			ID: id, 
			DeployID: ButtonDeployID( config.deployId ),
			Name: config.name, 
			GraphicsSprite: sprite 
		};
		var button:Button = new Button( configForButton );
		var err:String = button.init();
		if( err != null )
			return [ null , 'Error in GeneratorSystem.createButton. $err' ];

		return [ button, null ];
	}

	//PRIVATE

	private function _checkWidnowInObjects( deployId:WindowDeployID ):Int
	{
		for( i in 0...this._objects.length )
		{
			if( this._objects[ i ].get( "id" ) == deployId )
				return i;
		}

		return null;
	}

	private function _checkWindowInObjectsOnUi( deployId:WindowDeployID ):Int
	{
		for( i in 0...this._objectsOnUi.length )
		{
			if( this._objectsOnUi[ i ].get( "id" ) == deployId )
				return i;
		}

		return null;
	}

		private function _createGraphicsSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var bitmap:Bitmap;

		if( config.imageNormalURL != null )
		{
			bitmap = this._createBitmap( config.imageNormalURL, config.imageNormalX, config.imageNormalY );
			sprite.addChild( bitmap );
		}

		if( config.imageHoverURL != null )
		{
			bitmap = this._createBitmap( config.imageHoverURL, config.imageHoverX, config.imageHoverY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		if( config.imagePushURL != null )
		{
			bitmap = this._createBitmap( config.imagePushURL, config.imagePushX, config.imagePushY );
			bitmap.visible = false;
			sprite.addChild( bitmap );
		}

		// TODO: Portrait for button hero, Level for button hero.

		return sprite;
	}
	private function _createBitmap( url:String, x:Float, y:Float ):Bitmap
	{
		var bitmap:Bitmap = new Bitmap( Assets.getBitmapData( url ) );
		bitmap.x = x;
		bitmap.y = y;
		return bitmap;
	}

	private function _createTextSprite( config:Dynamic ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var text:TextField;
		var textConfig:Dynamic = 
		{
			"text": null,
			"size": null,
			"color": null,
			"width": null,
			"height": null,
			"x": null,
			"y": null,
			"align": null
		};

		if( config.firstText != null )
		{
			textConfig.text = config.firstText;
			textConfig.size = config.firstTextSize;
			textConfig.color = config.firstTextColor;
			textConfig.width = config.firstTextWidth;
			textConfig.height = config.firstTextHeight;
			textConfig.x = config.firstTextX;
			textConfig.y = config.firstTextY;
			textConfig.align = config.firstTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		if( config.secondText != null )
		{
			textConfig.text = config.secondText;
			textConfig.size = config.secondTextSize;
			textConfig.color = config.secondTextColor;
			textConfig.width = config.secondTextWidth;
			textConfig.height = config.secondTextHeight;
			textConfig.x = config.secondTextX;
			textConfig.y = config.secondTextY;
			textConfig.align = config.secondTextAlign;
			text = this._createText( textConfig );
			sprite.addChild( text );
		}

		return sprite;
	}

	private function _createText( text:Dynamic ):TextField
	{
        var txt:TextField = new TextField();

        var align:Dynamic = null;
        switch( text.align )
        {
        	case "left": align = TextFormatAlign.LEFT;
        	case "right": align = TextFormatAlign.RIGHT;
        	case "center": align = TextFormatAlign.CENTER;
        	default: throw( "Error in GeneratorSystem._createText. Wrong align: " + text.align + "; text: " + text.text );
        }

        var textFormat:TextFormat = new TextFormat();
        textFormat.font = "Verdana";
        textFormat.size = text.size;
        textFormat.color = text.color;        
        textFormat.align = align;

        txt.defaultTextFormat = textFormat;
        txt.visible = true;
        txt.selectable = false;
        txt.text = text.text;
        txt.width = text.width;
        txt.height = text.height;
        txt.x = text.x;
        txt.y = text.y;

        if( text.text == null || text.width == null || text.height == null || text.x == null || text.y == null || text.size == null || text.color == null )
        	throw( "Some errors in GeneratorSystem._createText. In config some values is NULL. Text: " + text.text );

        return txt;
	}
}