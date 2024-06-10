extends Node

# Gameplay Events
signal OnPegCollided(peg, impactPoint)
signal OnBallDestroyed()
signal OnBoardRefresh()
signal OnGameStateChanged(state: Game.GAME_STATE)
signal OnGameRoundFinished(score: int)
signal OnResetBoard()

# Content Events
signal OnLoadingComplete()
signal OnLoadingError()

signal OnRunStart()
signal OnBallDropped()

signal OnGameRestart()
signal OnPhaseChange(phaseName, newState)
signal OnPhaseChangeFinished(newState)

# UI Events
signal OnScreenChange(screenName: String)
signal OnHideScreens()
signal OnHideHUD()
signal OnAlertMessage(message: String, color: Color)
