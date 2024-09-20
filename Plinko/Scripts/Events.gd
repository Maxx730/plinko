extends Node

# Gameplay Events
signal OnPegCollided(peg, impactPoint)
signal OnBallDestroyed()
signal OnBoardRefresh()
signal OnGameStateChanged(state: Game.GAME_STATE)
signal OnGameRoundFinished(score: int)
signal OnGameRunEnd()
signal OnResetBoard()
signal OnBallDropped(ball)

signal OnBoardSectionEntered(section: BoardSection)

# Content Events
signal OnLoadingComplete()
signal OnLoadingError()

# Config Events
signal OnDesktopModeChanged(mode)

signal OnRunStart()

signal OnGameRestart()
signal OnPhaseChange(phaseName, newState)
signal OnPhaseChangeFinished(newState)

# UI Events
signal OnScreenChange(screenName: String)
signal OnHideScreens()
signal OnHideHUD()
signal OnAlertMessage(message: String, color: Color)
