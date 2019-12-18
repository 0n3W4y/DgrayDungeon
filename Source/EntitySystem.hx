package;

class EntitySystem
{
	private var _parent:Game;
	private var _nextId:Int = 0;
	private var _config:Dynamic;
	private var _namesAlreadyInUse:Array<Dynamic>;


	private function _createId():String
	{
		var id = "" + this._nextId;
		this._nextId++;
		return id ;
	}

	private function _createNameForHero( gender:String ):Array<String>
	{
		//TODO: genderNames;
		//TODO: data names into config.json;
		var names:Array<String> = [ "Alex", "Sally", "Edward", "Bob", "Alice", "Odry", "Cooper", "Ann", "Chris", "Jack", "Oxy", "Sea", "Dobby", "Dolly", "Saimon" ];
		var surnames:Array<String> = [ "Oldrich", "Slowpoke", "Duckman", "Smith", "Oldman", "Cage", "Travolta", "Parker", "Stark", "Anderson", "Tears", "Gold", "Walker" ];
		var number:Int = names.length + surnames.length;
		var name:String = null;
		var surname:String = null;
		var done:Bool = false;
		for( i in 0...number )
		{
			if( !done )
			{
				name = names[ Math.floor( Math.random() * names.length ) ];
				surname = surnames[ Math.floor( Math.random() * surnames.length ) ];
				for( j in 0...this._namesAlreadyInUse.length ) //check for doubles;
				{
					var usedName:Array<String> = this._namesAlreadyInUse[ j ];
					if( usedName[ 0 ] == name && usedName[ 1 ] == surname )
					{
						done = false;
						break;
					}
					//test trace
					//trace( "Used = " + usedName[ 0 ] + " " + usedName[ 1 ] + "New  = " + name + " " + surname );
				}
				done = true;
			}
			else
			{
				break;
			}			
		}
		
		var result:Array<String> = new Array<String>();
		result.push( name );
		result.push( surname );
		this._namesAlreadyInUse.push( result );
		return result;
	}

	private function _createWindowButtonType( id:String, type:String, name:String,  params:Dynamic ):Entity
	{
		var uiObject:Entity = new Entity( this, id, type, name );
		var config:Dynamic = this._config.window;
		if( type == "button" )
			config = this._config.button;

		var uiObjectConfig:Dynamic = null;
		for( obj in Reflect.fields( config ) )
		{
			if( obj == name )
			{
				uiObjectConfig = Reflect.getProperty( config, obj );
				break;
			}
		}

		for( key in Reflect.fields( uiObjectConfig ) )
		{
			var value:Dynamic = Reflect.getProperty( uiObjectConfig, key );
			var component:Dynamic = null;
			switch( key )
			{
				case "event":
				{
					var newEvent = {};
					/*
					for( obj in Reflect.fields( value ) )
					{
						var newValue = Reflect.getProperty( value, obj );
						Reflect.setProperty( newEvent, obj, newValue );
					}
					*/
					component = this.createComponent( "event", newEvent );
				}
				case "graphics": 
				{
					var newGraphics = { 
						"queue": null, "x": null,"y": null, 
							"img": { 
								"one": { "x": null,	"y": null, "url": null },
								"two": { "x": null,	"y": null, "url": null },
								"three": { "x": null, "y": null, "url": null },
								"four": { "x": null, "y": null, "url": null },
								"five": { "x": null, "y": null, "url": null },
							}, 
							"text": {
								"first": {	"text": null, "x": null, "y": null,	"font": null, "size": null,	"color": null, "visible": null,	"selectable": null,	"height": null,	"width": null, "queue": null },
								"second": {	"text": null, "x": null, "y": null,	"font": null, "size": null,	"color": null, "visible": null,	"selectable": null,	"height": null,	"width": null, "queue": null }
							}
					};
					for( obj in Reflect.fields( value ) )
					{

						var newValue:Dynamic = Reflect.getProperty( value, obj );
						switch ( obj )
						{
							case "img":
							{
								if( newValue == null )
								{
									newGraphics.img = null;
									continue;
								}

								for( box in Reflect.fields( newValue ) )
								{
									var result:Dynamic = Reflect.getProperty( newValue, box );
									var valueToChange:Dynamic = Reflect.getProperty( newGraphics.img, box );
									valueToChange.x = result.x;
									valueToChange.y = result.y;
									valueToChange.url = result.url;
								}							
							}
							case "text":
							{
								if( newValue == null )
								{
									newGraphics.text = null;
									continue;
								}

								for( box in Reflect.fields( newValue ) )
								{
									var result:Dynamic = Reflect.getProperty( newValue, box );
									var valueToChange:Dynamic = Reflect.getProperty( newGraphics.text, box );
									valueToChange.x = result.x;
									valueToChange.y = result.y;
									valueToChange.text = result.text;
									valueToChange.font = result.font;
									valueToChange.size = result.size;
									valueToChange.color = result.color;
									valueToChange.visible = result.visible;
									valueToChange.selectable = result.selectable;
									valueToChange.height = result.height;
									valueToChange.width = result.width;
									valueToChange.queue = result.queue;
								}							
							}
							case "queue", "x", "y":
							{
								Reflect.setProperty( newGraphics, obj, newValue );
							}
						}
					}
					component = this.createComponent( "graphics", newGraphics );
				}
				case "ui":
				{
					var newUi:Dynamic = { "parentWindow": null };
					for( obj in Reflect.fields( value ) )
					{
						var newValue = Reflect.getProperty( value, obj );
						Reflect.setProperty( newUi, obj, newValue );
					}
					component = this.createComponent( "ui", newUi );
				}
				default:
				{
					trace( "Error in EntitySystem._createWindowButtonType. No key with name: " + key + " in config with type: " + type );
				}
			}
			
			this.addComponentTo( component, uiObject );
		}

		return uiObject;
	}

