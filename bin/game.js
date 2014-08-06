(function () { "use strict";
var Boot = function(game) {
	this.game = game;
};
Boot.prototype = {
	preload: function() {
		this.game.load.image("preloaderBar","img/loading-bar.png");
	}
	,create: function() {
		this.game.input.maxPointers = 1;
		this.game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
		this.game.scale.pageAlignHorizontally = true;
		this.game.scale.pageAlignVertically = true;
		this.game.scale.setScreenSize(true);
		this.game.state.start("Preloader");
	}
};
var Candy = function() { };
Candy.main = function() {
	var game = new Phaser.Game(Candy.GAME_WIDTH,Candy.GAME_HEIGHT,Phaser.AUTO,"game");
	game.state.add("Boot",Boot);
	game.state.add("Preloader",Preloader);
	game.state.add("MainMenu",MainMenu);
	game.state.add("Game",GameProcess);
	game.state.start("Boot");
};
var GameProcess = function(game) {
	this.game = game;
	this._player = null;
	this.candyGroup = null;
	this._spawnCandyTimer = 0;
	this._fontStyle = null;
	this.scoreText = null;
	this.score = 0;
	this.health = 10;
};
GameProcess.prototype = {
	create: function() {
		this.game.physics.startSystem(Phaser.Physics.ARCADE);
		this.game.physics.arcade.gravity.y = 200;
		this.game.add.sprite(0,0,"background");
		this.game.add.sprite(-30,Candy.GAME_HEIGHT - 160,"floor");
		this.game.add.sprite(10,5,"score-bg");
		this.game.add.button(Candy.GAME_WIDTH - 96 - 10,5,"button-pause",$bind(this,this.managePause),this);
		this._player = this.game.add.sprite(5,760,"monster-idle");
		this._player.animations.add("idle",[0,1,2,3,4,5,6,7,8,9,10,11,12],10,true);
		this._player.animations.play("idle");
		this._fontStyle = { font : "40px Arial", fill : "#FFCC00", stroke : "#333", strokeThickness : 5, align : "center"};
		this._spawnCandyTimer = 0;
		this.scoreText = this.game.add.text(120,20,"0",this._fontStyle);
		this.health = 10;
		this.candyGroup = this.game.add.group();
		this.spawnCandy();
	}
	,managePause: function() {
		var _g = this;
		this.game.paused = true;
		this.pausedText = this.game.add.text(100,250,"Game paused.\nTap anywhere to continue.",this._fontStyle);
		this.game.input.onDown.add(function() {
			_g.game.world.remove(_g.pausedText);
			_g.game.paused = false;
		},this);
	}
	,update: function() {
		this._spawnCandyTimer += this.game.time.elapsed;
		if(this._spawnCandyTimer > 1000) {
			this._spawnCandyTimer = 0;
			this.spawnCandy();
		}
		this.candyGroup.forEach(function(candy) {
			candy.angle += 2;
		},this);
		if(this.health <= 0) {
			this.game.add.sprite((Candy.GAME_WIDTH - 594) / 2,(Candy.GAME_HEIGHT - 271) / 2,"game-over");
			this.game.paused = true;
		}
	}
	,spawnCandy: function() {
		var dropPos = Math.floor(Math.random() * Candy.GAME_WIDTH);
		var dropOffset = [-25,-34,-34,-36,-44];
		var candyType = Math.floor(Math.random() * 5);
		var candy = this.game.add.sprite(dropPos,dropOffset[candyType],"candy");
		candy.animations.add("anim",[candyType],10,true);
		this.game.physics.enable(candy,Phaser.Physics.ARCADE);
		candy.inputEnabled = true;
		candy.events.onInputDown.add($bind(this,this.clickCandy),this);
		candy.checkWorldBounds = true;
		candy.events.onOutOfBounds.add($bind(this,this.removeCandy),this);
		candy.anchor.setTo(0.5,0.5);
		candy.rotation = Math.random() * 4 - 2;
		this.candyGroup.add(candy);
	}
	,clickCandy: function(candy) {
		candy.kill();
		this.score += 1;
		this.scoreText.text = "" + this.score;
	}
	,removeCandy: function(candy) {
		candy.kill();
		this.health -= 10;
	}
};
var MainMenu = function(game) {
	this.game = game;
};
MainMenu.prototype = {
	create: function() {
		this.game.add.sprite(0,0,"background");
		this.game.add.sprite(-130,Candy.GAME_HEIGHT - 514,"monster-cover");
		this.game.add.sprite((Candy.GAME_WIDTH - 395) / 2,60,"title");
		this.game.add.button(Candy.GAME_WIDTH - 401 - 10,Candy.GAME_HEIGHT - 143 - 10,"button-start",$bind(this,this.startGame),this.game,1,0,2);
	}
	,startGame: function() {
		this.game.state.start("Game");
	}
};
var Preloader = function(game) {
	this.game = game;
};
Preloader.prototype = {
	preload: function() {
		this.game.stage.backgroundColor = "#B4D9E7";
		var preloadBar = this.game.add.sprite((Candy.GAME_WIDTH - 311) / 2,(Candy.GAME_HEIGHT - 27) / 2,"preloaderBar");
		this.game.load.setPreloadSprite(preloadBar);
		this.game.load.image("background","img/background.png");
		this.game.load.image("floor","img/floor.png");
		this.game.load.image("monster-cover","img/monster-cover.png");
		this.game.load.image("title","img/title.png");
		this.game.load.image("game-over","img/gameover.png");
		this.game.load.image("score-bg","img/score-bg.png");
		this.game.load.image("button-pause","img/button-pause.png");
		this.game.load.spritesheet("candy","img/candy.png",82,98);
		this.game.load.spritesheet("monster-idle","img/monster-idle.png",103,131);
		this.game.load.spritesheet("button-start","img/button-start.png",401,143);
	}
	,create: function() {
		this.game.state.start("MainMenu");
	}
	,update: function() {
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
Candy.GAME_WIDTH = 640;
Candy.GAME_HEIGHT = 960;
Candy.main();
})();
