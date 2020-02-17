package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.Assets;

import Window;
import Button;
import haxe.EnumTools.EnumValueTools;

typedef UserInterfaceConfig =
{
	var Parent:Game;
	var GraphicsSprite:Sprite;
}

class UserInterface
{
	private var _parent:Game;
	private var _objectsOnUi:Array<Window>;
	private var _objects:Array<Window>;
	private var _sprite:Sprite;

	public inline function new( config:UserInterfaceConfig ):Void
	{
		this._parent = config.Parent;
		this._sprite = config.GraphicsSprite;
	}

	public function init( error:String ):Void
	{
		this._objectsOnUi = new Array<Window>();
		this._objects = new Array<Window>();
		this.hide(); // при первом старте скрываем ui, для правильного отображения сцены приветствия.

		if( this._parent == null )
			throw 'Error in UserInterface.init. Game is "$this._parent"';

		if( this._sprite == null )
			throw 'Error in UserInterface.init. Sprite is "$this._sprite"';

	}

	public function postInit():Void
	{

	}

	public function addWindowOnUi( deployId:WindowDeployID ):Void
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

		var buttonContinueDeployId:ButtonDeployID = ButtonDeployID( 4011 );
		var windowChilds:Array<Button> = window.get( "childs" );
		for( j in 0...windowChilds.length )
		{
			var button:Button = windowChilds[ j ];
			var buttonDeployId:ButtonDeployID = button.get( "deployId" );
			// проверяем на наличие последнего сохранение игрока. Если его нет. Кнопка "Continue" не активна.
			if( EnumValueTools.equals( buttonContinueDeployId, buttonDeployId ))
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

	public function destroyWindow( deployId:WindowDeployID ):Window
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

	public function showUiObject( deployId:WindowDeployID ):Void
	{
		var check:Int = this._checkWindowInObjectsOnUi( deployId );
		if( check == null )
			throw 'Error in UserInterface.showUiObject. Object with deploy id: "$deployId" does not exist.';

		if( this._objectsOnUi[ check ].get( "alwaysActive" ))
			throw 'Error in UserInterface.ShowUiObjec. Object can not be shown, while object is always active. "$deployId"';


		var sprite:Sprite = this._objectsOnUi[ check ].get( "sprite" );
		sprite.visible = true;
		this._objectsOnUi[ check ].changeActiveStatus();
	}

	public function hideUiObject( deployId:WindowDeployID ):Void
	{
		var check:Int = this._checkWindowInObjectsOnUi( deployId );
		if( check == null )
			throw 'Error in UserInterface.hideUiObject. Object with deploy id: "$deployId" does not exist.';

		if( this._objectsOnUi[ check ].get( "alwaysActive" ))
			throw 'Error in UserInterface.ShowUiObjec. Object can not be hide, while object is always active. "$deployId"';

		var sprite:Sprite = this._objectsOnUi[ check ].get( "sprite" );
		sprite.visible = false;
		this._objectsOnUi[ check ].changeActiveStatus();
		if( haxe.EnumTools.EnumValueTools.equals( WindowDeployID( 3001 ), deployId ))
			this._hideChildCitySceneMainWindow();
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "sprite": return this._sprite;
			case "objectsOnUi": return this._objectsOnUi;
			case "objects": return this._objects;
			default: throw 'Error in UserItreface.get. Not value for "$value"';
		}
	}

	public function hide():Void
	{
		this._sprite.visible = false;
	}

	public function show():Void
	{
		this._sprite.visible = true;
	}

	public function createWindow( deployId:Int ):Window
	{
		var windowDeployId:WindowDeployID = WindowDeployID( deployId );
		var config:Dynamic = this._parent.getSystem( "deploy" ).getWindow( windowDeployId );

		var id:WindowID = WindowID( this._parent.createId() );
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
			DeployID: windowDeployId,
			GraphicsSprite: sprite,
			AlwaysActive: config.alwaysActive
		};
		var window:Window = new Window( configForWindow );
		window.init( 'Error in GeneratorSystem.createWindow. Window.init' );

		if( config.button != null )
		{
			for( i in 0...config.button.length )
			{
				var button:Button = this.createButton( config.button[ i ] );
				window.addChild( button );
				var buttonSprite:Sprite = button.get( "sprite" );
				sprite.addChild( buttonSprite );
			}
		}

		this._objects.push( window );

		return window;
	}

	public function createButton( deployId:Int ):Button
	{
		var buttondeployId:ButtonDeployID = ButtonDeployID( deployId );
		var config:Dynamic = this._parent.getSystem( "deploy" ).getButton( buttondeployId );

		var id:ButtonID = ButtonID( this._parent.createId() );
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
			DeployID: buttondeployId,
			Name: config.name,
			GraphicsSprite: sprite
		};
		var button:Button = new Button( configForButton );
		button.init( 'Error in GeneratorSystem.createButton. Button.init' );

		return button;
	}



	//PRIVATE
	private function _hideChildCitySceneMainWindow():Void
	{
		for( i in 0...this._objectsOnUi.length )
		{
			var window:Window = this._objectsOnUi[ i ];
			var windowDeployID:WindowDeployID = window.get( "deployId" );
			if( window.get( "activeStatus" ) )
			{
				if( haxe.EnumTools.EnumValueTools.equals( WindowDeployID( 3001 ), windowDeployID ))
					continue;

				this.hideUiObject( windowDeployID );
				break; // находит первого активного, закрывает его и все.
			}
		}
	}

	private function _checkWidnowInObjects( deployId:WindowDeployID ):Int
	{
		for( i in 0...this._objects.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( this._objects[ i ].get( "deployId" ), deployId ))
				return i;
		}

		return null;
	}

	private function _checkWindowInObjectsOnUi( deployId:WindowDeployID ):Int
	{
		for( i in 0...this._objectsOnUi.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( this._objectsOnUi[ i ].get( "deployId" ), deployId ))
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
