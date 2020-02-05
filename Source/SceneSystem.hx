package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import Scene;
import Building;
import Window;

typedef SceneSystemConfig = 
{
	var Parent:Game;
	var GraphicsSprite:Sprite;
}

class SceneSystem
{
	private var _parent:Game;
	private var _scenesArray:Array<Scene>;
	private var _scenesSprite:Sprite;
	private var _activeScene:Scene;

	
	public function new( config:SceneSystemConfig ):Void
	{
		this._scenesSprite = config.GraphicsSprite;
		this._parent = config.Parent;
	}

	public function init():String
	{	
		if( this._parent == null )
			return 'Error in SceneSystem.init. Parent is "$this._parent"';

		if( this._scenesSprite == null )
			return 'Error in SceneSystem.init. Sprite is "$this._scenesSprite"';
		this._activeScene = null;
		this._scenesArray = new Array<Scene>();
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function update( time:Float ):Void
	{
		//we can add scenes to array , who need to update, and remove them if don't need to update;
		for( i in 0...this._scenesArray.length )
		{
			this._scenesArray[ i ].update( time );
		}
	}

	public function addScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check != null )
			throw 'Error in SceneSystem.addScene. Scene with name "$name" already in.';

		this._scenesArray.push( scene );
	}

	public function removeScene( scene:Scene ):Array<Dynamic>
	{
		var name:String = scene.get( "name" );
		var check = this._checkSceneIfExist( scene );
		if( check == null )
			return [ null, 'Error in SceneSystem.addScene. Scene with name "$name" does not exist.' ];

		var sceneToReturn:Scene = this._scenesArray[ check ];
		this._scenesArray.splice( check, 1 );
		return [ sceneToReturn, null ];
	}

	public function fastSwitchSceneTo( scene:Scene ):Void // fast switch between scenes, hide active and show scene; 
	{													//Использовать для перемещения между сценой города и выбором данжа.
		if( this._activeScene != null )
			this.hideScene( this._activeScene );

		this._activeScene = scene;
		this.showScene( scene );
	}

	public function changeSceneTo( scene:Scene ):Void //full undraw active scene, and draw new scene;
	{
		//TODO: Loader;

		if( this._activeScene != null )
			this.undrawScene( this._activeScene );

		this._activeScene = scene;
		this.drawScene( scene );
	}

	public function drawUiForScene( scene:Scene ):Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		if( windows == null )
			throw 'Error in SceneSystem.drawUiForScene. Scene does not have any widnows.';
		
		for( i in 0...windows.length )
		{
			var window:Window = windows[ i ];
			ui.addUiObject( windows[ i ] );
		}

	}

	public function undrawUiForScene( scene:Scene ):Void
	{
		var windows:Array<Window> = scene.getChilds( "ui" ).window;
		var ui:UserInterface = this._parent.getSystem( "ui" );

		var sceneId:GeneratorSystem.ID = scene.get( "id" );
		for( i in 0...windows.length )
		{
			var window:Window = windows[ i ];
			ui.removeUiObject( windows[ i ], sceneId );
		}
	}

	public function showScene( scene:Scene ):Void
	{
		scene.get( "sprite" ).visible = true;
	}

	public function hideScene( scene:Scene ):Void
	{
		scene.get( "sprite" ).visible = false;
	}

	public function prepareScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		switch( name )
		{
			case "startScene": this._prepareStartScene( scene );
			case "cityScene": this._prepareCityScene( scene );
			default: throw 'Error in SceneSystem.drawScene. Scene with name "$name" can not to be draw, no function for it.';
		}
	}

	public function prepareUiForScene( scene:Scene ):Void
	{

	}

	public function drawScene( scene:Scene ):Void
	{
		var name:String = scene.get( "name" );
		var prepared:String = scene.get( "prepared" );
		if( prepared == "unprepared" )
			throw 'Error in SceneSystem.drawScene. Scene with name: "$name" is "$prepared"';

		this._scenesSprite.addChild( scene.get( "sprite" ) );
		this._parent.getSystem( "ui" ).show();
	}

	public function undrawScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		this._scenesSprite.removeChild( sprite );
		this._parent.getSystem( "ui" ).hide();
		this.undrawUiForScene( scene );
		scene.changePrepareStatus( "unprepared" );
	}

	public function drawLoader():Void
	{

	}

	public function undrawLoader():Void
	{

	}

	public function getParent():Game
	{
		return this._parent;
	}

	public function getActiveScene():Scene
	{
		return this._activeScene;
	}

	public function getSceneByName( name:String ):Scene
	{
		for( i in 0...this._scenesArray.length )
		{
			var sceneName:String = this._scenesArray[ i ].get( "name" );
			if( sceneName == name )
				return this._scenesArray[ i ];
		}
		return null;
	}

	public function getSceneById( id:SceneID ):Scene
	{
		for( i in 0...this._scenesArray.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( id, this._scenesArray[ i ].get( "id" )))
				return this._scenesArray[ i ];
		}
		return null;
	}

	public function createScene( deployId:Int ):Array<Dynamic>
	{
		var sceneDeployId:SceneDeployID = SceneDeployID( deployId );
		var config = this._parent.getSystem( "deploy" ).getScene( sceneDeployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.createScene. Deploy ID: '" + deployId + "' doesn't exist in SceneDeploy data" ];

		var id:SceneID = SceneID( this._parent.createId() );
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var configForScene:SceneConfig =
		{
			ID: id,
			Name: config.name,
			DeployID: sceneDeployId,
			GraphicsSprite: sprite
		};
		var scene = new Scene( configForScene );
		var err:String = scene.init();
		if( err != null )
			return [ null, 'Error in GeneratorSystem.createScene. $err' ];

		var configWindow:Array<Int> = config.window;
		if( configWindow != null ) // Внутри Window есть чайлды в виде button. создаются в функции создании окна.
		{
			var ui:UserInterface = this._parent.getSystem( "ui" );
			for( i in 0...configWindow.length )
			{
				var windowDeployId:WindowDeployID = WindowDeployID( configWindow[ i ] );
				ui.createWindow( windowDeployId );
			}
		}

		var configBuilding:Array<Int> = config.building;
		if( configBuilding != null )
		{
			for( j in 0...configBuilding.length )
			{
				var createBuilding:Array<Dynamic> = this.createBuilding( configBuilding[ j ] );
				var building:Building = createBuilding[ 0 ];
				var buildingError:String = createBuilding[ 1 ];
				if( buildingError != null )
					return [ null, 'Error in GeneratorSystem.createScene. $buildingError' ];

				scene.addChild( building );
			}
		}

		this._scenesArray.push( scene );
		return [ scene, null ];
	}

	public function createBuilding( deployId:Int ):Array<Dynamic>
    {
    	var buildingDeployId:BuildingDeployID = BuildingDeployID( deployId );
        var config = this._parent.getSystem( "deploy" ).getBuilding( buildingDeployId );
        if( config == null )
            return [ null, "Error in GeneratorSystem.createBuilding. Deploy ID: '" + deployId + "' doesn't exist in BuildingDeploy data" ];

        var id:BuildingID = BuildingID( this._parent.createId() );
        var sprite:Sprite = new Sprite();
        var graphicsSprite:Sprite = this._createGraphicsSprite( config );
        sprite.addChild( graphicsSprite );
        var textSprite:Sprite = this._createTextSprite( config );
        sprite.addChild( textSprite );

        var moneyInt:Int = config.moneyAmount;
        var money:Player.Money = moneyInt;
        var buildingConfig:BuildingConfig =
        {
            ID: id,
            DeployID: buildingDeployId,
            Name: config.name,
            GraphicsSprite: sprite,
            UpgradeLevel: config.upgradeLevel,
            NextUpgradeId: config.nextUpgradeId,
            CanUpgradeLevel: config.canUpgradeLevel,
            UpgradePrice: money,
            HeroStorageSlotsMax: config.heroStorageSlotsMax,
            InventoryStorageSlotsMax: config.inventoryStorageSlotsMax

        };
        var building:Building = new Building( buildingConfig );
        var err:String = building.init();
        if( err !=null )
            return [ null, 'Error in GeneratorSystem.createBuilding. $err' ];
        
        return [ building, null ];
    }

	//PRIVATE

	private function _prepareStartScene( scene:Scene ):Void
	{
		this.drawUiForScene( scene );
		scene.changePrepareStatus( "prepared" );
	}

	private function _prepareCityScene( scene:Scene ):Void
	{
		var sprite:Sprite = scene.get( "sprite" );
		var buildingsArray:Array<Building> = scene.getChilds( "building" );
		for( i in 0...buildingsArray.length )
		{
			var building:Building = buildingsArray[ i ];
			var buildingSprite:Sprite = building.get( "sprite" );
			sprite.addChild( buildingSprite );
			var name:String = building.get( "name" );
			switch( name )
			{
				case "recruit":
				{
					//DO heroes in slots + start timer to rebuild heroes in it;
					var slots:Int = building.get( "maxSlots" );

				} 
				default : throw 'Error in SceneSystem._prepareCityScene. Building with name: "$name" no action assigned.';
			}
		}


		this._scenesSprite.addChild( sprite );
		this.drawUiForScene( scene );
		scene.changePrepareStatus( "prepared" );
	}

	private function _checkSceneIfExist( scene:Scene ):Int
	{
		for( i in 0...this._scenesArray.length )
		{
			if( scene.get( "id" ).match( this._scenesArray[ i ].get( "id" ) ) )
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