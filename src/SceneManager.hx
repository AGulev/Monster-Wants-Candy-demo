package  ;
import flambe.asset.AssetPack;
import flambe.asset.File;
import flambe.Entity;
import flambe.scene.Director;
import flambe.scene.Scene;
import haxe.Json;

/**
 * ...
 * @author Alexey Gulev
 */
class SceneManager
{
	public var director (default, null) :Director;
	public var pack (default, null) :AssetPack;
	
	private var mapScene:LevelMap;

	public function new(pack:AssetPack, director:Director) 
	{
		pack = pack;
		director = director;
		mapScene = new LevelMap();
		
        var pipesTexture = pack.getTexture("pipes");
		var altPipesTexture = pack.getTexture("pipes_w");
		var levelsFile:File = pack.getFile("levels.json");
		var levelsJSon: { levels:Array<Dynamic> } = Json.parse(levelsFile.toString());
		
		mapScene.init(pipesTexture, altPipesTexture, convertToType(levelsJSon));
		var game:Entity;
		game = mapScene.generateMap(1).add(new Scene());	
		goto(game);				
		levelsFile.reloadCount.changed.connect(function(to:Int, from:Int)
		{
			var levelsJSon: { levels:Array<Dynamic> } = Json.parse(levelsFile.toString());
			director.scenes[0].dispose();
			mapScene.init(pipesTexture, altPipesTexture, convertToType(levelsJSon));
			goto(mapScene.generateMap(1).add(new Scene()));		
		});
	}
		
	private function convertToType(levelsJSon:{levels:Array<Dynamic>}):Array<LevelConfig>
	{
		var array:Array<LevelConfig> = new Array<LevelConfig>();
		for (i in 0...levelsJSon.levels.length) 
		{
			array[i] = new LevelConfig(levelsJSon.levels[i]);
		}
		return array;
	}
	
	private function goto(sceneEntity:Entity)
	{
		director.unwindToScene(sceneEntity); 
	}
}