package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;


class GraphicsSystem
{
	private var _parent:Game;


	private function _sortWithQueueText( a, b ):Int
	{
		if( a.queue > b.queue )
			return 1;
		else if( a.queue < b.queue )
			return -1;
		else
			return 0;
	}

	private function _sortWithQueueWindow( a:Entity, b:Entity ):Int
	{
		var aQueue = a.getComponent( "graphics" ).getQueue();
		var bQueue = b.getComponent( "graphics" ).getQueue();
		if( aQueue > bQueue )
			return 1;
		else if( aQueue < bQueue )
			return -1;
		else
			return 0;
	}

	private function _checkButton( name:String ):Bool
	{	
		// there is the function, we need to check button click and other's function to enable it or disable;
		switch( name )
		{
			case "gameContinue": return true;
			default: return false;
		}
	}
	private function _createText( text:Dynamic ):TextField
	{
        var txt = new TextField();

        var textFormat:TextFormat = new TextFormat();
        textFormat.font = text.font;
        textFormat.size = text.size;
        textFormat.color = text.color;
        textFormat.align = TextFormatAlign.CENTER;

        txt.defaultTextFormat = textFormat;
        txt.visible = text.visible;
        txt.selectable = text.selectable;
        txt.text = text.text;
        txt.width = text.width;
        txt.height = text.height;

        txt.x = text.x;
        txt.y = text.y;
        return txt;
	}


	private function _createGraphicsForObject( object ):Sprite
	{
		var objectGraphics = object.getComponent( "graphics" );
		var objectType:String = object.get( "type" );
		var graphicsSprite:Sprite = new Sprite();
		var imageContainer:Dynamic = objectGraphics.getImg();

		for( key in Reflect.fields( imageContainer ) )
		{
			var value = Reflect.getProperty( imageContainer, key );
			var data:Bitmap = new Bitmap( Assets.getBitmapData( value.url ) );
			data.x = value.x;
			data.y = value.y;
			
			if( key == "0" && objectType == "button" )
				data.visible = true;
			else if( key > "2" && objectType == "button" )
				data.visible = true;
			else if( objectType == "button" )
				data.visible = false;

			graphicsSprite.addChild( data );
		}
		return graphicsSprite;
	}

