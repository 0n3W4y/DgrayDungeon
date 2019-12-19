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
        var align:Dynamic = null;
        switch( text.align )
        {
        	case "left": align = TextFormatAlign.LEFT;
        	case "right": align = TextFormatAlign.RIGHT;
        	case "center": align = TextFormatAlign.CENTER;
        	default: trace( "Error in GraphicsSystem._createText. Wrong align: " + text.align );
        }
        textFormat.align = align;

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

		var oneData:Bitmap = new Bitmap( Assets.getBitmapData( imageContainer.one.url ) );
		oneData.x = imageContainer.one.x;
		oneData.y = imageContainer.one.y;
		graphicsSprite.addChild( oneData );

		if( imageContainer.two.url != null )
		{
			var twoData:Bitmap = new Bitmap( Assets.getBitmapData( imageContainer.two.url ) );
			twoData.x = imageContainer.two.x;
			twoData.y = imageContainer.two.y;
			if( objectType == "button" )
				twoData.visible = false;

			graphicsSprite.addChild( twoData );
		}

		if( imageContainer.three.url != null )
		{
			var threeData:Bitmap = new Bitmap( Assets.getBitmapData( imageContainer.three.url ) );
			threeData.x = imageContainer.three.x;
			threeData.y = imageContainer.three.y;
			if( objectType == "button" )
				threeData.visible = false;

			graphicsSprite.addChild( threeData );
		}

		if( imageContainer.four.url != null )
		{
			var fourData:Bitmap = new Bitmap( Assets.getBitmapData( imageContainer.four.url ) );
			fourData.x = imageContainer.four.x;
			fourData.y = imageContainer.four.y;
			graphicsSprite.addChild( fourData );
		}

		if( imageContainer.five.url != null )
		{
			var fiveData:Bitmap = new Bitmap( Assets.getBitmapData( imageContainer.five.url ) );
			fiveData.x = imageContainer.five.x;
			fiveData.y = imageContainer.five.y;
			graphicsSprite.addChild( fiveData );
		}
		
		return graphicsSprite;
	}

	private function _createTextForObject( object ):Sprite
	{
		var objectGraphics = object.getComponent( "graphics" );
		var textSprite = new Sprite();
		var text:Dynamic = objectGraphics.getText();
		if( text == null )
			return textSprite;

		if( text.first.font != null )
			textSprite.addChild( this._createText( text.first ) );

		if( text.second.font != null )
			textSprite.addChild( this._createText( text.second ) );

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
		if( objectName == "recruitWindowHeroButton" || objectName == "innWindowHeroButton" )
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

		var heroType:String = hero.getComponent( "name" ).get( "type" );
		var heroName:String = hero.getComponent( "name" ).get( "fullName" );
		var heroLevel:Int = hero.getComponent( "experience" ).get( "lvl" );

		var buttonGraphicsComponent:Graphics = button.getComponent( "graphics" );
		var buttonImg:Dynamic = buttonGraphicsComponent.getImg();
		var buttonTxt:Dynamic = buttonGraphicsComponent.getText();
		// { 'text1': { "text": "yuppei",x: 1, y:2 }, 'text2': { "text": "yuppieey", x: 1, y:2 } };
		// { "0": { "x": 0, "y": 0, "url": "//..." }, "1": { x, y , url }};
		buttonTxt.first.text = heroName;
		buttonTxt.second.text = heroType;
		var newButton:Sprite = this._createWindowButton( button );
		newButton.y += newButton.height * num;

		recruitWindowGraphicsInstance.addChild( newButton );
		//TODO: hero lvl - draw image, draw hero picture;
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

		var oneData = new Bitmap( Assets.getBitmapData( objectGraphics.getImg().one.url ) );
		var twoData = new Bitmap( Assets.getBitmapData( objectGraphics.getImg().two.url ) );

		oneData.visible = true;
		twoData.visible = false;

		oneData.x = objectGraphics.getImg().one.x;
		oneData.y = objectGraphics.getImg().one.y;

		twoData.x = objectGraphics.getImg().two.x;
		twoData.y = objectGraphics.getImg().two.y;

		buildingSprite.addChild( oneData );
		buildingSprite.addChild( twoData );

		sprite.addChild( buildingSprite );

		var coords = objectGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text = objectGraphics.getText();
		if( text != null )
		{
			textSprite.addChild( this._createText( text.first ) );
			textSprite.addChild( this._createText( text.second ) );

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