	private function _createBuilding( id:String, type:String, name:String, params:Dynamic ):Entity
	{
		var building = new Entity( this, id, type, name );
		var config:Dynamic = this._config.building;
		var buildingConfig:Dynamic = null;
		for( obj in Reflect.fields( config ) )
		{
			if( obj == name )
			{
				buildingConfig = Reflect.getProperty( config, obj );
				break;
			}
		}

		for( key in Reflect.fields( buildingConfig ) )
		{
			var value = Reflect.getProperty( buildingConfig, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, building );
		}


		return building;
	}

	private function _generateHeroParams():Dynamic
	{
		var heroList:Array<String> = new Array();
		for( key in Reflect.fields( this._config.hero) )
		{
			heroList.push( key );
		}

		var randomHeroNum = Math.floor( Math.random() * ( heroList.length ) ); // heroList.length - 1 + 1 ;
		var heroName = heroList[ randomHeroNum ];
		var rarityNum = Math.floor( Math.random() * 100 ); // 0 - 65%, 1 - 20%, 2 - 10%, 3 - 5%
		var rarity:Int = 0;
		if( rarityNum < 10 )
			rarity = 2;
		else if( rarityNum >= 75 && rarityNum < 95 )
			rarity = 1;
		else if( rarityNum >= 95 )
			rarity = 3;
		var params:Dynamic = { "rarity": rarity, "name": heroName };
		return params;
	}