	private function _createTextForObject( object ):Sprite
	{
		var objectGraphics = object.getComponent( "graphics" );
		var textSprite = new Sprite();
		var text:Dynamic = objectGraphics.getText();
		if( text != null )
		{
			var textArray:Array<Dynamic> = new Array();
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				textArray.push( { "name": key, "value": value } );
			}
			textArray.sort( this._sortWithQueueText );

			for( i in 0...textArray.length )
			{
				var newText = textArray[ i ];
				var textField = this._createText( newText.value );
				textSprite.addChild( textField );
			}
		}
		return textSprite;
	}

	private function _createWindowButton( object:Entity ):Sprite
	{
		// Sprite - > child[0] = Sprite with graphics;
		// Sprite - > child[1] = Sprite TextFields - > with queue;
		// all keys are 1, 2, 3, 4, 5, they r have static order, so i ca use it;
		// 0 - normal, 1 - hover , 2 - pushed, ( 3 - portrait, 4 - level - for special button );
		var objectType:String = object.get( "type" );
		var objectName:String = object.get( "name" );
		var isHide:Bool = false;
		if( objectName == "recruitWindowHeroButton" )
			isHide = false;

		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsForObject( object );
		var textSprite:Sprite = this._createTextForObject( object );
		var buttonGraphics = object.getComponent( "graphics" );

		sprite.addChild( graphicsSprite );
		sprite.addChild( textSprite );

		var coords = buttonGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		buttonGraphics.setGraphicsInstance( sprite );
		if( objectType == "button" )
		{
			this._parent.getSystem( "event" ).addEvent( object, null );
			if( object.get( "name" ) == "gameContinue" )
			{
				var chekButton = this._checkButton( "gameContinue" );
				if( chekButton )
				{
					//remove all events from button.
					this._parent.getSystem( "event" ).removeEvent(  object, null );
					sprite.alpha = 0.5;
				}
			}
		}
		
		if( isHide )
			sprite.visible = false;
		return sprite;
	}

	private function _createButtonRecruitWindow( button:Entity, hero:Entity, num:Int ):Void
	{
		var uiSystem:UserInterface = this._parent.getSystem( "ui" );
		var recruitWindow:Entity = uiSystem.getWindow( "recruitWindow" );
		var recruitWindowGraphicsInstance:Sprite = recruitWindow.getComponent( "graphics" ).getGraphicsInstance();

		var heroType:String = hero.get( "name" );
		var heroName:String = hero.getComponent( "name" ).get( "fullName" );
		var heroLevel:Int = hero.getComponent( "experience" ).get( "lvl" );

		var buttonGraphicsComponent:Graphics = button.getComponent( "graphics" );
		var buttonImg:Dynamic = buttonGraphicsComponent.getImg();
		var buttonTxt:Dynamic = buttonGraphicsComponent.getText();
		// { 'text1': { "text": "yuppei",x: 1, y:2 }, 'text2': { "text": "yuppieey", x: 1, y:2 } };
		// { "0": { "x": 0, "y": 0, "url": "//..." }, "1": { x, y , url }};
		buttonTxt.name.text = heroName;
		buttonTxt.type.text = heroType;
		var newButton:Sprite = this._createWindowButton( button );
		newButton.y += newButton.height * num;

		recruitWindowGraphicsInstance.addChild( newButton );
		
		// sprite child[0] - graphics, child[0][0-2] - standart, child[0][3] - portrait hero, child[0][4] - hero level;
		// sprite child[1] - text, child[1][0] - text hero name, child[1][0] - text hero class;
	}

	private function _fillSpriteForHeroButtonRecruitWindow( hero:Entity, sprite:Sprite ):Void
	{
		//sprite - one of button;
	}

	private function _createBuilding( object:Entity ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var buildingSprite:Sprite = new Sprite();
		var textSprite:Sprite = new Sprite();
		var objectGraphics:Dynamic = object.getComponent( "graphics" );

		var normalData = new Bitmap( Assets.getBitmapData( objectGraphics.getImg().normal.url ) );
		var hoverData = new Bitmap( Assets.getBitmapData( objectGraphics.getImg().hover.url ) );

		normalData.visible = true;
		hoverData.visible = false;

		normalData.x = objectGraphics.getImg().normal.x;
		normalData.y = objectGraphics.getImg().normal.y;

		hoverData.x = objectGraphics.getImg().hover.x;
		hoverData.y = objectGraphics.getImg().hover.y;

		buildingSprite.addChild( normalData );
		buildingSprite.addChild( hoverData );

		sprite.addChild( buildingSprite );

		var coords = objectGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text = objectGraphics.getText();
		if( text != null )
		{
			var textArray:Array<Dynamic> = new Array();
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				textArray.push( { "name": key, "value": value } );
			}

			textArray.sort( this._sortWithQueueText );
			for( i in 0...textArray.length )
			{
				var textField = this._createText( textArray[ i ].value );
				textSprite.addChild( textField );
			}

			textSprite.alpha = 0;
			if( object.get( "name" ) == "inn" )
				textSprite.alpha = 1;

			sprite.addChild( textSprite );
		}
		objectGraphics.setGraphicsInstance( sprite );
		if( object.get( "name" ) == "inn" )
			return sprite;
		this._parent.getSystem( "event" ).addEvent( object, "mCLICK" );
		this._parent.getSystem( "event" ).addEvent( object, "mOUT" );
		this._parent.getSystem( "event" ).addEvent( object, "mOVER" );
		return sprite;
	}

	private function _drawStartScene( scene:Scene ):Void
	{
		//add bacground on scene;
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.getSprite().addChild( bitmap );

		//add UI objects to ui;
		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObjects( sceneUiEntities );
		this._parent.getMainSprite().addChild( scene.getSprite() );
	}

	private function _undrawUIfromScene( scene:Scene ):Void
	{
		var windowsList:Array<Entity> = scene.getEntities( "ui" ).window;
		for( i in 0...windowsList.length )
		{
			this._parent.getSystem( "ui" ).removeUiObject( windowsList[ i ].get( "name" ) );
		}
	}

	private function _drawCityScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImageURL();
		var sceneSprite:Sprite = scene.getSprite();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		sceneSprite.addChild( bitmap );

		var sceneObjectEntities:Dynamic = scene.getEntities( "object" );
		var buildingsList:Array<Entity> = sceneObjectEntities.building;


		for( i in 0...buildingsList.length )
		{
			var object:Entity = buildingsList[ i ];
			switch( object.get( "name" ) )
			{
				case "storage":
				{
					continue;
				}
				case "inn":
				{
					//TODO: Create 2 buttons to list heroes in inn inventory;
				}
			}
			var sprite = this.createObject( object );
			sceneSprite.addChild( sprite );
		}

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		var uiSystem:UserInterface = this._parent.getSystem( "ui" );
		this.createUiObjects( sceneUiEntities );

		uiSystem.hideUiObject( "citySceneMainWindow" );
		uiSystem.hideUiObject( "recruitWindow" );
		var recruitWindow:Entity = uiSystem.getWindow( "recruitWindow" );
		var recruitInentoryComponent:Inventory = null;
		var listOfBuildings:Array<Entity> = scene.getEntities( "object" ).building;
		for( j in 0...listOfBuildings.length )
		{
			var building:Dynamic = listOfBuildings[ j ];
			if( building.get( "name" ) == "recruits" )
			{
				recruitInentoryComponent = building.getComponent( "inventory" );
				break;
			}
		}

		//do recruitWindowHeroButton;
		var listOfHeroButtons:Array<Entity> = new Array();
		var arrayOfSceneButtons:Array<Entity> = scene.getEntities( "ui" ).button;
		for( l in 0...arrayOfSceneButtons.length )
		{
			//choose buttons with name "recruitButton"
			var recruitButton:Entity = arrayOfSceneButtons[ l ];
			if( recruitButton.get( "name" ) == "recruitWindowHeroButton" )
				listOfHeroButtons.push( recruitButton ); // put all buttons in array;
		}
		
		var recruitInventory:Dynamic = recruitInentoryComponent.getInventory();
		if( recruitInventory != null ) //check for bug;
		{
			for( k in 0...recruitInventory.length )
			{
				var heroButton:Entity = listOfHeroButtons[ k ];
				if( heroButton != null ) //check button;
				{
					var slot:String = "slot" + k;
					var hero:Entity = recruitInentoryComponent.getItemInSlot( slot );
					if( hero != null )
					{
						this._createButtonRecruitWindow( heroButton, hero, k );
					}
					else
					{
						trace( "Warning, GraphicsSystem._drawCityScene, heroes are end for recruit window. " + k + "; " + hero );
						break; // no heroes;						
					}					
				}
				else
				{
					trace( "Warning, GraphicsSystem._drawCityScene, buttons are end for recruit window. " + k + "; " + heroButton );
					break; // no buttons;
				}				
			}
		}
		else
			trace( "Error in GraphicsSystem._drawCityScene. Something went wrong, Inventory in recruits building = " + recruitInventory );

		this._parent.getMainSprite().addChild( scene.getSprite() );
	}

	private function _drawchooseDungeonScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.getSprite().addChild( bitmap );

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObjects( sceneUiEntities );
		this._parent.getMainSprite().addChild( scene.getSprite() );
	}


	//public

	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function drawScene( scene:Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._drawStartScene( scene );
			case "cityScene": this._drawCityScene( scene );
			case "chooseDungeonScene": this._drawchooseDungeonScene( scene );
			default: trace( "Can't draw scene with name: " + sceneName + "." );
		}
	}

	public function undrawScene( scene: Scene ):Void
	{
		this._undrawUIfromScene( scene );
		this._parent.getMainSprite().removeChild( scene.getSprite() );
	}

	public function createUiObjects( list:Dynamic ):Void
	{
		//TODO: rebuild function;
		var windows:Array<Entity> = list.window;
		var buttons:Array<Entity> = list.button;
		windows.sort( this._sortWithQueueWindow );
		
		for( i in 0...windows.length )
		{
			var window = windows[ i ];
			var windowName = window.get( "name" );
			var spriteWindow:Sprite = this._createWindowButton( window );
			for( j in 0...buttons.length )
			{
				var button = buttons[ j ];
				var buttonParent = button.getComponent( "ui" ).getParentWindow();
				if( buttonParent == windowName )
				{
					var spriteButton:Sprite = this._createWindowButton( button );
					spriteWindow.addChild( spriteButton );
				}
			}
			this._parent.getSystem( "ui" ).addUiObject( { "name": windowName, "window": window } );
		}		
	}

	public function drawObject( object:Entity ):Void
	{
		// just draw this object;
		var type:String = object.get( "type" );
		switch( type )
		{
			case "window":
			case "building":
			default: trace( "Error in GraphicsSystem.drawObject, object type: " + type + ", can't be found." );
		}
	}

	public function undrawObject( object:Entity ):Void
	{ //undraw object - remove from ui and scene;
		var type:String = object.get( "type" );
		switch( type )
		{
			case "window":
			case "building":
			default: trace( "Error in GraphicsSystem.undrawObject, object type: " + type + ", can't be found." );
		}
	}

	public function createObject( object:Entity ):Sprite
	{	//just create object graphicsd and put it on ui or to scene;
		var type = object.get( "type" );
		switch( type )
		{
			case "building": return this._createBuilding( object );
			case "window", "button": return this._createWindowButton( object );
			default: trace( "Error GraphicsSystem.createObject, object type: " + type + ", can't be found." );
		}
		return null;
	}

	public function hideScene( scene:Scene ):Void
	{
		scene.getSprite().visible = false;
		var list:Dynamic = scene.getEntities( "ui" );
		var windows:Array<Entity> = list.windows;
		for( i in 0...windows.length )
		{
			var name = windows[ i ].get( "name" );
			this._parent.getSystem( "ui" ).hideUiObject( name );
		}
	}

	public function showScene( scene:Scene ):Void
	{
		scene.getSprite().visible = true;
	}
}