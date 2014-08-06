package ;
import phaser.core.Game;
import phaser.gameobjects.Text;

/**
 * ...
 * @author AGulev
 */
class Preloader
{
	var game:Game;

	public function new(game) 
	{
		this.game = game;
	}
	
	public function preload() 
	{
		// set background color and preload image
		game.stage.backgroundColor = '#B4D9E7';
		var preloadBar = game.add.sprite((Candy.GAME_WIDTH-311)/2, (Candy.GAME_HEIGHT-27)/2, 'preloaderBar');
		game.load.setPreloadSprite(preloadBar);
		// load images
		game.load.image('background', 'img/background.png');
		game.load.image('floor', 'img/floor.png');
		game.load.image('monster-cover', 'img/monster-cover.png');
		game.load.image('title', 'img/title.png');
		game.load.image('game-over', 'img/gameover.png');
		game.load.image('score-bg', 'img/score-bg.png');
		game.load.image('button-pause', 'img/button-pause.png');
		// load spritesheets
		game.load.spritesheet('candy', 'img/candy.png', 82, 98);
		game.load.spritesheet('monster-idle', 'img/monster-idle.png', 103, 131);
		game.load.spritesheet('button-start', 'img/button-start.png', 401, 143);
	}
	
	public function create() 
	{
		// start the MainMenu state
		game.state.start('MainMenu');
	}
	
	public function update()
	{
		
	}
}