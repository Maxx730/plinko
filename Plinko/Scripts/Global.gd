extends Node

# general
var gameState: Game.GAME_STATE = Game.GAME_STATE.BEGIN
var gameSpeed: Game.GAME_SPEED = Game.GAME_SPEED.NORMAL
var currentRound: int = 1
var ballGravity: float = 9.8

# player stats
var ballBounciness: float = 1.0
var pegDamagePower: int = 5
var ballAmount: int = 2

# peg spawn amounts
var multiPegAmount: int = 2
var refreshPegAmount: int = 1
var bombPegAmount: int = 1

# perks
var platformPower: float = 875.0
var platformSpeed: float = 3.0
