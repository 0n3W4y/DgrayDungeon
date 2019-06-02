package;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;

class GraphicsSystem
{
	private var _parent:Game;
	

	public function new( parent:Game ):Void
	{
		_parent = parent; 
	}

	public function drawScene( scene:Scene ):Void
	{
		if( scene.getGraphicsInstance() == null )
		{
			var backgroundURL = scene.getBackgroundImageURL();
			var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
			scene.setGraphicsInstance( bitmap );
			scene.addChild( bitmap );
		}
		else
		{
			scene.addChild( scene.getGraphicsInstance() );
		}

		//add windows;
		//add buttons;
		var sceneUiEntities = scene.getUiEntities();

		//add entities;
		/*
		var sp:Sprite = new Sprite();
            txt1 = new TextField();
            
            sp.graphics.beginFill    (0xD006ff, 0.5);
            sp.graphics.drawRect    (0, 0, 30, 30);
            sp.x = i * 30 + 120 + i * 2; 
            sp.y = Main.maxHeight - 75;
            
            txt1.visible = true; 
            txt1.selectable    = false; 
            txt1.width     = 30;    
            txt1.height = 30;
            txt1.autoSize = TextFieldAutoSize.CENTER;
            txt1.textColor = 0xfcc0fc;
            txt1.text = tabConcat[i];
            sp.addChild    (txt1);
            addChild(sp);
		*/

		
		this._parent.getMainSprite().addChild( scene );
	}

	public function undrawScene( scene: Scene ):Void
	{

	}

	public function draw( scene:Scene, object:Entity ):Void
	{

	}

	public function unDraw( object:Entity ):Void;
	{

	}
}