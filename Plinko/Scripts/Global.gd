extends Node

# general
var gameState: Game.GAME_STATE = Game.GAME_STATE.BEGIN
var currentRound: int = 1
var ballGravity: float = 9.8
var launchPower: float = 100.0

# player stats
var ballBounciness: float = 1.0
var pegDamagePower: int = 70
var ballAmount: int = 2

# peg spawn amounts
var multiPegAmount: int = 2
var refreshPegAmount: int = 1
var bombPegAmount: int = 5

# perks
var platformPower: float = 875.0
var platformSpeed: float = 3.0
