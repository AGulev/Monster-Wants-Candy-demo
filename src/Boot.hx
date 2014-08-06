package ;
import phaser.core.Game;
import phaser.core.ScaleManager;

/**
 * ...
 * @author AGulev
 */
class Boot 
{
	var game:Game;

	public function new(game) 
	{
		this.game = game;
	}
	
	public function preload() 
	{		
		// preload the loading indicator first before anything else
		game.load.image('preloaderBar', 'img/loading-bar.png');
	}
	
	public function create() 
	{
		// set scale options
		game.input.maxPointers = 1;
		game.scale.scaleMode = ScaleManager.SHOW_ALL;
		game.scale.pageAlignHorizontally = true;
		game.scale.pageAlignVertically = true;
		game.scale.setScreenSize(true);
		// start the Preloader state
		game.state.start('Preloader');
	}
	
}