	private function _createHero( id:String, type:String, name:String, params:Dynamic ):Entity
	{
		if( params == null )
			params = this._generateHeroParams();

		if( name == null )
			name = params.name;

		var hero = new Entity( null, id, type, name );
		var config:Dynamic = this._config.hero;
		var heroRarity:Int = params.rarity; // "common"-0, "uncommon"-1, "rare"-2, "legendary"-3;
		var heroConfig:Dynamic = null;
		var heroTypeConfig:Dynamic = null;
		var skill:Dynamic = null;
		var trait:Dynamic = null;

		for( key in Reflect.fields( config ) )
		{
			if( key == name )
			{
				heroConfig = Reflect.getProperty( config, key );
				break;
			}
		}

		for( num in Reflect.fields( heroConfig ) )
		{
			var value:Dynamic = Reflect.getProperty( heroConfig, num );
			var component:Dynamic = null;
			switch( num )
			{
				case "event": component = this.createComponent( num, value );
				case "name": 
				{
					var newNames:Array<String> = this._createNameForHero( null );
					var newName:String = newNames[ 0 ];
					var newSurname:String = newNames[ 1 ];
					// genderNames;
					
					var nameConfig:Dynamic = 
					{
						"name": newName,
						"surname": newSurname,
						"rank": null,
						"type": value.type,
						"rarity": value.rarity[ heroRarity ]
					};
					//TODO: Generate name;
					component = this.createComponent( num, nameConfig );
				}
				case "experience":
				{
					var experience:Dynamic = 
					{
						"lvl": 1,
						"exp": 0,
						"expToNextLvl": value.expToNextLvl[ heroRarity ],
						"maxLvl": 10
					};
					component = this.createComponent( num, experience );
				}
				case "inventory":
				{
					component = this.createComponent( num, value );
				}
				case "graphics":
				{
					//TODO: Do some graphics for hero rarity;
					component = this.createComponent( num, value );
				}
				case "stats":
				{
					var stats = 
					{
						"hp": value.hp[ heroRarity ],
						"acc": value.acc[ heroRarity ],
						"ddg": value.ddg[ heroRarity ], 
						"cc": value.cc[ heroRarity ],
						"def": value.def[ heroRarity ],
						"dmg": value.dmg[ heroRarity ],
						"spd": value.spd[ heroRarity ],
						"cd": value.cd[ heroRarity ],
						"stress": value.stress[ heroRarity ],
						"stun": value.stun[ heroRarity ],
						"poison": value.poison[ heroRarity ],
						"bleed": value.bleed[ heroRarity ],
						"diseas": value.diseas[ heroRarity ],
						"debuff": value.debuff[ heroRarity ],
						"move": value.move[ heroRarity ],
						"fire": value.fire[ heroRarity ],
						"upHp": value.upHp[ heroRarity ],
						"upAcc": value.upAcc[ heroRarity ],
						"upDdg": value.upDdg[ heroRarity ], 
						"upCc": value.upCc[ heroRarity ],
						"upDef": value.upDef[ heroRarity ],
						"upDmg": value.upDmg[ heroRarity ],
						"upSpd": value.upSpd[ heroRarity ],
						"upCd": value.upCd[ heroRarity ],
						"upStress": value.upStress[ heroRarity ],
						"upStun": value.upStun[ heroRarity ],
						"upPoison": value.upPpoison[ heroRarity ],
						"upBleed": value.upBleed[ heroRarity ],
						"upDiseas": value.upDiseas[ heroRarity ],
						"upDebuff": value.upDebuff[ heroRarity ],
						"upMove": value.upMove[ heroRarity ],
						"upFire": value.upFire[ heroRarity ],
						"position": value.position[ heroRarity ],
						"target": value.target[ heroRarity ]
					};
					component = this.createComponent( num, stats );
				};
				case "traits":
				{
					var traits = 
					{
						"maxNumOfPositive": value.maxNumOfPositive[ heroRarity ],
						"maxNumOfNegative": value.maxNumOfNegative[ heroRarity ],
						"maxNumOfPositiveStatic": value.maxNumOfPositiveStatic[ heroRarity ],
						"maxNumOfNegativeStatic": value.maxNumOfNegativeStatic[ heroRarity ]
					}
					// TODO: generate traits and add it to component;
					var traitConfig:Dynamic = this._config.trait;
					component = this.createComponent( num, traits );

				};
				case "skills":
				{
					var maxActive = value.active.maxActiveSkills[ heroRarity ];
					var maxPassive = value.passive.maxPassiveSkills[ heroRarity ];
					var maxCamping = value.camping.maxCampingSkills[ heroRarity ];
					var skills = 
					{
						"maxActiveSkills": maxActive,
						"maxStaticActiveSkills": value.active.maxStaticActiveSkills[ heroRarity ],
						"maxPassiveSkills": maxPassive,
						"maxStaticPassiveSkills": value.passive.maxStaticPassiveSkills[ heroRarity ],
						"maxCampingSkills": maxCamping,
						"maxStaticCampingSkills": value.camping.maxStaticCampingSkills[ heroRarity ]
					}
					component = this.createComponent( num, skills );

					//generate skills into component;
					for( k in 0...2 )
					{
						var list:Dynamic = value.active.skills;
						var maxSkills:Int = maxActive;
						var typeSkill:String = "active";
						if( k == 1 )
						{
							list = value.passive.skills;
							typeSkill = "passive";
							maxSkills = maxPassive;
						}

						var arrayList:Array<String> = new Array();
						for( key in Reflect.fields( list ) )
						{
							if( key == "basic" ) // need to use basic skill always;
								continue;
							arrayList.push( key ); // [ "skill1", "skill2", "skill3" ];
						}
						var dif = arrayList.length - maxSkills;// find diffirence from array to max skills;

						for( j in 0...dif )// try to cut random skills from array of skills;
						{
							var randomNum = Math.floor( Math.random() * arrayList.length );
							arrayList.splice( randomNum, 1 );
						}
						if( k == 0 )
							arrayList.push( "basic" ); // add basic skill back;

						for( i in 0...arrayList.length )// create skills;
						{
							var skill = Reflect.getProperty( list, arrayList[ i ] );
							var newSkill = 
							{
								"name": skill.name,
								"isChoosen": false,
								"isStatic": false,
								"upgradeLevel": 0,
								"onCooldawn": 0,
								"maxUpgradeLevel": skill.maxUpgradeLevel,
								"value": skill.upgradeValue.value[ 0 ], //upgradeLevel = 0;
								"type": skill.upgradeValue.type,
								"effect": skill.upgradeValue.effect,
								"removeEffect": skill.upgradeValue.removeEffect,
								"valueType": skill.upgradeValue.valueType,
								"action": skill.upgradeValue.action,
								"targetStat": skill.upgradeValue.targetStat, 
								"duration": skill.upgradeValue.duration[ 0 ],
								"cooldawn": skill.upgradeValue.cooldawn[ 0 ],
								"target": skill.upgradeValue.target[ 0 ]							
							};
							component.addSkill( newSkill, typeSkill );
						}
					}

					var listOfCamping = value.camping.skills;

					
				}
				default : trace( "Error in EntitySystem._heroConfig, no key with name: " + num + ", in container with heroType: " + heroRarity );
			}
			this.addComponentTo( component, hero );
		}

		//Test for console.
		//trace( hero.get( "name" ) + "; " + hero.get( "type" ) + "; " + hero.getComponent( "name" ).get("fullName") + "; " + hero.getComponent( "name" ).get("rarity") );
		//trace( hero.getComponent( "inventory").getInventory() );
		return hero;
	}

	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._config = params;
		this._namesAlreadyInUse = new Array();
	}


	public function createEntity( type:String, name:String, params:Dynamic ):Entity
	{
		var id = this._createId();
		switch( type )
		{
			case "window", "button" : return this._createWindowButtonType( id, type, name, params );
			case "building" : return this._createBuilding( id, type, name, params );
			case "hero": return this._createHero( id, type, name, params );
			default: trace( "Error in EntitySystem.createEntity, can't find entity with type: " + type + "." );
		};
		return null;
	}

	public function addComponentTo( component:Component, entity:Entity ):Void
	{
		entity.addComponent( component );
	}

	public function createComponent( componentName:String, params:Dynamic ):Component
	{
		var component:Component = null;
		switch( componentName )
		{
			case "graphics": component = new Graphics( null, params );
			case "ui": component = new UI( null, params );
			case "name": component = new Name( null, params );
			case "inventory": component = new Inventory( null, params );
			case "skills": component = new Skills( null, params );
			case "stats": component = new Stats( null, params );
			case "traits": component = new Traits( null, params );
			case "experience": component = new Experience( null, params );
			case "event": component = new Event( null, params );
			default: trace( "Error in EntitySystem.createComponent, component with name: '" + componentName + "' does not exist." );
		}
		return component;
	}

	public function addEntityToScene( entity:Entity, scene:Scene ):Void
	{
		entity.setParent( scene );
		var type = entity.get( "type" );
		switch( type )
		{
			case "window": scene.getEntities( "ui" ).window.push( entity );
			case "button": scene.getEntities( "ui" ).button.push( entity );
			case "building": scene.getEntities( "object" ).building.push( entity );
			case "hero": scene.getEntities( "alive" ).hero.push( entity );
			case "enemy": scene.getEntities( "alive" ).enemy.push( entity );
			default: trace( "Error in Scene.addEntity, can't add entity with name: " + entity.get( "name" ) + ", and type: " + type + "." );
		}
	}

	public function createEntitiesForScene( scene:Scene, type:String, list:Array<String> )
	{
		var paramsContainer = Reflect.getProperty( this._config, type );
		if(  paramsContainer == null )
			trace( "Error in EntitySystem.createEntitiesForScene, can't find type: " + type + " into config container!" );
		for( i in 0...list.length )
		{	
			var object = this.createEntity( type, list[ i ], null );
			this.addEntityToScene( object, scene );
		}
	}

	public function createHeroRecruitWithButton( scene:Scene ):Void
	{
		var hero = this.createEntity( "hero", null, null );
		this.addEntityToScene( hero, scene );
		var heroType:String = hero.getComponent( "name" ).get( "type" );
		var heroName:String = hero.getComponent( "name" ).get( "fullName" );
		var heroRarity:String = hero.getComponent( "name" ).get( "rarity" );
		var heroLvl:Int = hero.getComponent( "experience" ).get( "lvl" );
		var heroId:String = hero.get( "id" );
		trace( heroRarity );
		//var heroPicture:String = hero.getComponent( "graphics" ).getImg().one; // get picture ( portrait of hero );

		var checkStoreInInventory:Int = building.getComponent( "inventory" ).setItemInSlot( hero, null );
		if( checkStoreInInventory == 0 ) //check function inventory to store hero;
			trace( "Error in EntitySystem.createHeroRecruitWithButton with add Hero char in inventory to building in " + i + " round. " + checkStoreInInventory );

		var button:Entity = this.createEntity( "button", "recruitWindowHeroButton", null );
		var buttonText:Dynamic = button.getComponent( "graphics" ).getText();
		var buttonImg:Dynamic = button.getComponent( "graphics" ).getImg();
		buttonText.first.text = heroName;
		buttonText.second.text = heroType;
		button.getComponent( "ui" ).setHeroId( heroId );
		/*
		var buttonImageUrlRarity:String = null;
		switch( heroRarity )
		{
			case "common":{ buttonImageUrlRarity = "/commonRecruitButton.png" }
			case "uncommon":{ buttonImageUrlRarity = "/uncommonRecruitButton.png" }
			case "rare": { buttonImageUrlRarity = "/rareRecruitButton.png" }
			case "legendary": { buttonImageUrlRarity = "/legendaryRecruitButton.png" }
			default: { trace( "Error in EntitySystem.createHeroRecruitWithButton. Hero rarity can't be: " + heroRarity ) }
		}
		buttonImg.one.url = buttonImageUrlRarity;
		*/
		this.addEntityToScene( button, scene );

	}

	public function getConfig():Dynamic
	{
		return this._config;
	}

	public function removeEntity( entity:Entity ):Entity
	{
		var parentEntity:Scene = entity.get( "parent" ); //here we expect any Scene;
		var entityId:Int = entity.get( "id" );
		var entityArray:Array<Entity> = null;
		if( Std.is( parentEntity, Scene ) )
		{
			var entityType:String = entity.get( "type" );
			switch( entityType )
			{
				case "hero":
				{
					entityArray = parentEntity.getEntities( "alive" ).hero;
				}
				case "window": 
				{
					entityArray = parentEntity.getEntities( "ui" ).window;
				}
				case "button":
				{
					entityArray = parentEntity.getEntities( "ui" ).button;
				}
				default:
				{
					trace( "Error, EntitySystem.removeEntity. Can't remove entity with type: " + entityType );
				}
			}
			if( entityArray != null )
			{
				for( i in 0...entityArray.length )
				{
					var oldEntity:Entity = entityArray[ i ];
					if( oldEntity.get( "id" ) == entityId )
					{
						entityArray.splice( i, 1 );
						return oldEntity;
					}
				}
			}
			else
			{
				trace( "Error in EntitySystem.removeEntity. entityArray = " + entityArray );
				return null;
			}

		}
		trace( "Error in EntitySystem.removeEntity. parentEntity = " + parentEntity );
		return null;
	}
}