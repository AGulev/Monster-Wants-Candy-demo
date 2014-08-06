package ;
import phaser.core.Game;

/**
 * ...
 * @author AGulev
 */
class MainMenu
{
	var game:Game;

	public function new(game) 
	{
		this.game = game;
	}
	
	public function create() 
	{
		// display images
		game.add.sprite(0, 0, 'background');
		game.add.sprite(-130, Candy.GAME_HEIGHT-514, 'monster-cover');
		game.add.sprite((Candy.GAME_WIDTH-395)/2, 60, 'title');
		// add the button that will start the game
		game.add.button(Candy.GAME_WIDTH-401-10, Candy.GAME_HEIGHT-143-10, 'button-start', startGame, game, 1, 0, 2);
	}
	
	function startGame() 
	{
		game.state.start('Game');
	}
	
}