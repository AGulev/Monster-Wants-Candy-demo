/**
 * ...
 * @author AGulev
 */
package ;
import phaser.core.Game;
import phaser.core.Group;
import phaser.gameobjects.Text;
import phaser.Phaser;

class Candy 
{
	public static var GAME_WIDTH:Int = 640;
	public static var GAME_HEIGHT:Int = 960;

	static function main() 
	{
		// initialize the framework
		var game = new Game(GAME_WIDTH, GAME_HEIGHT, Phaser.AUTO, 'game');
		game.state.add('Boot',Boot);
		game.state.add('Preloader', Preloader);
		game.state.add('MainMenu', MainMenu);
		game.state.add('Game', GameProcess);
		// start the Boot state
		game.state.start('Boot');
	}
}