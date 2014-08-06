package ;
import haxe.CallStack.StackItem;
import phaser.core.Game;
import phaser.core.Group;
import phaser.gameobjects.Sprite;
import phaser.gameobjects.Text;
import phaser.physics.Physics;

/**
 * ...
 * @author AGulev
 */
class GameProcess
{
	var game:Game;
	
	var _player:Sprite;
	var _spawnCandyTimer:Float;
	var _fontStyle:Dynamic;
	
	var pausedText:Text;
	
	var scoreText:Text;
	var score:Int;
	var health:Int;
	var candyGroup:Group;
	
	public function new(game) 
	{
		this.game = game;
		_player = null;
		candyGroup = null;
		_spawnCandyTimer = 0;
		_fontStyle = null;
		// define Candy variables to reuse them in Candy.item functions
		scoreText = null;
		score = 0;
		health = 10;
	}
	
	function create(){
		// start the physics engine
		game.physics.startSystem(Physics.ARCADE);
		// set the global gravity
		game.physics.arcade.gravity.y = 200;
		// display images: background, floor and score
		game.add.sprite(0, 0, 'background');
		game.add.sprite(-30, Candy.GAME_HEIGHT-160, 'floor');
		game.add.sprite(10, 5, 'score-bg');
		// add pause button
		game.add.button(Candy.GAME_WIDTH-96-10, 5, 'button-pause', managePause, this);
		// create the player
		_player = game.add.sprite(5, 760, 'monster-idle');
		// add player animation
		_player.animations.add('idle', [0,1,2,3,4,5,6,7,8,9,10,11,12], 10, true);
		// play the animation
		_player.animations.play('idle');
		// set font style
		_fontStyle = { font: "40px Arial", fill: "#FFCC00", stroke: "#333", strokeThickness: 5, align: "center" };
		// initialize the spawn timer
		_spawnCandyTimer = 0;
		// initialize the score text with 0
		scoreText = game.add.text(120, 20, "0", _fontStyle);
		// set health of the player
		health = 10;
		// create new group for candy
		candyGroup = game.add.group();
		// spawn first candy
		spawnCandy();
	}
	
	function managePause() 
	{
		// pause the game
		game.paused = true;
		// add proper informational text
		pausedText = game.add.text(100, 250, "Game paused.\nTap anywhere to continue.", this._fontStyle);
		// set event listener for the user's click/tap the screen
		game.input.onDown.add(function(){
			// remove the pause text
			game.world.remove(pausedText);
			// unpause the game
			game.paused = false;
		}, this);
	}
	
	function update()
	{
		// update timer every frame
		_spawnCandyTimer += game.time.elapsed;
		// if spawn timer reach one second (1000 miliseconds)
		if(_spawnCandyTimer > 1000) {
			// reset it
			_spawnCandyTimer = 0;
			// and spawn new candy
			spawnCandy();
		}
		// loop through all candy on the screen
		candyGroup.forEach(function(candy){
			// to rotate them accordingly
			candy.angle += 2;
		},this);
		// if the health of the player drops to 0, the player dies = game over
		if(health <= 0) {
			// show the game over message
			game.add.sprite((Candy.GAME_WIDTH-594)/2, (Candy.GAME_HEIGHT-271)/2, 'game-over');
			// pause the game
			game.paused = true;
		}
	}
	
	function spawnCandy() {
		// calculate drop position (from 0 to game width) on the x axis
		var dropPos = Math.floor(Math.random()*Candy.GAME_WIDTH);
		// define the offset for every candy
		var dropOffset = [-25,-34,-34,-36,-44];
		// randomize candy type
		var candyType = Math.floor(Math.random()*5);
		// create new candy
		var candy = game.add.sprite(dropPos, dropOffset[candyType], 'candy');
		// add new animation frame
		candy.animations.add('anim', [candyType], 10, true);
		// enable candy body for physic engine
		game.physics.enable(candy, Physics.ARCADE);
		// enable candy to be clicked/tapped
		candy.inputEnabled = true;
		// add event listener to click/tap
		candy.events.onInputDown.add(this.clickCandy, this);
		// be sure that the candy will fire an event when it goes out of the screen
		candy.checkWorldBounds = true;
		// reset candy when it goes out of screen
		candy.events.onOutOfBounds.add(this.removeCandy, this);
		// set the anchor (for rotation, position etc) to the middle of the candy
		candy.anchor.setTo(0.5, 0.5);
		// set the random rotation value
		candy.rotation = (Math.random()*4)-2;
		// add candy to the group
		candyGroup.add(candy);
	}
	
	function clickCandy(candy){
		// kill the candy when it's clicked
		candy.kill();
		// add points to the score
		score += 1;
		// update score text
		scoreText.text = ""+score;
	}
	
	function removeCandy(candy){
		// kill the candy
		candy.kill();
		// decrease player's health
		health -= 10;
	}
}