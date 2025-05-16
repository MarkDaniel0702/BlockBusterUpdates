.model small
.stack 100h
.code
org 100h
entry:
EXTERNDELAY = 3                                               ;delay for the movement and speed of the ball 

.data
	OpeningFileName	db	'Assets/Opening.bmp',0                ;title page bitmap 
	OpeningFileHandle dw ?                                    
	FileReadBuffer db 320 dup (?)
	PixelsPerChar equ 8  


	congratulations_text db 'Congrats, ', '$'                          
	score_text db 'Time Consumed: ', '$'                          
	timeScore dw 0                                            ;score for timed mode 
	scoreCount dw 0                                           ;bricks destroyed ctr 
	lives dw 3                                                ;lives ctr in level mode                              
	gamemode db 0                                             ;game mode determinator (0 -> level, 1 -> timed)                           
	soundOn db 1                                              ;1 -> soundOn, 0 -> soundOff

	tens db '5'         
    ones db '9'         
    timeCtr db 0
    timer_color db 0Fh  ;
	
	entername_text      db 'ENTER YOUR NAME:', '$'
    playername          db 21 dup (?)           ; Buffer for player's name input
    max_name_len        equ 20                  ; Maximum characters for player name
    input_start_row     db 0Fh                  ; Row for name input field
    input_start_col     db 0Ah                  ; Column for name input field
    max_chars_msg       db 'Max 20 characters$'
    middle_col          db 0                    ; Stores the calculated middle column for name input
    error_msg_row       db 14h                  ; Row where error messages are displayed
    name_required_msg   db 'Please enter your name!$'
    max_length_msg      db 'Max Character limit reached!$'

    PauseTitleRow       db 9                    ; Character row for "GAME PAUSED" text
    PauseTitleCol       db 13                   ; Character column for "GAME PAUSED" text

    PauseResumeRow      db 11                   ; Character row for "RESUME" text
    PauseResumeCol      db 14                   ; Character column for "RESUME" text

    PauseMainRow        db 13                   ; Character row for "MAIN MENU" text
    PauseMainCol        db 13                   ; Character column for "MAIN MENU" text

	
	controlB_text db '[B]Back', '$'                           
	control1_text db 'MOVE PADDLE', '$'
	control2_text db 'TOGGLE MENUS', '$'
	control3_text db 'SELECT', '$'
	controlL_text db 'LEVEL', '$'
	controlT_text db 'TIMED', '$'
	controlO_text db 'OPTIONS', '$'
	controlE_text db 'EXIT', '$'
	controlU_text db 'USING', '$'
	
	powerplaymode_text db 'POWERPLAY', '$'
	levelmode_text db 'LEVEL MODE', '$'
	timedmode_text db 'TIMED MODE','$'
	options_text db 'OPTIONS','$'
	nextlevel_text db 'NEXT', '$'
	exit_text db 'EXIT','$'
	mainmenu_text db 'MAIN MENU', '$'
	back_text db 'BACK', '$'
	yes_text db 'YES!', '$'
    no_text db 'NO:(','$'
	
	isPaused    db 0                        ; Flag to track if game is paused (0=not paused, 1=paused)
	pausedMsg   db "GAME PAUSED!$"           ; Pause message
	pauseResumeText   db "RESUME", "$"
    pauseMainMenuText db "MAIN MENU", "$"
	pauseBoxX   dw (10*8)  
    pauseBoxY   dw (8*8)  
    pauseBoxW   dw (20*8) 
    pauseBoxH   dw (8*8)   
    PauseBoxColor db 08h 
	pauseOpt    db 1        
	
	level1_text db 'LEVEL 1', '$'
	level2_text db 'LEVEL 2', '$'
	level3_text db 'LEVEL 3', '$'
	level4_text db 'LEVEL 4', '$'
	level5_text db 'LEVEL 5', '$'

	xloc dw ?             ; Para sa X ng underline (ginagamit ng drawSelect mo)
    yloc dw ?             ; Para sa Y ng underline
    wid  dw ?             ; Para sa Width ng underline
	
	opt db 1                                                  ;checks which menu option is chosen in the main menu 
	optCompleted db 1                                         ;checks which menu option is chosen in the Game Completed Page  
	optOver db 1                                              ;checks which menu option is chosen in the Game Over Page  
	optLevel db 1                                             ;checks which level is chosen
	optSound db 1                                             ;checks which option is chosen in the Options Page for the sound                                             
	control db 1                                              ;checks if the Controls Page will be shown
	begin db 0                                                ;checks if the game is set to begin (1 == begin)
	
	xlocRec dw 0                                              ;x-location of line 
	ylocRec dw 0                                              ;y-location of line 
	widRec dw 0                                               ;width of line 
	heightRec dw 0                                            ;height of line 
	
	tempLifeX dw 0                                            ;temp storage for the x-location of heart(life) 
	tempLifeY dw 0                                            ;temp storage for the y-location of heart(life) 
	tempX dw 0                                                ;temp storage for the x-location of Controls Page keys 
	tempY dw 0                                                ;temp storage for the y-location of Controls Page keys 
	tempW dw 0                                                ;temp storage for the width of Controls Page keys 
	tempH dw 0                                                ;temp storage for the height of Controls Page keys 
	
	ballX dw 158                                              ;initial X location of ball
	ballY dw 163                                              ;initial y-location of ball
	ballLeft db 1                                             ;checks if ball is moving to the left or right 
	ballUp db 1	                                              ;checks if ball is moving upwards or downwards 
	innerDelay db 0                                           ;speed of the ball (0 == slowest)
	fastBall db 0                                             ;checks the speed of the ball 
	
	color db 0	                                              ;color of multiple elements
	startx dw 0	                                              ;starting x-location of multiple elements
	starty dw 0                                               ;starting y-location of multiple elements
	endx dw 0                                                 ;ending x-location of multiple elements
	endy dw 0                                                 ;ending y-location of multiple elements
	 
	strikerX dw 140                                           ;initial x-location of the striker(paddle)
	strikerY dw 170                                           ;initial y-location of the striker(paddle)
	
	boundaryEnd dw 253                                        ;ending boundary for the ball and striker
	boundaryStart dw 30                                       ;starting boundary for the ball and striker
	
	;x and y-locations of the bricks
	brick1x dw 0                                              
	brick1y dw 0
	brick2x dw 0
	brick2y dw 0
	brick3x dw 0
	brick3y dw 0
	brick4x dw 0
	brick4y dw 0
	brick5x dw 0
	brick5y dw 0
	brick6x dw 0
	brick6y dw 0
	brick7x dw 0
	brick7y dw 0
	brick8x dw 0
	brick8y dw 0
	brick9x dw 0
	brick9y dw 0
	brick10x dw 0
	brick10y dw 0
	
	;------------------------------------------------
	;                    BITMAPS
	;------------------------------------------------
	
	life db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 0Eh, 00h, 00h, 00h, 00h, 00h, 00h, 0Eh, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
		db 00h, 00h, 04h, 0Fh, 0Fh, 0Ch, 04h, 00h, 04h, 0Fh, 0Ch, 04h, 04h, 00h, 00h
		db 00h, 04h, 0Fh, 0Ch, 0Ch, 0Fh, 0Ch, 04h, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 00h
		db 04h, 0Fh, 0Fh, 0Ch, 0Fh, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 04h
		db 04h, 0Fh, 04h, 0Fh, 0Ch, 0Ch, 0Ch, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 04h, 04h
		db 04h, 0Ch, 04h, 0Ch, 0Ch, 0Ch, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h
		db 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h
		db 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h
		db 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h
		db 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h
		
	down_key db 00h, 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h, 00h
       db 00h, 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h, 00h
       db 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h
       db 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 05h
       db 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h
       db 00h, 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h, 00h
       db 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h, 00h, 00h, 00h

	up_key db 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h, 00h, 00h, 00h
     db 00h, 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h, 00h
     db 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h
     db 05h, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
     db 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h
     db 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h
     db 00h, 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h, 00h
     db 00h, 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h, 00h

	left_key db 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 05h, 00h, 00h, 00h
       db 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h, 00h
       db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
       db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h
       db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
       db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h
       db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h
       db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
       db 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h, 00h, 00h
       db 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h

	right_key db 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h
        db 00h, 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h, 00h
        db 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h
        db 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h
        db 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh
        db 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh
        db 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h
        db 00h, 05h, 05h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 0Fh, 0Fh, 00h
        db 00h, 00h, 00h, 05h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Fh, 00h, 00h, 00h
        db 00h, 00h, 00h, 05h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h, 00h, 00h

	enter_key db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 05h, 00h, 00h, 00h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h
        db 00h, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 00h
        db 00h, 0Fh, 0Fh, 0Fh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 05h, 05h, 05h, 00h
        db 00h, 00h, 00h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 05h, 00h, 00h, 00h

	trophy db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 04h, 04h, 04h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 04h, 04h, 04h, 00h, 00h
      db 00h, 04h, 0Eh, 0Eh, 0Eh, 04h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 04h, 0Eh, 0Eh, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 06h, 06h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 06h, 06h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 04h, 04h, 04h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 00h, 00h, 00h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 04h, 04h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 04h, 04h, 0Eh, 04h, 00h
      db 00h, 04h, 0Eh, 0Eh, 04h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 04h, 0Eh, 0Eh, 04h, 00h
      db 00h, 00h, 04h, 0Eh, 04h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 04h, 0Eh, 04h, 00h, 00h
      db 00h, 00h, 04h, 0Eh, 06h, 04h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 04h, 04h, 06h, 04h, 00h, 00h
      db 00h, 00h, 04h, 0Eh, 06h, 06h, 04h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 04h, 04h, 06h, 04h, 00h, 00h, 00h
      db 00h, 00h, 00h, 04h, 04h, 06h, 06h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 04h, 06h, 04h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 04h, 06h, 06h, 06h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Fh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Fh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Fh, 0Eh, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Fh, 0Fh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 06h, 06h, 06h, 06h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
      db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

.code
drawTitle macro X, Y, W, H, C
    mov xlocRec, X
    mov ylocRec, Y
    mov widRec, W
    mov heightRec, H
    mov color, C
    call AddRec
endm

redrawBall macro newColor
    ;---moves the specified newColor to color that will be used to draw the ball---
	mov color, newColor
    call drawball
endm

redrawStriker macro newColor
	;---moves the specified newColor to color that will be used to draw the striker---
	mov color, newColor
	call drawStriker
endm

BuildKey macro X, Y, W, H 
local drawKey 
	push ax
    push bx
    push cx
    push dx
	
	mov cx, X                             ;moves the X argument to cx (x-loc of the bmp) 
	mov dx, Y                             ;moves the Y argument to cx (y-loc of the bmp) 
	
	drawKey:
		mov ah, 0Ch                       ;draw pixel instruction 
		mov al, [si]                      ;sets al to the color of the pixel on the specified source index of the offset
		mov bh, 00h                       ;sets the page number 
		int 10h
		
		inc si                            ;increments the si pointer 
		inc cx                            ;moves to the next position (to the right) 
		mov ax, cx                        ;moves the current x-loc to the si pointer 
		sub ax, X                         ;subtracts the value of X from the value of ax (0 at first) 
		cmp ax, W                         ;checks if the value of ax is equal to the value of W
		jne drawKey                       ;if not, loop drawKey to keep drawing the pixels until the end of the row
		
		mov cx, X                         ;if yes, set cx to the specified x-loc 
		inc dx                            ;increments dx, moves to the next line/row  
		mov ax, dx                        ;moves the current y-loc to the si pointer 
		sub ax, Y                         ;subtracts the value of Y from the value of ax (0 at first) 
		cmp ax, H                         ;checks if the value of ax is equal to the value of H 
		jne drawKey                       ;if not, loop drawKey 
		
	pop dx
    pop cx
    pop bx
    pop ax
endm 

BuildBrick macro X, Y, C
    push ax
    push bx
	
	;---moves the arguments to the specified variables that will be used in AddBrick---
    mov ax, X                          
    mov bx, Y                       
	mov color, C
    call AddBrick
	
    pop bx
    pop ax
endm

BrickCollision macro X, Y
local check, done1
    push ax
    push bx
    push cx
    push dx

    mov ax, X                             ;sets ax to the value of X 
	add ax, 36                            ;adds 36 (width of brick) to ax
	cmp ax, ballX                         ;checks if ax is equal to the x-loc of the ball 
	jng check                             ;if ax is less than, jump to check 
	
	mov ax, ballX                         ;moves ballX to ax 
	add ax, 4                             ;adds 4 (ball's width) to ax 
	cmp X, ax                             ;checks if brick's x-loc is equal to ax 
	jnl check                             ;if X is greater than, jump to check
	
	mov ax, Y                             ;sets ax to the value of Y                              
	add ax, 7                             ;adds 7 (height of brick) to ax 
	cmp ax, ballY                         ;checks if ax is equal to the x-loc of the ball 
	jng check                             ;if ax is less than, jump to check 
	
	mov ax, ballY                         ;moves ballY to ax 
	add ax, 4                             ;adds 4 (ball's height) to ax
	cmp Y, ax                             ;checks if brick's y-loc is equal to ax 
	jnl check                             ;if Y is greater than, jump to check 
	
    call switcher                         ;if ball hits a brick, change ball direction
    DestroyBrick X, Y                     ;destroys brick located at the X and Y coordinates 
    mov Y, 300                            ;moves the brick out of the way
    cmp scoreCount, 10                    ;checks if all the bricks are destroyed
    jne check                             ;if not, jump to check 
	
	mov begin, 0                          ;if all bricks are destroyed, set begin to 0
	redrawball 0                          ;removes ball 
	redrawStriker 0                       ;removes striker 
	call GameCompletedPage                ;calls the game completed page 
    
    check:
    pop dx
    pop cx
    pop bx
    pop ax                      
endm

DestroyBrick macro  X, Y
local drawscore1, noSound
    push ax
    push bx
	
    mov ax, X                             ;sets ax to the value of X 
    mov bx, Y                             ;sets bx to the value of Y 
    call RemoveBrick                      ;removes brick located at the X and Y coordinates 
	
	cmp soundOn, 1                        ;checks if sound is enabled 
	jne noSound                           ;if not, jump to noSound 
    call beep                             ;if enabled, create a beep sound 
	
	noSound:
		inc scoreCount                    ;increments scoreCount 
	
	drawscore1:
    pop bx
    pop ax
endm




main proc
    mov ax,@data                          ;incorporates the data values
    mov ds,ax			        
	
	call setVideoMode 
	call PrintOpeningPage                 ;prints opening screen
main endp


; ----------------------------------------
;         Title Page
; ----------------------------------------
OpenFile proc
	push bp
	mov bp, sp
	mov ah, 3Dh
	mov al, 2
	mov dx, [bp + 6]
	int 21h
	mov bx, [bp + 4]
	mov [bx], ax
	mov ax, 1
	pop bp
	ret
OpenFile endp

CloseFile proc
	push bp
	mov bp, sp
	mov ah, 3Eh
	mov bx, [bp + 4]
	int 21h
	pop bp
	ret
CloseFile endp

PrintFullScreenBMP proc
	push bp
	mov bp, sp
	mov ah, 42h
	xor al, al
	mov bx, [bp + 6]
	xor cx, cx
	mov dx, 1077 ; BMP header offset for pixel data (can vary)
	int 21h
	mov ax, 0A000h
	mov es, ax
	mov di, 0F8BFh ; Start drawing from bottom-left for standard BMP
	cld
	mov cx, 200
readLine:
	push cx
	mov ah, 3Fh
	mov cx, 320
	mov dx, [bp + 4] ; FileReadBuffer
	int 21h
	mov si, dx
	mov cx, 320
	rep movsb
	sub di, 640 ; Move to line above and reset to left
	pop cx
	loop readLine
	pop bp
	ret
PrintFullScreenBMP endp

PrintOpeningPage proc
	call setVideoMode ; Clear screen and set video mode
	call drawBorder
	call drawBg
	
	; Draw Letter B1
	drawTitle 110, 38, 2, 3, 1
	drawTitle 102, 32, 3, 3, 1
	drawTitle 102, 18, 3, 4, 1
	drawTitle 93, 22, 11, 3, 1
	drawTitle 90, 29, 3, 6, 1
	drawTitle 90, 18, 3, 7, 1
	drawTitle 90, 35, 15, 3, 1
	drawTitle 93, 29, 11, 3, 1
	drawTitle 90, 15, 15, 3, 1
	drawTitle 110, 29, 2, 2, 1
	drawTitle 110, 23, 2, 2, 1
	drawTitle 105, 25, 2, 3, 1
	drawTitle 107, 23, 2, 6, 1
	drawTitle 108, 14, 1, 1, 1
	drawTitle 107, 12, 1, 3, 1
	drawTitle 106, 11, 1, 2, 1
	drawTitle 109, 14, 1, 25, 1
	drawTitle 107, 43, 1, 2, 1
	drawTitle 107, 39, 3, 4, 1
	drawTitle 105, 41, 2, 4, 1
	drawTitle 83, 42, 22, 3, 1
	drawTitle 86, 10, 21, 1, 1
	drawTitle 85, 10, 1, 32, 1
	drawTitle 90, 25, 15, 4, 10
	drawTitle 85, 8, 23, 2, 10
	drawTitle 90, 11, 15, 4, 10
	drawTitle 107, 29, 2, 10, 10
	drawTitle 107, 15, 2, 8, 10
	drawTitle 110, 31, 2, 7, 10
	drawTitle 110, 12, 2, 11, 10
	drawTitle 108, 10, 2, 4, 10
	drawTitle 107, 10, 1, 2, 10
	drawTitle 105, 11, 1, 2, 10
	drawTitle 104, 29, 1, 3, 10
	drawTitle 104, 22, 1, 3, 10
	drawTitle 105, 13, 2, 12, 10
	drawTitle 105, 28, 2, 13, 10
	drawTitle 90, 38, 15, 4, 10
	drawTitle 86, 11, 4, 31, 10
	drawTitle 83, 8, 2, 34, 10

	; Draw Letter L
	drawTitle 116, 42, 22, 3, 1
	drawTitle 138, 38, 2, 7, 1
	drawTitle 126, 36, 14, 2, 1
	drawTitle 124, 35, 2, 3, 1
	drawTitle 119, 10, 4, 1, 1
	drawTitle 123, 10, 1, 28, 1
	drawTitle 118, 10, 1, 32, 1
	drawTitle 123, 38, 15, 4, 10
	drawTitle 119, 11, 4, 31, 10
	drawTitle 118, 8, 6, 2, 10
	drawTitle 124, 8, 2, 27, 10
	drawTitle 116, 8, 2, 34, 10

	; Draw Letter O
	drawTitle 151, 42, 15, 3, 1
	drawTitle 166, 41, 3, 4, 1
	drawTitle 148, 41, 3, 4, 1
	drawTitle 171, 38, 3, 3, 1
	drawTitle 146, 41, 2, 2, 1
	drawTitle 169, 41, 2, 2, 1
	drawTitle 168, 38, 3, 3, 1
	drawTitle 146, 38, 3, 3, 1
	drawTitle 171, 14, 1, 24, 1
	drawTitle 145, 16, 1, 24, 1
	drawTitle 168, 14, 3, 2, 1
	drawTitle 149, 10, 19, 2, 1
	drawTitle 168, 12, 2, 2, 1
	drawTitle 166, 12, 2, 1, 1
	drawTitle 148, 12, 2, 1, 1
	drawTitle 147, 12, 1, 2, 1
	drawTitle 145, 14, 3, 2, 1
	drawTitle 172, 14, 2, 24, 10
	drawTitle 170, 12, 4, 2, 10
	drawTitle 168, 10, 4, 2, 10
	drawTitle 143, 14, 2, 26, 10
	drawTitle 143, 12, 4, 2, 10
	drawTitle 145, 10, 4, 2, 10
	drawTitle 166, 13, 2, 3, 10
	drawTitle 165, 16, 6, 22, 10
	drawTitle 146, 16, 6, 22, 10
	drawTitle 166, 38, 2, 3, 10
	drawTitle 149, 38, 2, 3, 10
	drawTitle 148, 13, 2, 3, 10
	drawTitle 151, 38, 15, 4, 10
	drawTitle 150, 12, 16, 4, 10
	drawTitle 148, 8, 21, 2, 10

	; Draw Letter C
	drawTitle 199, 14, 2, 1, 1
	drawTitle 197, 12, 2, 1, 1
	drawTitle 184, 42, 12, 3, 1
	drawTitle 196, 41, 3, 4, 1
	drawTitle 184, 15, 3, 21, 1
	drawTitle 194, 18, 9, 2, 1
	drawTitle 187, 15, 9, 3, 1
	drawTitle 184, 36, 13, 2, 1
	drawTitle 196, 34, 5, 2, 1
	drawTitle 201, 36, 2, 4, 1
	drawTitle 199, 38, 2, 5, 1
	drawTitle 182, 41, 2, 4, 1
	drawTitle 179, 38, 3, 5, 1
	drawTitle 179, 14, 2, 1, 1
	drawTitle 181, 12, 2, 1, 1
	drawTitle 196, 11, 1, 2, 1
	drawTitle 200, 15, 1, 3, 1
	drawTitle 198, 13, 1, 2, 1
	drawTitle 179, 15, 1, 23, 1
	drawTitle 181, 13, 1, 2, 1
	drawTitle 183, 11, 1, 2, 1
	drawTitle 183, 10, 14, 1, 1
	drawTitle 182, 13, 2, 28, 10
	drawTitle 184, 11, 12, 4, 10
	drawTitle 194, 32, 9, 2, 10
	drawTitle 183, 8, 15, 2, 10
	drawTitle 201, 12, 2, 6, 10
	drawTitle 184, 38, 12, 4, 10
	drawTitle 196, 38, 3, 3, 10
	drawTitle 197, 36, 4, 2, 10
	drawTitle 201, 34, 2, 2, 10
	drawTitle 194, 34, 2, 2, 10
	drawTitle 199, 12, 2, 2, 10
	drawTitle 197, 10, 4, 2, 10
	drawTitle 198, 15, 2, 3, 10
	drawTitle 196, 13, 2, 5, 10
	drawTitle 181, 8, 2, 4, 10
	drawTitle 179, 10, 2, 4, 10
	drawTitle 180, 15, 2, 23, 10
	drawTitle 177, 13, 2, 27, 10

	; Draw Letter K
	drawTitle 209, 10, 4, 1, 1
	drawTitle 231, 11, 1, 2, 1
	drawTitle 229, 10, 3, 1, 1
	drawTitle 227, 10, 2, 3, 1
	drawTitle 227, 43, 5, 2, 1
	drawTitle 230, 42, 2, 1, 1
	drawTitle 228, 41, 2, 2, 1
	drawTitle 226, 39, 2, 4, 1
	drawTitle 224, 37, 2, 4, 1
	drawTitle 222, 35, 2, 4, 1
	drawTitle 220, 33, 2, 3, 1
	drawTitle 218, 31, 2, 3, 1
	drawTitle 216, 29, 2, 2, 1
	drawTitle 213, 29, 2, 13, 1
	drawTitle 206, 42, 10, 3, 1
	drawTitle 232, 39, 3, 6, 1
	drawTitle 232, 38, 1, 1, 1
	drawTitle 230, 36, 1, 2, 1
	drawTitle 228, 34, 1, 2, 1
	drawTitle 226, 32, 1, 2, 1
	drawTitle 231, 37, 2, 1, 1
	drawTitle 229, 35, 2, 1, 1
	drawTitle 227, 33, 2, 1, 1
	drawTitle 225, 31, 2, 1, 1
	drawTitle 224, 29, 1, 3, 1
	drawTitle 222, 28, 2, 2, 1
	drawTitle 221, 25, 2, 3, 1
	drawTitle 220, 24, 1, 4, 1
	drawTitle 221, 23, 4, 2, 1
	drawTitle 223, 21, 4, 2, 1
	drawTitle 225, 19, 4, 2, 1
	drawTitle 227, 17, 4, 2, 1
	drawTitle 229, 15, 3, 2, 1
	drawTitle 231, 13, 3, 2, 1
	drawTitle 225, 12, 2, 3, 1
	drawTitle 223, 14, 2, 3, 1
	drawTitle 221, 15, 2, 4, 1
	drawTitle 219, 18, 2, 1, 1
	drawTitle 218, 19, 3, 2, 1
	drawTitle 216, 21, 3, 3, 1
	drawTitle 214, 23, 2, 1, 1
	drawTitle 213, 10, 1, 14, 1
	drawTitle 208, 10, 1, 32, 1
	drawTitle 225, 8, 9, 2, 10
	drawTitle 220, 31, 2, 2, 10
	drawTitle 230, 38, 2, 4, 10
	drawTitle 228, 36, 2, 5, 10
	drawTitle 226, 34, 2, 5, 10
	drawTitle 224, 32, 2, 5, 10
	drawTitle 233, 37, 2, 2, 10
	drawTitle 231, 35, 2, 2, 10
	drawTitle 229, 33, 2, 2, 10
	drawTitle 227, 31, 2, 2, 10
	drawTitle 225, 29, 2, 2, 10
	drawTitle 223, 25, 1, 3, 10
	drawTitle 224, 27, 2, 2, 10
	drawTitle 222, 30, 2, 5, 10
	drawTitle 232, 10, 2, 3, 10
	drawTitle 225, 10, 2, 2, 10
	drawTitle 223, 10, 2, 2, 10
	drawTitle 223, 12, 2, 2, 10
	drawTitle 221, 13, 2, 2, 10
	drawTitle 219, 14, 2, 2, 10
	drawTitle 219, 16, 2, 2, 10
	drawTitle 217, 17, 2, 2, 10
	drawTitle 216, 19, 2, 2, 10
	drawTitle 229, 11, 2, 4, 10
	drawTitle 227, 13, 2, 4, 10
	drawTitle 225, 15, 2, 4, 10
	drawTitle 223, 17, 2, 4, 10
	drawTitle 221, 19, 2, 4, 10
	drawTitle 219, 21, 2, 3, 10
	drawTitle 218, 24, 2, 4, 10
	drawTitle 218, 28, 4, 3, 10
	drawTitle 213, 24, 5, 5, 10
	drawTitle 209, 11, 4, 31, 10
	drawTitle 214, 8, 2, 15, 10
	drawTitle 208, 8, 6, 2, 10
	drawTitle 206, 8, 2, 34, 10

	; Draw Letter B2
	drawTitle 98, 80, 2, 3, 1
	drawTitle 90, 74, 3, 3, 1
	drawTitle 90, 60, 3, 4, 1
	drawTitle 81, 64, 11, 3, 1
	drawTitle 78, 71, 3, 6, 1
	drawTitle 78, 60, 3, 7, 1
	drawTitle 78, 77, 15, 3, 1
	drawTitle 81, 71, 11, 3, 1
	drawTitle 78, 57, 15, 3, 1
	drawTitle 98, 71, 2, 2, 1
	drawTitle 98, 65, 2, 2, 1
	drawTitle 93, 67, 2, 3, 1
	drawTitle 95, 65, 2, 6, 1
	drawTitle 96, 56, 1, 1, 1
	drawTitle 95, 54, 1, 3, 1
	drawTitle 94, 53, 1, 2, 1
	drawTitle 97, 56, 1, 25, 1
	drawTitle 95, 85, 1, 2, 1
	drawTitle 95, 81, 3, 4, 1
	drawTitle 93, 83, 2, 4, 1
	drawTitle 71, 84, 22, 3, 1
	drawTitle 74, 52, 21, 1, 1
	drawTitle 73, 52, 1, 32, 1
	drawTitle 78, 67, 15, 4, 10
	drawTitle 73, 50, 23, 2, 10
	drawTitle 78, 53, 15, 4, 10
	drawTitle 95, 71, 2, 10, 10
	drawTitle 95, 57, 2, 8, 10
	drawTitle 98, 73, 2, 7, 10
	drawTitle 98, 54, 2, 11, 10
	drawTitle 96, 52, 2, 4, 10
	drawTitle 95, 52, 1, 2, 10
	drawTitle 93, 53, 1, 2, 10
	drawTitle 92, 71, 1, 3, 10
	drawTitle 92, 64, 1, 3, 10
	drawTitle 93, 55, 2, 12, 10
	drawTitle 93, 70, 2, 13, 10
	drawTitle 78, 80, 15, 4, 10
	drawTitle 74, 53, 4, 31, 10
	drawTitle 71, 50, 2, 34, 10

	; Draw Letter U
	drawTitle 127, 80, 4, 2, 1
	drawTitle 124, 82, 5, 2, 1
	drawTitle 103, 80, 5, 2, 1
	drawTitle 105, 82, 5, 2, 1
	drawTitle 107, 84, 20, 3, 1
	drawTitle 112, 77, 10, 3, 1
	drawTitle 123, 52, 5, 1, 1
	drawTitle 106, 52, 5, 1, 1
	drawTitle 128, 52, 1, 28, 1
	drawTitle 122, 52, 1, 28, 1
	drawTitle 111, 52, 1, 28, 1
	drawTitle 105, 52, 1, 28, 1
	drawTitle 121, 52, 1, 25, 10
	drawTitle 110, 82, 14, 2, 10
	drawTitle 108, 80, 19, 2, 10
	drawTitle 123, 53, 5, 27, 10
	drawTitle 106, 53, 5, 27, 10
	drawTitle 112, 52, 1, 25, 10
	drawTitle 121, 50, 8, 2, 10
	drawTitle 105, 50, 8, 2, 10
	drawTitle 129, 50, 2, 30, 10
	drawTitle 103, 50, 2, 30, 10

	; Draw Letter S
	drawTitle 141, 59, 3, 7, 1
	drawTitle 136, 56, 1, 10, 1
	drawTitle 158, 70, 1, 10, 1
	drawTitle 138, 84, 19, 3, 1
	drawTitle 156, 80, 5, 2, 1
	drawTitle 154, 82, 5, 2, 1
	drawTitle 137, 82, 4, 2, 1
	drawTitle 136, 78, 2, 4, 1
	drawTitle 134, 79, 2, 3, 1
	drawTitle 141, 78, 11, 2, 1
	drawTitle 157, 68, 2, 2, 1
	drawTitle 152, 73, 2, 7, 1
	drawTitle 136, 77, 7, 1, 1
	drawTitle 155, 66, 2, 2, 1
	drawTitle 152, 59, 2, 3, 1
	drawTitle 144, 64, 11, 2, 1
	drawTitle 141, 57, 13, 2, 1
	drawTitle 154, 60, 4, 2, 1
	drawTitle 158, 59, 3, 3, 1
	drawTitle 156, 54, 2, 3, 1
	drawTitle 158, 56, 1, 3, 1
	drawTitle 155, 53, 1, 2, 1
	drawTitle 141, 52, 15, 1, 1
	drawTitle 139, 52, 2, 2, 1
	drawTitle 136, 68, 5, 2, 1
	drawTitle 138, 70, 16, 3, 1
	drawTitle 134, 66, 5, 2, 1
	drawTitle 137, 56, 1, 1, 1
	drawTitle 138, 54, 3, 1, 1
	drawTitle 141, 66, 14, 4, 10
	drawTitle 154, 57, 4, 3, 10
	drawTitle 154, 70, 4, 10, 10
	drawTitle 136, 75, 7, 2, 10
	drawTitle 141, 80, 13, 4, 10
	drawTitle 159, 68, 2, 12, 10
	drawTitle 157, 66, 2, 2, 10
	drawTitle 155, 64, 2, 2, 10
	drawTitle 155, 68, 2, 2, 10
	drawTitle 154, 80, 2, 2, 10
	drawTitle 138, 78, 3, 4, 10
	drawTitle 134, 75, 2, 4, 10
	drawTitle 139, 66, 2, 2, 10
	drawTitle 155, 55, 1, 2, 10
	drawTitle 138, 55, 3, 2, 10
	drawTitle 141, 53, 14, 4, 10
	drawTitle 137, 57, 4, 9, 10
	drawTitle 159, 54, 2, 5, 10
	drawTitle 158, 53, 1, 3, 10
	drawTitle 156, 52, 2, 2, 10
	drawTitle 134, 56, 2, 10, 10
	drawTitle 134, 54, 4, 2, 10
	drawTitle 135, 52, 4, 2, 10
	drawTitle 138, 50, 20, 2, 10

	; Draw Letter T
	drawTitle 187, 53, 1, 2, 1
	drawTitle 187, 55, 3, 4, 1
	drawTitle 179, 57, 8, 2, 1
	drawTitle 167, 57, 8, 2, 1
	drawTitle 172, 84, 10, 3, 1
	drawTitle 179, 59, 3, 25, 1
	drawTitle 172, 59, 3, 25, 1
	drawTitle 164, 55, 3, 4, 1
	drawTitle 166, 53, 1, 2, 1
	drawTitle 166, 52, 22, 1, 1
	drawTitle 175, 57, 4, 27, 10
	drawTitle 167, 53, 20, 4, 10
	drawTitle 166, 50, 22, 2, 10
	drawTitle 188, 50, 2, 5, 10
	drawTitle 164, 50, 2, 5, 10

	; Draw Letter E
	drawTitle 196, 52, 20, 1, 1
	drawTitle 204, 78, 14, 2, 1
	drawTitle 201, 70, 14, 2, 1
	drawTitle 204, 64, 11, 2, 1
	drawTitle 193, 84, 25, 2, 1
	drawTitle 201, 57, 14, 2, 1
	drawTitle 201, 59, 3, 7, 1
	drawTitle 201, 72, 3, 8, 1
	drawTitle 212, 66, 3, 4, 1
	drawTitle 215, 80, 3, 4, 1
	drawTitle 215, 55, 3, 4, 1
	drawTitle 215, 53, 1, 2, 1
	drawTitle 195, 52, 1, 32, 1
	drawTitle 195, 50, 23, 2, 10
	drawTitle 196, 80, 19, 4, 10
	drawTitle 196, 66, 16, 4, 10
	drawTitle 196, 70, 5, 10, 10
	drawTitle 196, 57, 5, 9, 10
	drawTitle 196, 53, 19, 4, 10
	drawTitle 216, 52, 2, 3, 10
	drawTitle 193, 50, 2, 34, 10

	; Draw Letter R
	drawTitle 244, 56, 3, 1, 1
	drawTitle 242, 54, 2, 1, 1
	drawTitle 246, 76, 1, 8, 1
	drawTitle 221, 84, 10, 2, 1
	drawTitle 239, 84, 10, 2, 1
	drawTitle 239, 60, 2, 6, 1
	drawTitle 231, 66, 9, 2, 1
	drawTitle 231, 57, 10, 3, 1
	drawTitle 228, 57, 3, 11, 1
	drawTitle 239, 74, 2, 10, 1
	drawTitle 231, 72, 8, 3, 1
	drawTitle 246, 74, 3, 2, 1
	drawTitle 228, 72, 3, 12, 1
	drawTitle 243, 72, 3, 2, 1
	drawTitle 240, 70, 4, 2, 1
	drawTitle 240, 69, 6, 1, 1
	drawTitle 243, 66, 6, 3, 1
	drawTitle 246, 57, 1, 9, 1
	drawTitle 243, 55, 1, 2, 1
	drawTitle 241, 53, 1, 2, 1
	drawTitle 224, 52, 18, 1, 1
	drawTitle 223, 52, 1, 32, 1
	drawTitle 247, 55, 2, 11, 10
	drawTitle 228, 53, 13, 4, 10
	drawTitle 241, 57, 5, 9, 10
	drawTitle 228, 68, 12, 4, 10
	drawTitle 241, 74, 5, 10, 10
	drawTitle 247, 76, 2, 8, 10
	drawTitle 240, 72, 3, 2, 10
	drawTitle 239, 72, 1, 2, 10
	drawTitle 240, 66, 3, 3, 10
	drawTitle 241, 55, 2, 2, 10
	drawTitle 244, 54, 3, 2, 10
	drawTitle 242, 52, 5, 2, 10
	drawTitle 223, 50, 21, 2, 10
	drawTitle 224, 53, 4, 31, 10
	drawTitle 221, 50, 2, 34, 10

	; “Draw Letter P” - PRESS [P] TO PLAY
	drawTitle 120, 147, 1, 2, 15
	drawTitle 117, 149, 3, 1, 15
	drawTitle 117, 146, 3, 1, 15
	drawTitle 116, 146, 1, 7, 15
	; “Draw Letter R”
	drawTitle 125, 148, 1, 1, 15
	drawTitle 124, 149, 1, 1, 15
	drawTitle 123, 148, 1, 5, 15
	; “Draw Letter E”
	drawTitle 129, 152, 3, 1, 15
	drawTitle 129, 150, 2, 1, 15
	drawTitle 131, 149, 1, 2, 15
	drawTitle 129, 148, 2, 1, 15
	drawTitle 128, 149, 1, 3, 15
	; “Draw Letter S”
	drawTitle 133, 152, 4, 1, 15
	drawTitle 136, 151, 2, 1, 15
	drawTitle 134, 150, 3, 1, 15
	drawTitle 133, 149, 2, 1, 15
	drawTitle 134, 148, 4, 1, 15
	; “Draw Letter S”
	drawTitle 139, 152, 4, 1, 15
	drawTitle 142, 151, 2, 1, 15
	drawTitle 140, 150, 3, 1, 15
	drawTitle 139, 149, 2, 1, 15
	drawTitle 140, 148, 4, 1, 15
	; “Draw Left Bracket”
	drawTitle 149, 147, 1, 7, 15
	drawTitle 149, 154, 2, 1, 15
	drawTitle 149, 146, 2, 1, 15
	; “Draw Letter P”
	drawTitle 157, 147, 1, 2, 15
	drawTitle 154, 149, 3, 1, 15
	drawTitle 154, 146, 3, 1, 15
	drawTitle 153, 146, 1, 7, 15
	; “Draw Right Bracket”
	drawTitle 162, 147, 1, 7, 15
	drawTitle 162, 154, 2, 1, 15
	drawTitle 162, 146, 2, 1, 15
	; “Draw Letter T”
	drawTitle 169, 148, 2, 1, 15
	drawTitle 166, 148, 2, 1, 15
	drawTitle 168, 152, 2, 1, 15
	drawTitle 168, 146, 1, 6, 15
	; “Draw Letter O”
	drawTitle 174, 149, 1, 3, 15
	drawTitle 172, 149, 1, 3, 15
	drawTitle 172, 152, 3, 1, 15
	drawTitle 172, 148, 3, 1, 15
	; “Draw Letter P”
	drawTitle 185, 147, 1, 2, 15
	drawTitle 182, 149, 3, 1, 15
	drawTitle 182, 146, 3, 1, 15
	drawTitle 181, 146, 1, 7, 15
	; “Draw Letter L”
	drawTitle 188, 146, 1, 7, 15
	; “Draw Letter A”
	drawTitle 194, 148, 1, 5, 15
	drawTitle 191, 152, 3, 1, 15
	drawTitle 191, 150, 1, 2, 15
	drawTitle 191, 149, 3, 1, 15
	; “Draw Letter Y”
	drawTitle 198, 151, 1, 3, 15
	drawTitle 199, 149, 1, 2, 15
	drawTitle 197, 149, 1, 2, 15
	drawTitle 200, 148, 1, 1, 15
	drawTitle 197, 153, 1, 1, 15
	drawTitle 196, 148, 1, 1, 15

	; “Draw Letter P” - PRESS [C] TO VIEW CONTROLS
	drawTitle 88, 167, 1, 2, 15
	drawTitle 85, 169, 3, 1, 15
	drawTitle 85, 166, 3, 1, 15
	drawTitle 84, 166, 1, 7, 15
	; “Draw Letter R”
	drawTitle 93, 168, 1, 1, 15
	drawTitle 92, 169, 1, 1, 15
	drawTitle 91, 168, 1, 5, 15
	; “Draw Letter E”
	drawTitle 97, 172, 3, 1, 15
	drawTitle 97, 170, 2, 1, 15
	drawTitle 99, 169, 1, 2, 15
	drawTitle 97, 168, 2, 1, 15
	drawTitle 96, 169, 1, 3, 15
	; “Draw Letter S”
	drawTitle 101, 172, 4, 1, 15
	drawTitle 104, 171, 2, 1, 15
	drawTitle 102, 170, 3, 1, 15
	drawTitle 101, 169, 2, 1, 15 ; Corrected Y from 199
	drawTitle 102, 168, 4, 1, 15
	; “Draw Letter S”
	drawTitle 107, 172, 4, 1, 15
	drawTitle 110, 171, 2, 1, 15
	drawTitle 108, 170, 3, 1, 15
	drawTitle 107, 169, 2, 1, 15
	drawTitle 108, 168, 4, 1, 15
	; “Draw Left Bracket”
	drawTitle 117, 167, 1, 7, 15
	drawTitle 117, 174, 2, 1, 15
	drawTitle 117, 166, 2, 1, 15
	; “Draw Letter C”
	drawTitle 122, 172, 3, 1, 15       ; A
	drawTitle 121, 167, 1, 5, 15       ; A
	drawTitle 122, 166, 3, 1, 15       ; A
	drawTitle 125, 171, 1, 1, 15       ; A
	drawTitle 125, 167, 1, 1, 15       ; A
	; “Draw Right Bracket”
	drawTitle 130, 167, 1, 7, 15
	drawTitle 130, 174, 2, 1, 15
	drawTitle 130, 166, 2, 1, 15
	; “Draw Letter T”
	drawTitle 137, 168, 2, 1, 15
	drawTitle 134, 168, 2, 1, 15
	drawTitle 136, 172, 2, 1, 15
	drawTitle 136, 166, 1, 6, 15
	; “Draw Letter O”
	drawTitle 142, 169, 1, 3, 15
	drawTitle 140, 169, 1, 3, 15
	drawTitle 140, 172, 3, 1, 15
	drawTitle 140, 168, 3, 1, 15
	; “Draw Letter V”
	drawTitle 151, 171, 1, 2, 15
	drawTitle 152, 169, 1, 2, 15
	drawTitle 150, 169, 1, 2, 15
	drawTitle 153, 166, 1, 3, 15
	drawTitle 149, 166, 1, 3, 15
	; “Draw Letter I”
	drawTitle 156, 166, 1, 1, 15
	drawTitle 156, 168, 1, 5, 15
	; “Draw Letter E”
	drawTitle 160, 172, 3, 1, 15
	drawTitle 160, 170, 2, 1, 15
	drawTitle 162, 169, 1, 2, 15
	drawTitle 160, 168, 2, 1, 15
	drawTitle 159, 169, 1, 3, 15
	; “Draw Letter W”
	drawTitle 166, 171, 1, 2, 15
	drawTitle 168, 171, 1, 2, 15
	drawTitle 169, 169, 1, 2, 15
	drawTitle 165, 169, 1, 2, 15
	drawTitle 167, 168, 1, 3, 15
	drawTitle 170, 168, 1, 1, 15
	drawTitle 164, 168, 1, 1, 15
	; “Draw Letter C” - CONTROLS
	drawTitle 177, 172, 3, 1, 15       ; A
	drawTitle 176, 167, 1, 5, 15       ; A
	drawTitle 177, 166, 3, 1, 15       ; A
	drawTitle 180, 171, 1, 1, 15       ; A
	drawTitle 180, 167, 1, 1, 15       ; A
	; “Draw Letter O”
	drawTitle 185, 169, 1, 3, 15
	drawTitle 183, 169, 1, 3, 15
	drawTitle 183, 172, 3, 1, 15
	drawTitle 183, 168, 3, 1, 15
	; “Draw Letter N”
	drawTitle 189, 168, 2, 1, 15
	drawTitle 191, 169, 1, 4, 15
	drawTitle 188, 168, 1, 5, 15
	; “Draw Letter T”
	drawTitle 195, 168, 2, 1, 15
	drawTitle 192, 168, 2, 1, 15
	drawTitle 194, 172, 2, 1, 15
	drawTitle 194, 166, 1, 6, 15
	; “Draw Letter R”
	drawTitle 200, 168, 1, 1, 15
	drawTitle 199, 169, 1, 1, 15
	drawTitle 198, 168, 1, 5, 15
	; “Draw Letter O”
	drawTitle 205, 169, 1, 3, 15
	drawTitle 203, 169, 1, 3, 15
	drawTitle 203, 172, 3, 1, 15
	drawTitle 203, 168, 3, 1, 15
	; “Draw Letter L”
	drawTitle 209, 166, 1, 7, 15
	; “Draw Letter S”
	drawTitle 211, 172, 4, 1, 15
	drawTitle 214, 171, 2, 1, 15
	drawTitle 212, 170, 3, 1, 15
	drawTitle 211, 169, 2, 1, 15
	drawTitle 212, 168, 4, 1, 15
	; --- END NEW TITLE DESIGN ---


	; Commented out original bitmap loading
	; printOpening:
	;	push offset OpeningFileName
	;	push offset OpeningFileHandle
	;	call OpenFile
	;	push [OpeningFileHandle]
	;	push offset FileReadBuffer
	;	call PrintFullScreenBMP
	;	push [OpeningFileHandle]
	;	call CloseFile

getKeyOpening:
	mov ah, 0h ; Check keyboard input
	int 16h
	cmp ah, 19h ; Check if P is pressed
	je procEndOpening
	cmp ah, 2Eh ; Check if C is pressed
	je procEndOpening1
	jmp getKeyOpening ; If not, loop to getKeyOpening until P or C is pressed

procEndOpening:
	call addName ; Calls the next screen where players will input their name
	ret

procEndOpening1:
	call StartPage ; Calls the controls page
	ret
PrintOpeningPage endp


; ----------------------------------------
;             Controls Page 
; ----------------------------------------
drawControl proc
	mov ah, 02h                           ;set cursor position instruction 
	mov bh, 00h                           ;sets the page number 
	mov dh, 31h                           ;sets the y-location (row position)
	mov dl, 09h                           ;sets the x-location (column position)
	int 10h
	
	mov ah, 09h                           ;output string instruction 
	lea dx, controlB_text                 ;loads the address of the string to be printed
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 03h
	mov dl, 06h
	int 10h
	
	mov ah, 09h
	lea dx, control1_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 09h
	int 10h
	
	mov ah, 09h
	lea dx, controlU_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 03h
	mov dl, 17h
	int 10h
	
	mov ah, 09h
	lea dx, control2_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 1Bh
	int 10h
	
	mov ah, 09h
	lea dx, controlU_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 2Ch
	mov dl, 0Eh
	int 10h
	
	mov ah, 09h
	lea dx, control3_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 2Dh
	mov dl, 0Eh
	int 10h
	
	mov ah, 09h
	lea dx, controlU_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 19h
	int 10h
	
	mov ah, 09h
	lea dx, controlL_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 19h
	int 10h
	
	mov ah, 09h
	lea dx, controlT_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 18h
	int 10h
	
	mov ah, 09h
	lea dx, controlO_text
	int 21h
	
	mov si, offset down_key               ;loads the memory address of the bitmap variable to the source index 
	BuildKey 257, 81, 25, 28              ;calls BuildKey macro to print the bitmap (257 -> x-loc of first pixel, 81 -> y-loc, 25 -> width of image, 28 -> height of image)
	
	mov si, offset up_key
	BuildKey 257, 51, 25, 28
	
	mov si, offset enter_key
	BuildKey 235, 125, 51, 41
	
	mov si, offset left_key
	BuildKey 59, 57, 28, 25
	
	mov si, offset right_key
	BuildKey 89, 57, 28, 25
	
	ret 
drawControl endp


; ----------------------------------------
;                  Name
; ----------------------------------------


drawName proc
	drawTitle 80, 49, 4, 20, 0Dh      	;calls drawTitle macro to print each horizontal and vertical line of the letter E 
	drawTitle 80, 49, 12, 4, 0Dh        ;78 -> x-loc of first pixel, 49 -> y-loc, 12 -> width of line, 4 -> heigh of line, 0Dh -> color
	drawTitle 80, 57, 10, 4, 0Dh
	drawTitle 80, 65, 12, 4, 0Dh
	
	drawTitle 96, 49, 4, 20, 0Dh          ;draw N 
	drawTitle 96, 50, 13, 4, 0Dh
	drawTitle 106, 50, 4, 19, 0Dh
	
	drawTitle 113, 49, 16, 4, 0Dh         ;draw T
	drawTitle 119, 49, 4, 20, 0Dh
	
	drawTitle 134, 49, 4, 20, 0Dh         ;draw E
	drawTitle 134, 49, 12, 4, 0Dh
	drawTitle 134, 57, 10, 4, 0Dh
	drawTitle 134, 65, 12, 4, 0Dh
	
	drawTitle 149, 49, 4, 20, 0Dh         ;draw R
	drawTitle 149, 49, 14, 4, 0Dh
	drawTitle 160, 49, 4, 13, 0Dh
	drawTitle 149, 59, 15, 4, 0Dh
	drawTitle 158, 59, 4, 10, 0Dh
	
	drawTitle 174, 49, 4, 12, 0Dh         ;draw Y
	drawTitle 174, 58, 16, 4, 0Dh
	drawTitle 186, 49, 4, 12, 0Dh
	drawTitle 180, 58, 4, 11, 0Dh
	
	drawTitle 192, 49, 4, 20, 0Dh         ;draw O  
	drawTitle 192, 49, 14, 4, 0Dh
	drawTitle 203, 49, 4, 20, 0Dh
	drawTitle 192, 65, 14, 4, 0Dh
	
	drawTitle 209, 49, 4, 20, 0Dh         ;draw U 
	drawTitle 209, 65, 14, 4, 0Dh
	drawTitle 220, 49, 4, 20, 0Dh
	
	drawTitle 226, 49, 4, 20, 0Dh         ;draw R
	drawTitle 226, 49, 14, 4, 0Dh
	drawTitle 237, 49, 4, 13, 0Dh
	drawTitle 226, 59, 14, 4, 0Dh
	drawTitle 235, 59, 4, 10, 0Dh
	
	drawTitle 125, 79, 14, 4, 0Dh         ;draw N
	drawTitle 125, 79, 4, 20, 0Dh
	drawTitle 136, 79, 4, 20, 0Dh
	
	drawTitle 146, 79, 4, 20, 0Dh         ;draw A
	drawTitle 146, 79, 14, 4, 0Dh
	drawTitle 157, 79, 4, 20, 0Dh
	drawTitle 146, 88, 14, 4, 0Dh
	
	drawTitle 164, 79, 4, 20, 0Dh         ;draw M
	drawTitle 164, 79, 17, 4, 0Dh
	drawTitle 178, 79, 4, 20, 0Dh
	drawTitle 171, 79, 4, 9, 0Dh
	
	drawTitle 185, 79, 4, 20, 0Dh         ;draw E
	drawTitle 185, 79, 12, 4, 0Dh
	drawTitle 185, 87, 10, 4, 0Dh
	drawTitle 185, 95, 12, 4, 0Dh
	
	ret 
drawName endp

addName proc
    push ax
    push bx
    push cx
    push dx
    push si
    push bp
    push di

    call setVideoMode             ; Clears screen
    ;call drawBoundary
    call drawBorder
    call drawBg
    call drawName                 ; "ENTER YOUR NAME" title
    mov control, 0

    ; --- Display "Max 20 characters" message ---
    mov ah, 02h
    mov bh, 00h
    mov dh, 11h                   ; Row for message
    mov dl, 0Ch                   ; Align with input start column
    int 10h
    mov ah, 09h
    lea dx, max_chars_msg
    int 21h

    ; --- Calculate middle position for input ---
    mov ax, max_name_len          ; Get max name length
    mov cl, 2
    div cl                        ; Divide by 2 to get half length
    mov cl, al                    ; Store half length in CL
    mov al, input_start_col       ; Get starting column
    add al, cl                    ; Add half length to get middle position
    mov middle_col, al            ; Store middle position

    ; --- Display a single dash in the middle ---
    mov ah, 02h
    mov bh, 00h
    mov dh, input_start_row       ; Row position
    mov dl, middle_col            ; Middle column position
    int 10h

    mov ah, 0Eh                   ; Teletype output
    mov al, '-'                   ; Dash character
    mov bh, 00h                   ; Page 0
    mov bl, 09h                   ; Attribute (normal white on black)
    int 10h

    ; --- Initialize for input loop ---
    lea si, playername            ; Point SI to the start of the buffer
    mov bp, 0                     ; Use BP as character counter/cursor offset
    
    ; --- Reset cursor position to middle ---
    mov ah, 02h
    mov bh, 00h
    mov dh, input_start_row       ; Row position
    mov dl, middle_col            ; Middle column position
    int 10h

    ; --- Clear error message row initially ---
    call clear_error_message

get_name_loop:
    mov ah, 00h                   ; Get keystroke
    int 16h                       ; BIOS keyboard service

    ; --- Check for Enter key ---
    cmp al, 0Dh                   ; Is it Enter key?
    jz validate_name              ; Go to validation routine
    
    ; --- Check for Backspace key ---
    cmp ah, 0Eh                   ; Backspace scan code?
    jz do_backspace               ; Handle backspace
    
    ; --- Check special keys ---
    cmp ah, 4Bh                   ; Left arrow?
    jz get_name_loop
    cmp ah, 4Dh                   ; Right arrow? 
    jz get_name_loop
    cmp ah, 53h                   ; Delete key?
    jz get_name_loop
    
    ; --- Check if printable character ---
    cmp al, 20h                   ; Is ASCII >= space?
    jb get_name_loop              ; If < 20h, ignore
    cmp al, 7Eh                   ; Is ASCII <= tilde?
    ja get_name_loop              ; If > 7Eh, ignore
    
    ; --- Check if at max length ---
    cmp bp, max_name_len          ; Check against max length
    jb do_printable               ; If below max, handle character
    call show_max_length_error    ; Show error when max length reached
    jmp get_name_loop             ; Otherwise, ignore and get next

; Validate if a name was entered before proceeding
validate_name:
    cmp bp, 0                     ; Check if any characters were entered
    jnz do_finalize               ; If name entered, proceed
    
    ; Display error message for empty name
    call show_error_message
    jmp get_name_loop             ; Continue input loop

; Handle Enter key with valid name - finalize input
do_finalize:
    ; Clear any error message that might be displayed
    call clear_error_message
    jmp name_done_finalize
    
; Handle Backspace key
do_backspace:
    ; Check if at beginning
    cmp bp, 0
    jz get_name_loop              ; If at beginning, ignore
    
    ; Do backspace processing
    dec bp                        ; Decrement counter
    dec si                        ; Move buffer pointer back
    mov byte ptr [si], ' '        ; Clear character in buffer
    
    ; Call redraw routine
    call redraw_input_area
    jmp get_name_loop
    
; Handle printable character
do_printable:
    ; If first character after error, clear error message
    cmp bp, 0
    jnz skip_clear_error
    call clear_error_message      ; Clear error message when typing begins
    
skip_clear_error:
    ; Store character and advance
    mov [si], al                  ; Store character
    inc bp                        ; Increment counter
    inc si                        ; Advance pointer
    
    ; Call redraw routine
    call redraw_input_area
    jmp get_name_loop

name_done_finalize:
    ; --- Null-terminate the string ---
    mov si, offset playername     ; Point SI to start of name
    add si, bp                    ; Add length (BP) to point SI after last entered character
    mov cx, max_name_len
    sub cx, bp                    ; CX = number of remaining positions
    jcxz name_terminate           ; If 0 (length == 20), skip clearing

clear_remaining_buffer:
    mov byte ptr [si], ' '        ; Overwrite with space
    inc si
    loop clear_remaining_buffer   ; Loop CX times

name_terminate:
    ; Place terminator right after the last typed character
    mov byte ptr [si], '$'        ; Add '$' terminator

    call StartPage

    pop di
    pop bp
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
addName endp

; Subroutine to display empty name error message
show_error_message proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    ; First clear the error message area
    call clear_error_message
	
	call beep                     ; Play sound for error
    
    ; Display the error message
    mov ah, 02h                   ; Set cursor position
    mov bh, 00h                   ; Page 0
    mov dh, error_msg_row         ; Row for error message
    mov dl, 09h                   ; Column position (align with other messages)
    int 10h
    
    ; We'll use BIOS teletype to display characters in red
    lea si, name_required_msg     ; Point to error message
    
error_msg_loop:
    mov al, [si]                  ; Get character
    cmp al, '$'                   ; Check for end of string
    je error_msg_done             ; If end, we're done
    
    mov ah, 0Eh                   ; Teletype output
    mov bh, 00h                   ; Page 0
    mov bl, 04h                   ; Set color to red (04h)
    int 10h                       ; Display character in red
    
    inc si                        ; Next character
    jmp error_msg_loop            ; Continue loop
    
error_msg_done:
    ; Reset cursor back to input position
    mov ah, 02h
    mov bh, 00h
    mov dh, input_start_row
    mov dl, middle_col
    int 10h
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
show_error_message endp

; Subroutine to display max length error message
show_max_length_error proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    ; First clear the error message area
    call clear_error_message
	
	call beep                     ; Play sound for error
    
    ; Display the error message
    mov ah, 02h                   ; Set cursor position
    mov bh, 00h                   ; Page 0
    mov dh, error_msg_row         ; Row for error message
    mov dl, 07h                   ; Column position (align with other messages)
    int 10h
    
    ; Display characters in red
    lea si, max_length_msg        ; Point to error message
    
max_length_error_loop:
    mov al, [si]                  ; Get character
    cmp al, '$'                   ; Check for end of string
    je max_length_error_done      ; If end, we're done
    
    mov ah, 0Eh                   ; Teletype output
    mov bh, 00h                   ; Page 0
    mov bl, 04h                   ; Set color to red (04h)
    int 10h                       ; Display character in red
    
    inc si                        ; Next character
    jmp max_length_error_loop     ; Continue loop
    
max_length_error_done:
    ; Reset cursor back to input position
    mov ah, 02h
    mov bh, 00h
    mov dh, input_start_row
    mov dl, middle_col
    int 10h
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
show_max_length_error endp

; Subroutine to clear error message area
clear_error_message proc
    push ax
    push bx
    push cx
    push dx
    
    ; Set cursor to error message row
    mov ah, 02h
    mov bh, 00h
    mov dh, error_msg_row         ; Row for error message
    mov dl, 00h                   ; Start from column 0
    int 10h
    
    ; Clear entire row
    mov cx, 80                    ; 80 columns
    mov ah, 0Eh                   ; Teletype output
    mov al, ' '                   ; Space character
    mov bh, 00h                   ; Page 0
    
clear_error_loop:
    int 10h                       ; Output space
    loop clear_error_loop
    
    ; Reset cursor back to input position
    mov ah, 02h
    mov bh, 00h
    mov dh, input_start_row
    mov dl, middle_col
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clear_error_message endp

; Subroutine to redraw input area with centered text
redraw_input_area proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    ; First, clear the entire row
    mov ah, 02h                   ; Set cursor position
    mov bh, 00h                   ; Page 0
    mov dh, input_start_row       ; Row
    mov dl, input_start_col       ; Start column
    int 10h
    
    mov cx, max_name_len          ; Number of positions to clear
    mov ah, 0Eh                   ; Teletype output
    mov al, ' '                   ; Space character (to clear)
    mov bh, 00h                   ; Page 0
clear_spaces:
    int 10h                       ; Output space
    loop clear_spaces

    ; Check if there's any text
    cmp bp, 0                     ; Any characters entered?
    jnz draw_text                 ; If yes, draw the text
    
    ; No text, display single dash in middle
    mov ah, 02h                   ; Set cursor position
    mov bh, 00h                   ; Page 0
    mov dh, input_start_row       ; Row
    mov dl, middle_col            ; Middle column
    int 10h
    
    mov ah, 0Eh                   ; Teletype output
    mov al, '-'                   ; Dash character
    mov bh, 00h                   ; Page 0
    mov bl, 09h                   ; Normal attribute
    int 10h
    jmp redraw_exit
    
draw_text:
    ; Calculate where to start drawing text
    ; Text centered = middle - (length/2)
    mov ax, bp                    ; Get length in AX
    mov cl, 2                     ; Divisor
    div cl                        ; Divide by 2
    mov cl, al                    ; Half length in CL
    
    ; Check if odd or even length
    test bp, 1                    ; Test if odd
    jz length_is_even
    
    ; Odd length calculation
    mov al, middle_col            ; Get middle position
    sub al, cl                    ; Subtract half length
    jmp check_position
    
length_is_even:
    mov al, middle_col            ; Get middle position
    sub al, cl                    ; Subtract half length
    
check_position:
    ; Ensure we don't go below start column
    cmp al, input_start_col
    jae set_position
    mov al, input_start_col       ; Limit to start column
    
set_position:
    ; Set cursor to calculated position
    mov dl, al                    ; Column position in DL
    mov ah, 02h                   ; Set cursor position
    mov bh, 00h                   ; Page 0
    mov dh, input_start_row       ; Row
    int 10h
    
    ; Draw all characters in buffer
    lea si, playername            ; Point to name buffer
    mov cx, bp                    ; Character count
    
draw_chars:
    mov ah, 0Eh                   ; Teletype output
    mov al, [si]                  ; Get character
    mov bh, 00h                   ; Page 0
    mov bl, 09h                   ; Bright attribute
    int 10h
    inc si                        ; Next character
    loop draw_chars
    
redraw_exit:
    ; Position cursor at the end of the text for next input
    cmp bp, 0                     ; Any characters entered?
    jz reset_to_middle            ; If no, reset to middle
    
    ; Calculate cursor position after text
    mov ah, 03h                   ; Get cursor position
    mov bh, 00h                   ; Page 0
    int 10h                       ; DH=row, DL=column
    
    ; DL now contains the column after the last character
    mov ah, 02h                   ; Set cursor position
    ; BH and DH remain unchanged
    int 10h
    jmp finish_redraw
    
reset_to_middle:
    ; Reset cursor to middle position
    mov ah, 02h
    mov bh, 00h
    mov dh, input_start_row
    mov dl, middle_col
    int 10h
    
finish_redraw:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
redraw_input_area endp





printName proc
    ;---prints the name on the specified position---
    mov ah, 02h
    mov bh, 00h                   ; Page number
    mov dh, 01h                   ; Row (close to the top)
    mov dl, 01h                   ; Column (moved to the left, e.g., column 3)
    int 10h
    
    mov ah, 09h
    lea dx, playername
    int 21h
    
    ret  ; <-- Removed the invalid character after 'ret'
printName endp


; ----------------------------------------
;               Main Menu
; ----------------------------------------
StartPage proc
	call setVideoMode
	call drawBorder
	call drawBg

	cmp control, 1                        ;checks if the controls page will be printed 
	je draw_control                       ;if yes, jump to draw_control 
	
	call drawMenuText                     ;if not, print the 'MAIN MENU' text 
	call printName                        ;prints the name on the screen 
	call menu                             ;calls the menu function 
	jmp done                              ;jump to done to skip draw_control 
	
	;---if control=1, call drawTitle to print the lines on controls page--- 
	draw_control:
		drawTitle 18, 11, 285, 6, 13      
		drawTitle 18, 11, 6, 35, 13
		drawTitle 298, 11, 6, 35, 13
		drawTitle 158, 11, 6, 167, 13
		drawTitle 18, 149, 6, 28, 13
		drawTitle 298, 149, 6, 28, 13
		drawTitle 18, 173, 285, 6, 13
		drawTitle 52, 103, 31, 6, 12
		drawTitle 102, 103, 31, 6, 12
		drawTitle 64, 132, 5, 5, 15
		drawTitle 75, 150, 37, 4, 13
		
		call drawControl
		drawTitle 206, 74, 25, 0, 13
		
		get_key:
			mov ah, 00h                    
			int 16h
			cmp ah, 30h                   ;checks if B is pressed  
			jne get_key                   ;loop through get_key until B is pressed 
			call PrintOpeningPage         ;if pressed, print the title page 
	
	done:
	ret
StartPage endp

drawMenuText proc
	;---prints the "MAIN MENU" text---
	drawTitle 114, 34, 6, 23, 8           ;draw M shadow
	drawTitle 114, 34, 25, 6, 8
	drawTitle 124, 34, 6, 11, 8
	drawTitle 134, 34, 6, 23, 8
	drawTitle 113, 33, 6, 23, 13          ;draw M
	drawTitle 113, 33, 25, 6, 13
	drawTitle 123, 33, 6, 11, 13
	drawTitle 133, 33, 6, 23, 13
	
	drawTitle 145, 34, 6, 23, 8           ;draw A shadow 
	drawTitle 145, 34, 19, 6, 8
	drawTitle 159, 34, 6, 23, 8
	drawTitle 145, 45, 19, 6, 8
	drawTitle 144, 33, 6, 23, 13          ;draw A
	drawTitle 144, 33, 19, 6, 13
	drawTitle 158, 33, 6, 23, 13
	drawTitle 144, 44, 19, 6, 13
	
	drawTitle 169, 34, 21, 6, 8           ;draw I shadow
	drawTitle 177, 34, 6, 23, 8
	drawTitle 169, 51, 21, 6, 8
	drawTitle 168, 33, 21, 6, 13          ;draw I
	drawTitle 176, 33, 6, 23, 13
	drawTitle 168, 50, 21, 6, 13
	
	drawTitle 195, 34, 6, 23, 8           ;draw N shadow 
	drawTitle 195, 34, 19, 6, 8
	drawTitle 209, 34, 6, 23, 8
	drawTitle 194, 33, 6, 23, 13          ;draw N
	drawTitle 194, 33, 19, 6, 13
	drawTitle 208, 33, 6, 23, 13
	
	drawTitle 114, 65, 6, 23, 8          ;draw M shadow
	drawTitle 114, 65, 25, 6, 8
	drawTitle 124, 65, 6, 11, 8
	drawTitle 134, 65, 6, 23, 8
	drawTitle 113, 64, 6, 23, 13         ;draw M
	drawTitle 113, 64, 25, 6, 13
	drawTitle 123, 64, 6, 11, 13
	drawTitle 133, 64, 6, 23, 13
	
	drawTitle 145, 65, 6, 23, 8          ;draw E shadow 
	drawTitle 145, 65, 19, 6, 8
	drawTitle 145, 73, 13, 6, 8
	drawTitle 145, 82, 19, 6, 8
	drawTitle 144, 64, 6, 23, 13         ;draw E
	drawTitle 144, 64, 19, 6, 13
	drawTitle 144, 72, 13, 6, 13
	drawTitle 144, 81, 19, 6, 13
	
	drawTitle 170, 65, 6, 23, 8          ;draw N shadow
	drawTitle 170, 65, 19, 6, 8
	drawTitle 184, 65, 6, 23, 8
	drawTitle 169, 64, 6, 23, 13         ;draw N
	drawTitle 169, 64, 19, 6, 13
	drawTitle 183, 64, 6, 23, 13
	
	drawTitle 195, 65, 6, 23, 8         ;draw U shadow
	drawTitle 195, 82, 19, 6, 8
	drawTitle 209, 65, 6, 23, 8
	drawTitle 194, 64, 6, 23, 13        ;draw U
	drawTitle 194, 81, 19, 6, 13
	drawTitle 208, 64, 6, 23, 13
	
	ret 
drawMenuText endp 

menu proc
	;---redefine the variables---
	mov opt, 1
	mov optLevel, 1
	mov optCompleted, 1
	mov optOver, 1
	mov ballX, 158
	mov ballY, 163
	mov ballLeft, 1
	mov ballUp, 1
	mov strikerX, 140
	mov xloc, 147       ; X for underline, initially for "LEVEL MODE"
	mov yloc, 129       ; Y for underline, initially for "LEVEL MODE" (Row 0Fh)
	mov wid, 25         ; Underline width (covers "LEVEL")
	mov timeCtr, 0
	mov tens, 53        ; Ascii '5'
	mov ones, 57        ; Ascii '9'
	mov scoreCount, 0
	mov timeScore, 0
	mov lives, 3
	mov byte ptr [isPaused], 0

	;---prints the menus---
    ; Option 1: LEVEL MODE
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Fh         ; Row 15
	mov dl, 0Fh         ; Column 15
	int 10h
	mov ah, 09h
	lea dx, levelmode_text
	int 21h

    ; Option 2: TIMED MODE
	mov ah, 02h
	mov bh, 00h
	mov dh, 11h         ; Row 17 (0Fh + 2)
	mov dl, 0Fh         ; Column 15
	int 10h
	mov ah, 09h
	lea dx, timedmode_text
	int 21h

    ; Option 3: POWERPLAY MODE - NEW
	mov ah, 02h
	mov bh, 00h
	mov dh, 13h         ; Row 19 (11h + 2)
	mov dl, 10h         ; Column 14 (adjust for centering if needed)
	int 10h
	mov ah, 09h
	lea dx, powerplaymode_text ; Make sure this variable is defined in .data
	int 21h

    ; Option 4: OPTIONS
	mov ah, 02h
	mov bh, 00h
	mov dh, 15h         ; Row 21 (13h + 2)
	mov dl, 11h         ; Column 17
	int 10h
	mov ah, 09h
	lea dx, options_text
	int 21h

    ; Option 5: EXIT
	mov ah, 02h
	mov bh, 00h
	mov dh, 17h         ; Row 23 (15h + 2)
	mov dl, 12h         ; Column 18
	int 10h
	mov ah, 09h
	lea dx, exit_text
	int 21h

	call drawSelect

select:
	mov ah, 00h
	int 16h
	cmp soundOn, 1
	jne noSoundMenuInput
	call beep
noSoundMenuInput:

	cmp ax, 4800h           ; checks if up-arrow key is pressed
	je up1
	cmp ax, 5000h           ; checks if down-arrow key is pressed
	je down1
	cmp ax, 1C0Dh           ; checks if enter key is pressed
	je selected1
	jmp select              ; Loop back if no recognized key

down1:
	cmp opt, 5              ; Now 5 options total
	je back1
	add opt, 1
	call deleteSelect
	add yloc, 16
	call drawSelect
	jmp select

up1:
	cmp opt, 1
	je next1
	sub opt, 1
	call deleteSelect
	sub yloc, 16
	call drawSelect
	jmp select

back1: ; Loop from last to first
	mov opt, 1
	call deleteSelect
	mov yloc, 129           ; Y-loc for 1st option (LEVEL MODE)
	call drawSelect
	jmp select

next1: ; Loop from first to last
	mov opt, 5              ; Go to the 5th option
	call deleteSelect
	mov yloc, 193           ; Y-loc for 5th option (EXIT: 129 + 16*4)
	call drawSelect
	jmp select

selected1:
	cmp opt, 1
	je start_level
	cmp opt, 2
	je start_timed
	cmp opt, 3              ; New: PowerPlay Mode
	je start_powerplay      ; Jump to new handler
	cmp opt, 4              ; Options is now opt 4
	je go_options
	cmp opt, 5              ; Exit is now opt 5
	je terminate
	jmp select              ; Should not be reached if opt is 1-5

start_level:
	call levelMenu
	ret

start_timed:
	call timedMenu
	ret

start_powerplay:            ; Handler for PowerPlay Mode
    mov byte ptr [gamemode], 2 ; Designate gamemode 2 for PowerPlay
    call powerplayMenu      ; You'll need to create this procedure
    ret

go_options:
	call optionsPage
	; call enable ; 'enable' is likely part of optionsPage or called by it
	ret

terminate:
	call setVideoMode
	mov ah, 4Ch
	int 21h

none:
	ret
menu endp

powerplayMenu proc
    push ax
    push bx
    push cx
    push dx

    call setVideoMode
    call drawBorder
    call drawBg
    call printName

    ; Display "POWERPLAY MODE" Title
    mov ah, 02h
    mov bh, 00h
    mov dh, 04h     ; Row for title
    mov dl, 0Eh     ; Column for title (adjust for centering "POWERPLAY MODE")
    int 10h
    mov ah, 09h
    lea dx, powerplaymode_text ; Use the menu text
    int 21h

    ; --- Display Level options (same as levelMenu/timedMenu) ---
    mov ah, 02h
    mov bh, 00h
    mov dh, 08h     ; Row for Level 1
    mov dl, 10h     ; Col for Level 1
    int 10h
    mov ah, 09h
    lea dx, level1_text
    int 21h
    ; ... (Repeat for Level 2, 3, 4, 5 at dh=0Ah, 0Ch, 0Eh, 10h) ...
    mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 10h
	int 10h
	mov ah, 09h
	lea dx, level2_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 10h
	int 10h
	mov ah, 09h
	lea dx, level3_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 0Eh
	mov dl, 10h
	int 10h
	mov ah, 09h
	lea dx, level4_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 10h
	mov dl, 10h
	int 10h
	mov ah, 09h
	lea dx, level5_text
	int 21h

    ; --- Display "BACK" option ---
    mov ah, 02h
    mov bh, 00h
    mov dh, 12h     ; Row for Back
    mov dl, 11h     ; Col for Back
    int 10h
    mov ah, 09h
    lea dx, back_text
    int 21h
    ; --- End Display Level options ---

    mov optLevel, 1  ; Default to Level 1 selected
    mov xloc, 142    ; Underline X for "LEVEL 1"
    mov yloc, 73     ; Underline Y for "LEVEL 1" (text row 08h)
    mov wid, 20      ; Underline width
    call drawSelect

selectPPlayLevelLoop:
    mov ah, 00h
    int 16h
    cmp soundOn, 1
    jne noSoundPPlayLevel
    call beep
noSoundPPlayLevel:
    cmp ax, 4800h   ; Up
    je upPPlayLevel
    cmp ax, 5000h   ; Down
    je downPPlayLevel
    cmp ax, 1C0Dh   ; Enter
    je selectedPPlayLevel
    jmp selectPPlayLevelLoop

downPPlayLevel:
    cmp optLevel, 6 ; 5 levels + 1 Back option
    je firstPPlayLevel
    inc optLevel
    call deleteSelect
    add yloc, 16
    call drawSelect
    jmp selectPPlayLevelLoop
upPPlayLevel:
    cmp optLevel, 1
    je lastPPlayLevel
    dec optLevel
    call deleteSelect
    sub yloc, 16
    call drawSelect
    jmp selectPPlayLevelLoop
firstPPlayLevel: ; Loop from last to first
    mov optLevel, 1
    call deleteSelect
    mov yloc, 73    ; Y for Level 1
    call drawSelect
    jmp selectPPlayLevelLoop
lastPPlayLevel: ; Loop from first to last
    mov optLevel, 6
    call deleteSelect
    mov yloc, 153   ; Y for Back (73 + 16*5)
    call drawSelect
    jmp selectPPlayLevelLoop

selectedPPlayLevel:
    cmp optLevel, 6 ; Is "BACK" selected?
    je goBackToMainMenuFromPPlay

    ; A level (1-5) is selected
    mov byte ptr [gamemode], 2  ; Set gamemode for PowerPlay
    ; optLevel variable already holds the chosen level
    call levelmode              ; Start the game
    ret                         ; Return after game finishes

goBackToMainMenuFromPPlay:
    call StartPage ; Go back to main menu
    ret

    pop dx
    pop cx
    pop bx
    pop ax
    ret
powerplayMenu endp


; ----------------------------------------
;             Options Page
; ----------------------------------------
optionsPage proc
    call setVideoMode

	;---prints the "ENABLE SOUNDS?" text
    drawTitle 90, 36, 6, 30, 13           ;draw E
    drawTitle 96, 36, 12, 6, 13
    drawTitle 96, 48, 6, 6, 13
    drawTitle 96, 60, 12, 6, 13    
  
    drawTitle 114, 36, 6, 30, 13          ;draw N 
    drawTitle 120, 36, 6, 6, 13
    drawTitle 126, 36, 6, 30, 13

    drawTitle 138, 36, 12, 6, 13          ;draw A 
    drawTitle 150, 36, 6, 30, 13
    drawTitle 138, 48, 12, 6, 13
    drawTitle 138, 54, 6, 6, 13
    drawTitle 138, 60, 12, 6, 13

    drawTitle 162, 36, 6, 30, 13          ;draw B 
    drawTitle 168, 48, 6, 6, 13
    drawTitle 168, 60, 6, 6, 13
    drawTitle 174, 48, 6, 18, 13

    drawTitle 186, 36, 6, 30, 13          ;draw L
    drawTitle 192, 60, 12, 6, 13
   
    drawTitle 210, 36, 6, 30, 13          ;draw E  
    drawTitle 216, 36, 6, 6, 13
    drawTitle 216, 48, 6, 6, 13
    drawTitle 216, 60, 12, 6, 13
    drawTitle 222, 36, 6, 18, 13

    drawTitle 78, 72, 18, 6, 13           ;draw S 
    drawTitle 78, 84, 18, 6, 13
    drawTitle 78, 96, 18, 6, 13
    drawTitle 78, 78, 6, 6, 13
    drawTitle 90, 90, 6, 6, 13

    drawTitle 102, 72, 6, 30, 13          ;draw O
    drawTitle 108, 72, 6, 6, 13
    drawTitle 108, 96, 6, 6, 13
    drawTitle 114, 72, 6, 30, 13

    drawTitle 126, 72, 6, 30, 13          ;draw U 
    drawTitle 132, 96, 6, 6, 13
    drawTitle 138, 72, 6, 30, 13

    drawTitle 150, 72, 6, 30, 13          ;draw N 
    drawTitle 156, 72, 6, 6, 13
    drawTitle 162, 72, 6, 30, 13

    drawTitle 186, 72, 6, 30, 13          ;draw D 
    drawTitle 174, 84, 6, 18, 13
    drawTitle 180, 84, 6, 6, 13
    drawTitle 180, 96, 6, 6, 13
 
    drawTitle 198, 72, 18, 6, 13          ;draw S 
    drawTitle 198, 84, 18, 6, 13
    drawTitle 198, 96, 18, 6, 13
    drawTitle 198, 78, 6, 6, 13
    drawTitle 210, 90, 6, 6, 13
   
    drawTitle 5, 5, 4, 188, 13            ;draw border 
    drawTitle 309, 5, 4, 188, 13
    drawTitle 9, 5, 300, 4, 13
    drawTitle 9, 189, 300, 4, 13

    drawTitle 234, 72, 6, 18, 13          ;draw ?
    drawTitle 222, 72, 12, 6, 13
    drawTitle 228, 84, 6, 6, 13
    drawTitle 228, 96, 6, 6, 13

	call enable                           ;calls the options page menu 

    pop ax bx cx dx
optionsPage endp

enable proc
	mov ah, 02h
    mov bh, 00h
    mov dh, 0Fh
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, yes_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 11h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, no_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, back_text
    int 21h
	
	mov optSound, 1                       ;sets currently selectiod option to the first option 
	mov xloc, 149
	mov yloc, 129          
	mov wid, 20
	call drawSelect        

	;---checks which menu option is selected---
	selectMusicOption:    
		mov ah, 00h                      
		int 16h
		cmp soundOn, 1                   
		jne noSound1                     
		call beep
		
		noSound1:
		cmp ax, 4800h                    
		je upOption
		cmp ax, 5000h                    
		je downOption
		cmp ax, 1C0Dh                     
		je handleMusicSelection  

		downOption:
			cmp optSound, 3              
			je backToTopOption            

			add optSound, 1               
			call deleteSelect      
			add yloc, 16            
			call drawSelect         
			jmp selectMusicOption  

		upOption:
			cmp optSound, 1      
			je nextToBottomOption   

			sub optSound, 1       
			call deleteSelect      
			sub yloc, 16             
			call drawSelect         
			jmp selectMusicOption   

		backToTopOption:      
			mov optSound, 1       
			call deleteSelect     
			mov yloc, 129          
			call drawSelect
			jmp selectMusicOption  

		nextToBottomOption:   
			mov optSound, 3      
			call deleteSelect
			mov yloc, 161          
			call drawSelect
			jmp selectMusicOption  
	
		handleMusicSelection:          
			cmp optSound, 1
			je enableMusic
			cmp optSound, 2
			je disableMusic
			cmp optSound, 3        
			je returnToMenu

		enableMusic:
		  	mov soundOn, 1                ;enables sound 
			jmp returnToMenu

		disableMusic:
		  	mov soundOn, 0                ;disables sound 
			jmp returnToMenu
		  
		returnToMenu:
		  	call StartPage                ;returns to main menu
		  	ret
enable endp


; ----------------------------------------
;              Gameplay Menu
; ----------------------------------------
levelMenu proc
	push ax
	push bx
	push dx
	push cx
	
	call setVideoMode
	call drawBorder
	call drawBg
	call printName 
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 0Fh
	int 10h
	
	mov ah, 09h
	lea dx, levelmode_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level1_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level2_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level3_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Eh
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level4_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 10h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level5_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 11h
	int 10h
	
	mov ah, 09h
	lea dx, back_text
	int 21h
	
	mov optLevel, 1
	mov xloc, 142
	mov yloc, 73
	mov wid, 20
	call drawSelect                

	;---checks which level is chosen---
	selectLevel:
		mov ah, 00h              
		int 16h
		cmp soundOn, 1
		jne noSound3
		call beep
		
		noSound3:
		cmp ax, 4800h            
		je upLevel
		cmp ax, 5000h              
		je downLevel
		cmp ax, 1C0Dh              
		je selectedLevel
		
		downLevel:
			cmp optLevel, 6            
			je backLevel
			
			add optLevel, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectLevel
		
		upLevel:
			cmp optLevel, 1
			je nextLevel
			
			sub optLevel, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectLevel
			
		backLevel:
			mov optLevel, 1
			call deleteSelect
			mov yloc, 73          
			call drawSelect
			jmp selectLevel
		
		nextLevel:
			mov optLevel, 6
			call deleteSelect
			mov yloc, 153         
			call drawSelect
			jmp selectLevel
		
	selectedLevel:
		cmp optLevel, 6                   ;checks if back is selected 
		je backMenu
		
	level1:
		mov gamemode, 0                   ;sets gamemode to 0, indicating that level mode is chosen 
		call levelmode                    ;calls levelmode to prepare the gameplay 
		ret
	
	backMenu:
		call StartPage                    ;if back is selected, call main menu 
		ret 
	
	pop ax
	pop bx
	pop dx
	pop cx
levelMenu endp

timedMenu proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	call printName
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 04h
	mov dl, 0Fh
	int 10h
	
	mov ah, 09h
	lea dx, timedmode_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level1_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ah
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level2_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Ch
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level3_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 0Eh
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level4_text
	int 21h

	mov ah, 02h
	mov bh, 00h
	mov dh, 10h
	mov dl, 10h
	int 10h
	
	mov ah, 09h
	lea dx, level5_text
	int 21h
	
	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 11h
	int 10h
	
	mov ah, 09h
	lea dx, back_text
	int 21h
	
	mov optLevel, 1
	mov xloc, 142
	mov yloc, 73
	mov wid, 20
	call drawSelect               

	;---checks which option is selected--- 
	selectTimed:
		mov ah, 00h                
		int 16h
		cmp soundOn, 1
		jne noSound4
		call beep
		
		noSound4:
		cmp ax, 4800h           
		je upTimed
		cmp ax, 5000h          
		je downTimed
		cmp ax, 1C0Dh          
		je selectedTimed
		
		downTimed:
			cmp optLevel, 6           
			je backTimed
			
			add optLevel, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectTimed
		
		upTimed:
			cmp optLevel, 1
			je nextTimed
			
			sub optLevel, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectTimed
			
		backTimed:
			mov optLevel, 1
			call deleteSelect
			mov yloc, 73          
			call drawSelect
			jmp selectTimed
		
		nextTimed:
			mov optLevel, 6
			call deleteSelect
			mov yloc, 153          
			call drawSelect
			jmp selectTimed
		
	selectedTimed:
		cmp optLevel, 6                   ;checks if back is selected 
		je backMenu1
		
	timed1:
		mov gamemode, 1                   ;indicates that timed mode is selected 
		call levelmode                    ;prepares gameplay 
		ret
		
	backMenu1:
		call StartPage                    ;if back is selected, go to main menu
		ret
		
	pop ax
	pop bx
	pop dx
timedMenu endp

levelmode proc
	push ax          ; Save registers
	push dx
	push cx
	push bx

	call setVideoMode
	call drawBoundary
	call drawBorder
	mov begin, 1     ; Indicates that the game is set to begin
	mov lives, 3     ; Sets lives count to 3 (primarily for level mode)

	; Determine level settings based on optLevel
	cmp optLevel, 1
	je level1_settings_for_59s
	cmp optLevel, 2
	je level2_settings_for_59s
	cmp optLevel, 3
	je level3_settings_for_59s
	cmp optLevel, 4
	je level4_settings_for_59s
	cmp optLevel, 5
	je level5_settings_for_59s
	; Default to level 1 if optLevel is out of expected 2-5 range or handle as error
	jmp level1_settings_for_59s 

level1_settings_for_59s:
	call levelOne     ; Sets the bricks layout for level 1
	mov innerDelay, 0 ; Sets the speed of the ball
	mov fastball, 0
	jmp common_game_initialization_for_59s
	
level2_settings_for_59s:
	call levelTwo
	mov innerDelay, 0
	mov fastball, 0
	jmp common_game_initialization_for_59s
	
level3_settings_for_59s:
	call levelThree
	mov innerDelay, 1 ; Ball is faster
	mov fastball, 1
	jmp common_game_initialization_for_59s
		
level4_settings_for_59s:
	call levelFour
	mov innerDelay, 1
	mov fastball, 1
	jmp common_game_initialization_for_59s
		
level5_settings_for_59s:
	call levelFive
	mov innerDelay, 2 ; Ball is fastest
	mov fastball, 2
	jmp common_game_initialization_for_59s

common_game_initialization_for_59s: ; Renamed label for clarity
	call BuildB         ; Builds the bricks on the screen
	call printName      ; Prints player's name
	redrawStriker 13    ; Draws striker
	redrawBall 15       ; Draws ball

	; --- THIS SECTION ENSURES IMMEDIATE "59" DISPLAY FOR TIMED MODE ---
	cmp gamemode, 0      ; Check if level mode (gamemode == 0)
	je about_to_start_gameloop_59s ; If level mode, skip initial timer print

	; If timed mode (gamemode == 1), call printTime to display the initial "59"
	call printTime       ; Assumes printTime correctly displays "59"
	                     ; based on tens and ones variables.
	; -------------------------------------------------------------------
	
about_to_start_gameloop_59s: ; Renamed label for clarity
	call gameLoop       ; Starts the main game loop
	
	pop bx              ; Restore registers
	pop cx
	pop dx
	pop ax
	ret
levelmode endp

playNext proc
	;---redefines the variables--- 
	mov ballX, 158
	mov ballY, 163
	mov ballLeft, 1
	mov ballUp, 1
	mov strikerX, 140
	mov timeCtr, 0
	mov tens, 53
	mov ones, 57
	mov scoreCount, 0
	mov timeScore, 0
	
	;---checks which options is currently selected---
	cmp optLevel, 1                       
	je playLevel2
	cmp optLevel, 2
	je playLevel3
	cmp optLevel, 3
	je playLevel4
	cmp optLevel, 4
	je playLevel5
	cmp optLevel, 5
	je playMore
	
	;sets optLevel to the succeeding level of the current optLevel   
	playLevel2:
		mov optLevel, 2                    
		jmp play 
		
	playLevel3:
		mov optLevel, 3
		jmp play 
		
	playLevel4:
		mov optLevel, 4
		jmp play 
		
	playLevel5:
		mov optLevel, 5
		jmp play 
		
	;---if the last level is the current optLevel---
	playMore:
		cmp gamemode, 1                   ;checks if timed mode was chosen 
		je goToMain                       ;if yes, jump to goToMain 
		
		mov gamemode, 1                   ;if not, switch to timed mode
		mov optLevel, 1                   ;sets optLevel to 1
		call levelmode                    ;prepares game to play level 1 of timed mode 
		ret 
		
		;---if level 5 of timed mode was playing--- 
		goToMain:
			call StartPage                ;goes back to the main menu          
			ret
		
	play:
		call levelmode
	ret
playNext endp


; ----------------------------------------
;              Bricks Layout
; ----------------------------------------
;---sets the x and y-locations of the bricks---
levelOne proc
	mov brick1x, 142
	mov brick1y, 44
	mov brick2x, 39
	mov brick2y, 63
	mov brick3x, 169
	mov brick3y, 63
	mov brick4x, 243
	mov brick4y, 63
	mov brick5x, 142
	mov brick5y, 80
	mov brick6x, 88
	mov brick6y, 44
	mov brick7x, 195
	mov brick7y, 44
	mov brick8x, 114
	mov brick8y, 63
	mov brick9x, 88
	mov brick9y, 80
	mov brick10x, 195
	mov brick10y, 80
	ret
levelOne endp

levelTwo proc
	mov brick1x, 48
	mov brick1y, 44
	mov brick2x, 106
	mov brick2y, 44
	mov brick3x, 204
	mov brick3y, 62
	mov brick4x, 48
	mov brick4y, 80
	mov brick5x, 106
	mov brick5y, 80
	mov brick6x, 176
	mov brick6y, 44
	mov brick7x, 234
	mov brick7y, 44
	mov brick8x, 76
	mov brick8y, 62
	mov brick9x, 176
	mov brick9y, 80
	mov brick10x, 234
	mov brick10y, 80
	ret
levelTwo endp

levelThree proc
	mov brick1x, 115
	mov brick1y, 54
	mov brick2x, 169
	mov brick2y, 54
	mov brick3x, 91
	mov brick3y, 75
	mov brick4x, 142
	mov brick4y, 75
	mov brick5x, 193
	mov brick5y, 75
	mov brick6x, 142
	mov brick6y, 36
	mov brick7x, 65
	mov brick7y, 97
	mov brick8x, 116
	mov brick8y, 97
	mov brick9x, 167
	mov brick9y, 97
	mov brick10x, 218
	mov brick10y, 97
	ret
levelThree endp

levelFour proc
	mov brick1x, 106
	mov brick1y, 37
	mov brick2x, 191
	mov brick2y, 57
	mov brick3x, 142
	mov brick3y, 75
	mov brick4x, 192
	mov brick4y, 92
	mov brick5x, 106
	mov brick5y, 116
	mov brick6x, 150
	mov brick6y, 47
	mov brick7x, 89
	mov brick7y, 63
	mov brick8x, 215
	mov brick8y, 74
	mov brick9x, 89
	mov brick9y, 91
	mov brick10x, 152
	mov brick10y, 103
	ret
levelFour endp

levelFive proc
	mov brick1x, 71
	mov brick1y, 59
	mov brick2x, 118
	mov brick2y, 59
	mov brick3x, 167
	mov brick3y, 59
	mov brick4x, 215
	mov brick4y, 59
	mov brick5x, 142
	mov brick5y, 98
	mov brick6x, 94
	mov brick6y, 39
	mov brick7x, 190
	mov brick7y, 39
	mov brick8x, 95
	mov brick8y, 78
	mov brick9x, 142
	mov brick9y, 78
	mov brick10x, 191
	mov brick10y, 78
	ret
levelFive endp


; ----------------------------------------
;                 Bricks
; ----------------------------------------
BuildB proc	
	;---passes bricks coordinates and color to the BuildBrick macro---
	BuildBrick brick1x, brick1y, 9
	BuildBrick brick2x, brick2y, 10
	BuildBrick brick3x, brick3y, 9
	BuildBrick brick4x, brick4y, 9
	BuildBrick brick5x, brick5y, 10
	BuildBrick brick6x, brick6y, 12
	BuildBrick brick7x, brick7y, 11
	BuildBrick brick8x, brick8y, 12
	BuildBrick brick9x, brick9y, 11
	BuildBrick brick10x, brick10y, 12
	ret
BuildB endp

AddBrick proc
    push ax
    push bx    
	
    mov startx, ax                        ;sets the x-loc of the brick based on the argument passed to BuildB proc 
    mov ax, bx                            ;moves the y-loc of the brick to the ax register 
    mov bx, startx                        ;moves the value of startx to the bx register  
    add bx, 35                            ;adds brick's width to the x-loc of the brick 
    mov endx, bx                          ;sets the x-loc of the last pixel of the brick   
    
    mov starty, ax                        ;sets the y-loc of the brick based on the argument passed to BuildB proc
    mov bx, starty                        ;moves the value of starty to the bx register 
    add bx, 7                             ;adds brick's height to the y-loc of the brick 
    mov endy, bx                          ;sets the y-loc of the last pixel of the brick 
     
    call draw                             ;draws the brick 
	
    pop bx
    pop ax 
    ret
AddBrick endp

CollideB proc
	;---passes bricks coordinates to the BrickCollision macro---
	BrickCollision brick1x, brick1y
	BrickCollision brick2x, brick2y
	BrickCollision brick3x, brick3y
	BrickCollision brick4x, brick4y
	BrickCollision brick5x, brick5y
	BrickCollision brick6x, brick6y
	BrickCollision brick7x, brick7y
	BrickCollision brick8x, brick8y
	BrickCollision brick9x, brick9y
	BrickCollision brick10x, brick10y
	ret
CollideB endp

RemoveBrick proc 
    push ax
    push bx
    push cx
    push dx
    
	;---ax/bx -> x-loc/y-loc of the brick to be removed based on the arguments passed on the BrickCollision macro---
    mov startx, ax                     
    mov color, 0                          ;changes the color of the brick to black, similar to the background's color   
    mov ax, bx
    mov bx, startx   
    add bx, 35
    mov endx, bx
    
    mov starty, ax 
    mov bx, starty
    add bx, 7
    mov endy,bx
 
    call draw                             ;draws the brick as black, making it invisible on the screen 
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
RemoveBrick endp

;----------------------------------------------------
; SubtractFiveSeconds - Deducts 5 seconds from timer
;                       Updates 'tens' and 'ones' (both DB)
;                       Handles underflow (sets time to 00)
;----------------------------------------------------
SubtractFiveSeconds proc
    push ax
    push bx
    push cx
    push dx

    ; Convert current time (tens, ones) to total seconds
    mov al, tens    ; AL = ASCII value from DB 'tens'
    sub al, '0'     ; Convert ASCII tens digit to number
    mov bl, 10
    mul bl          ; AX = AL * BL (tens_value * 10)
    mov cx, ax      ; CX = numerical value of tens part

    mov al, ones    ; AL = ASCII value from DB 'ones'
    sub al, '0'     ; Convert ASCII ones digit to number
    cbw             ; Extend AL to AX (AH becomes 0 for the numeric value)
    add cx, ax      ; CX = total seconds (e.g., tens_val*10 + ones_val)

    ; Subtract 5 seconds
    sub cx, 5       ; CX = total seconds - 5

    ; Check if time is less than or equal to 0
    cmp cx, 0
    jle TimeIsUp_SetToZero_SF ; Jump if Less than or Equal

    ; Time is > 0, convert back to tens and ones
    mov ax, cx      ; AX now has remaining_seconds
    mov dl, 10      ; Divisor
    div dl          ; AL = quotient (new tens_value), AH = remainder (new ones_value)

    mov bl, al      ; Store new tens_value in BL temporarily
    add bl, '0'     ; Convert new tens_value to ASCII
    mov tens, bl    ; Store 8-bit ASCII in DB 'tens'

    mov bl, ah      ; Store new ones_value in BL temporarily
    add bl, '0'     ; Convert new ones_value to ASCII
    mov ones, bl    ; Store 8-bit ASCII in DB 'ones'
    jmp EndSubtractFiveSeconds_SF

TimeIsUp_SetToZero_SF:
    mov tens, '0'   ; Store 8-bit ASCII '0' in DB 'tens'
    mov ones, '0'   ; Store 8-bit ASCII '0' in DB 'ones'

EndSubtractFiveSeconds_SF:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
SubtractFiveSeconds endp

; ----------------------------------------
;                  Ball
; ----------------------------------------
drawball proc
    push bx
	
    ;---draws the ball with the color based on the argument passed to the redrawball macro 
	;to determine if the ball will be added/visible or removed/invisible---
	mov bx, ballX
    mov startx, bx
    add bx, 5                             ;5 -> width of the ball 
    mov endx,   bx
	
    mov bx, ballY
    mov starty, bx
    add bx, 5                             ;5 -> height of the ball
    mov endy,   bx
	
    pop bx
    
    call draw
ret
drawball endp

Collisionwall proc
    mov bx, ballX           ; bx = current ball x-coordinate
    mov cx, ballY           ; cx = current ball y-coordinate

checkLeftRight:
    cmp bx, 25              ; Is ball beyond left wall (x < 25)?
    jl goRight              ; If yes, make ball go right
    cmp bx, 290             ; Is ball beyond right wall (x > 290)?
    jg goLeft               ; If yes, make ball go left
    jmp checkUpDown         ; Otherwise, check top/bottom walls

goRight:
    mov ballLeft, 0         ; Set ball direction to right
    jmp checkUpDown

goLeft:
    mov ballLeft, 1         ; Set ball direction to left

checkUpDown:
    cmp cx, 25              ; Is ball beyond top wall (y < 25)?
    jl goDown               ; If yes, make ball go down
    cmp cx, 175             ; Is ball beyond bottom edge of play area (y > 175)?
                            ; Note: This 175 is the play area bottom, not screen bottom.
                            ; Striker collision handles actual screen bottom.
    jg goUp                 ; If yes, make ball go up

    jmp noWallCollision_CW  ; No wall collision detected in this check

goUp:
    mov ballUp, 1           ; Set ball direction to up
    jmp noWallCollision_CW

goDown:
    mov ballUp, 0           ; Set ball direction to down

noWallCollision_CW:
    ret
Collisionwall endp

CollisionStriker proc
    push ax
    push bx
    push cx
    push dx

    mov dx, ballY           ; dx = current ball y-coordinate
    cmp dx, 165             ; Is ball above the paddle's top edge?
    jnl ContinueCheck1_CS   ; If ball_y >= 165, continue checking
    jmp ExitCS_NoAction     ; If ball_y < 165, it's too high, no action here

ContinueCheck1_CS:
    cmp dx, 170             ; Is ball below the paddle's main body?
    jg FellOffBottom_CS     ; If ball_y > 170, it fell off screen bottom

    ; Ball Y is within paddle's Y-range [165, 170]. Check X-collision.
    mov cx, strikerX        ; cx = striker's x-coordinate
    mov ax, ballX           ; ax = ball's x-coordinate
    cmp ax, cx              ; Is ball to the left of striker?
    jnl ContinueCheck2_CS   ; If ball_x >= striker_x, continue checking
    jmp ExitCS_NoAction     ; Ball missed to the left

ContinueCheck2_CS:
    add cx, 40              ; cx = striker's right edge (strikerX + width)
    cmp ax, cx              ; Is ball to the right of striker's right edge?
    jng HitThePaddle_CS     ; If ball_x <= striker_right_edge, it's a hit or on the edge
    jmp ExitCS_NoAction     ; Ball missed to the right

HitThePaddle_CS:
    ; Ball hit the paddle
    mov ballUp, 1           ; Make ball go up
    jmp ExitCS_NoAction     ; Action taken, exit

FellOffBottom_CS:           ; Ball fell off screen (ballY > 170)
    cmp gamemode, 1         ; Is it Timed Mode?
    jne LevelModeDrop_CS    ; If not, handle Level Mode ball drop

    ; --- Timed Mode Ball Drop ---
    call SubtractFiveSeconds ; Deduct 5 seconds

    ; Flash timer red
    mov byte ptr [timer_color], 0Ch ; Set timer color to Red
    call printTime                  ; Print timer in red

    call ShortDelayForFlash         ; Wait for a short period

    mov byte ptr [timer_color], 0Fh ; Set timer color back to Normal (e.g., White)
    call printTime                  ; Print timer in normal color

    call stopTime           ; Check if time is up
    cmp begin, 0            ; Did game end?
    je ExitCS_GameOver      ; If yes, go to game over exit

    ; Timed mode, game not over, reset ball
    redrawball 0            ; Erase ball
    mov ballY, 163          ; Reset ball Y
    mov ballX, 158          ; Reset ball X
    mov ballUp, 1           ; Set ball direction up
    mov ballLeft, 1         ; Set ball direction left
    redrawball 15           ; Draw ball
    jmp ExitCS_NoAction     ; Continue game

LevelModeDrop_CS:
    ; --- Level Mode Ball Drop ---
    cmp lives, 0
    je LevelModeFinish_CS   ; If no lives left, game over
    call removeLives        ; Remove a life display
    call decLives           ; Decrement life count & reset ball (decLives calls gameLoop)
    jmp ExitCS_NoAction     ; Likely won't be reached if decLives loops

LevelModeFinish_CS:
    mov begin, 0            ; Mark game as ended
    redrawball 0            ; Erase ball
    redrawStriker 0         ; Erase striker
    call GameOverPage       ; Show game over screen
    ; Fall through to ExitCS_GameOver

ExitCS_GameOver:            ; Exit path if game ended in this procedure
    pop dx
    pop cx
    pop bx
    pop ax
    ret

ExitCS_NoAction:            ; General exit path if no game-ending event or ball was hit
    pop dx
    pop cx
    pop bx
    pop ax
    ret
CollisionStriker endp

movement1:
ret
ballMove proc  
	inc innerDelay                        ;increments the delay on the gameloop 
	cmp innerDelay, EXTERNDELAY           ;checks if the specified inner delay of the ball is equal to the external delay 
	jne movement1                         ;if not, loop to movement1, creating delay for the movement of the loop
	
	cmp fastBall, 0                       ;checks if fastBall is set to 0
	je slow                               ;if equal, jump to slow 
	cmp fastball, 1
	je fast1
	cmp fastBall, 2
	je fast2 
	
	slow:
		mov innerDelay, 0                 ;resets inner delay to 0
		jmp nextball 
	
	fast1:
		mov innerDelay, 1
		jmp nextball 
		
	fast2:
		mov innerDelay, 2
		
	nextball:
		redrawBall 0                      ;removes ball at current position 
    
	mov bx, ballX                         ;moves current ballX to bx register 
	cmp ballLeft, 1                       ;checks if ball is moving to the left
	je Left                               ;if yes, jump to Left 
	jne Right                             ;if not, jump to Right
	
	Left:   
		sub bx, 2                         ;subtract 2 from bx/ move ball to the left  
		jmp changeBall                    
		
	Right:   
		add bx, 2                         ;add 2 to bx/ move ball to the right 
	
	changeBall:
		mov ballX,  bx                    ;sets ball's x-loc to the value of bx 
		mov bx, ballY                     ;moves current ballY to bx 
		cmp ballUp, 1                     ;checks if ball is moving upwards 
		je Up                             
		jne Down
	
	Up:
		sub bx, 2                         ;subtract 2 from bx/ mvoe ball upwards 
		jmp moveBall
		
	Down:
		add bx, 2                         ;add 2 to bx/ move ball downwards 
		
	moveBall:
		mov ballY,  bx                    ;sets ball's y-loc to the value of bx 
		redrawBall 15                     ;draws the ball on the screen 
    
	ret
ballMove endp   

switcher proc
    cmp ballUp, 1                         ;check if ball is moving upwards when it hits a brick 
    je DownT                              ;if yes, jump to DownT 
    jne UpT                               ;if not, jump to UpT 
	
    UpT:
		inc ballUp                        ;(ballUp=0, ballUp++ => ballUp=1)
		ret
	
    DownT:
		dec ballUp                        ;(ballUp=1, ballUp-- => ballUp=0)
		ret
	ret
switcher endp


; ----------------------------------------
;                 Striker
; ----------------------------------------
drawStriker proc
    push bx
    push cx
 
    mov bx, strikerX                      ;moves striker's x-loc to bx register 
    mov cx, strikerY                      ;moves striker's y-loc to cx register 
    mov startx, bx                        ;sets startx to the x-loc of striker 
    add bx, 40                            ;adds 40 (strker's width) to the x-loc of striker 
    mov endx, bx                          ;sets endx to the value of bx 
	
    mov starty, cx                        ;sets starty to the y-loc of the striker 
    mov endy, 175                         ;sets endy to 175 (y-loc of the last row of pixels of the striker) 
    call draw                             ;draws the striker 
    
    pop cx
    pop bx
    ret
drawStriker endp


; ----------------------------------------
;                 Lives
; ----------------------------------------
drawLives proc
	cmp lives, 3                          ;checks if lives=3
	jne twoLives                          ;if not, jump to twoLives 
	
	;---if lives=3---
	mov tempLifeX, 290                    ;sets tempLifeX to 290 (x-loc of the third heart)                    
	mov tempLifeY, 181                    ;sets tempLifeY to 181 (y-loc of the third heart)
	call drawLife                         ;draws the heart 
	
	;---if lives!=3---
	twoLives:
		cmp lives, 2                      ;checks if lives=2
		jl oneLife                        ;if less than 2, jump to oneLife 
		mov tempLifeX, 270                ;if greater than or equal, set tempLifeX and tempLifeY 
		mov tempLifeY, 181                
		call drawLife

	;---if lives<2---
	oneLife:
		cmp lives, 0                      ;checks if lives=0
		je noLives                        ;if yes, jump to noLives 
		mov tempLifeX, 250                ;if greater than, set tempLifex and tempLifeY
		mov tempLifeY, 181
		call drawLife
	
	noLives:
	ret
drawLives endp

drawLife proc
	mov cx, tempLifeX                     ;moves the value of tempLifeX to cx 
	mov dx, tempLifeY
	mov si, offset life                   ;sets the source index to the offset of life bitmap variable 
	
	;---loop to draw the pixel one by one---
	drawLife1:
		mov ah, 0Ch                       ;draw pixel instruction 
		mov al, [si]                      ;draws the pixel of the current offset to the screen 
		mov bh, 00h                       
		int 10h
		
		inc si                            ;moves to the next offset of the bmp 
		inc cx                            ;moves the x-loc position on the screen 
		mov ax, cx                        ;moves current x-position to ax register 
		sub ax, tempLifeX                 ;subracts the value of tempLifeX from the value of ax (at first, it will be 0)
		cmp ax, 15                        ;checks if the current value of ax (at first 0) is equal to 15 (width of bitmap)
		jne drawLife1                     ;if not, loop to drawLife1
		
		mov cx, tempLifeX                 ;if yes, move tempLifeX to the cx register
		inc dx                            ;move to the next line/row on the screen 
		mov ax, dx                        ;moves current y-position to ax register 
		sub ax, tempLifeY                 ;subtracts the value of tempLifeY from the value of ax (at first 0) 
		cmp ax, 15                        ;checks if the current value of ax is equal to 15 (height of the bitmap)
		jne drawLife1                     ;if not, continue loop 
	ret 
drawLife endp

decLives proc
	dec lives                             ;decrements current lives count by 1 
	redrawball 0                          ;removes ball 
	mov ballY, 163                        ;resets ball's position 
	mov ballX, 158
	mov ballUp, 1                         ;resets ball's direction 
	mov ballLeft, 1
	redrawball 15                         ;draws ball 
	call gameloop
	ret
decLives endp

removeLives proc
	drawTitle 249, 181, 60, 19, 0         ;removes all three hearts (draws a black rectangle on the hearts' position)
	ret
removeLives endp


; ----------------------------------------
;         Timer Display Procedure
; ----------------------------------------
; ----------------------------------------
;         Timer Display Procedure
; ----------------------------------------
printTime proc
    push ax
    push bx ; Will be used for the color attribute
    push cx
    push dx

    ; Set cursor position for the timer display
    mov ah, 02h     ; BIOS function: Set Cursor Position
    mov bh, 0       ; Page number 0
    mov dh, 01h     ; Row 1 (or your desired row for the timer)
    mov dl, 13h     ; Column 13 (or your desired starting column for the timer)
    int 10h

    ; Get the color to use from the timer_color variable
    mov bl, [timer_color] ; Put the color attribute into BL for teletype output

    ; Display the tens digit
    mov ah, 0Eh     ; BIOS function: Teletype Output (prints char in AL with attribute in BL)
    mov al, [tens]  ; AL = character to print (from 'tens' variable, which is a db)
    ; BH = page number (should still be 0 from the cursor setting)
    int 10h         ; Print the character in AL using the color attribute in BL

    ; Display the ones digit
    mov ah, 0Eh     ; BIOS function: Teletype Output
    mov al, [ones]  ; AL = character to print (from 'ones' variable, which is a db)
    int 10h         ; Print the character in AL using the color attribute in BL

    ; After teletype output, the cursor has moved forward.
    ; Move it back two places so that the next time printTime is called,
    ; it overwrites the same spot, making the timer appear to update in place.
    mov ah, 02h     ; BIOS function: Set Cursor Position
    mov bh, 0       ; Page number 0
    ; dh (row) is still correct from the first cursor setting in this procedure
    sub dl, 2       ; DL is currently to the right of the 'ones' digit.
                    ; Subtract 2 to move the cursor back to the 'tens' digit position.
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
printTime endp

ShortDelayForFlash proc
    push ax ; Save AX register (good practice if using it or if interrupts might affect it)
    push cx ; Save CX register
    push dx ; We will use DX as an outer loop counter

    mov dx, 10      ; OUTER LOOP COUNTER: Makes the inner loop run 10 times.
                    ; Increase this '10' (e.g., to 20, 30, 50) to make the delay much longer.
                    ; Decrease it if the delay is too long.
OuterDelayLoop_SDF:
    mov cx, 0FFFFh  ; INNER LOOP COUNTER: This is the maximum delay for CX with the 'loop' instruction.
InnerDelayLoop_SDF:
    loop InnerDelayLoop_SDF ; Consume the CX counter (inner delay)

    dec dx              ; Decrease the outer loop counter
    jnz OuterDelayLoop_SDF ; If DX is not yet zero, repeat the outer loop (and the inner loop)

    pop dx
    pop cx
    pop ax
    ret
ShortDelayForFlash endp

stopTime proc
	cmp tens, 48                          ;checks if tens=0      
	je checkOnes                          ;if yes, jump to checkOnes 
	ret                                   ;if not, timer is not set to end yet 
	
	;---if tens=0---
	checkOnes:
		cmp ones, 48                      ;checks if ones=0
		je stop                           ;if yes, then timer is at '00', so game is over 
		ret
	
	stop:
		call GameOverPage
stopTime endp

; ----------------------------------------
;                Game Loop
; ----------------------------------------
repeat:
	call checkKeyboard                    ;checks keyboard inputs (left and right)
	cmp begin, 1                          ;check if game is set to start
	jne repeat                            ;restarts game loop if begin=0

gameLoop:
    inc timeCtr
    call checkKeyboard

    cmp isPaused, 1
    je gameLoop

    cmp gamemode, 0
    je none1_timer_logic ; Skip timer logic if not in timed mode

    ; --- Timed Mode Logic ---
    cmp timeCtr, 100    ; Has 1 second passed? (assuming 100 iterations = 1 sec)
    jne none1_timer_logic ; If not, skip decrementing
    mov timeCtr, 0      ; Reset 1-second counter

    ; Decrement timer
    dec byte ptr [ones] ; Decrement the ASCII value in 'ones'
    cmp byte ptr [ones], ('0' - 1) ; Did 'ones' roll under '0'? (e.g., from '0' to '/')
    jne PrintTheTime_GL ; If not, just print the new time

    ; 'ones' was '0' and went below, so reset 'ones' to '9' and decrement 'tens'
    mov byte ptr [ones], '9'
    dec byte ptr [tens]
    ; No need to check if tens went below '0' here, stopTime will handle it.
    ; stopTime calls GameOverPage if tens and ones are both '0'.

PrintTheTime_GL:
    call printTime      ; Display the (potentially) updated time
    call stopTime       ; Check if timer reached 00 and game should end

none1_timer_logic:      ; Label for skipping timer logic or continuing after it
    ; ... (rest of your game loop: drawLives if level mode, collision checks, ballMove, sleep) ...
    cmp gamemode, 0
    jne noLives1_GL     ; In timed mode, skip drawing lives
    call drawLives      ; In level mode, draw lives
noLives1_GL:
    call Collisionwall
    call CollisionStriker
    call CollideB
    call ballMove
    call sleep
    jmp gameLoop        ; Loop back

; ... (exit label and ret for gameLoop if it's a separate proc, or just continue if it's inline) ...
    
exit:
    ret

checkKeyboard proc
    mov ah, 1h                          
    int 16h                               ;checks for keypress
    jz noInput                            ;if none, jump to noInput 
	
    mov ah, 0h                            ;checks keyboard input
    int 16h
    cmp ax, 4D00h                         ;checks if the right-key arrow is pressed
    je  rightKey
    cmp ax, 4B00h		                  ;checks if the left-key arrow is pressed
    je leftKey
	cmp ax, 011Bh                         ;checks if the escape key is pressed 
	je exitGame
    cmp al, 'p'                           ;check if p key is pressed (case sensitive)
    je pauseGame
    cmp al, 'P'                           ;check if P key is pressed (upper case)
    je pauseGame
    
    noInput:
		ret  
    rightKey:     
		mov bx, boundaryEnd               ;moves the value of boundaryEnd to the bx register 
		cmp strikerX, bx	              ;checks if the striker reaches the wall  
		jg  noInput                       ;if striker reaches the wall, stop receiving input
		redrawStriker 0                   ;removes striker at current position 
		add strikerX, 5                   ;moves the striker 5px to the right
		redrawStriker 13                  ;draws striker at new position 
		cmp begin, 0                      ;checks if game is set to loop 
		jz moveBallRight                  ;ensures the ball does not stop moving even when pressing the key
		jmp noInput
    
    leftKey:   
		mov bx, boundaryStart                            
		cmp strikerX, bx 
		jl noInput
		redrawStriker 0
		sub strikerX, 5                   ;moves the striker 5px to the left 
		redrawStriker 13
		cmp begin, 0
		jz moveBallLeft
		jmp noInput
		
	exitGame:
		call StartPage                    ;goes back to the main menu
		ret
    
    pauseGame:
        cmp isPaused, 1                   ;check if already paused
        je noInput                        ;if already paused, do nothing
        mov isPaused, 1                   ;set pause flag
        call showPauseMenu                ;display pause menu
        ret
        
	;---moves ball to the right---
	moveBallRight:
		redrawBall 0
		add ballX, 5
		redrawBall 15
		jmp noInput
	
	;---moves ball to the left---
    moveBallLeft:
		redrawBall 0
		sub ballX, 5
		redrawBall 15
		jmp noInput
checkKeyboard endp


; ----------------------------------------
;             Pause Menu Functions
; ----------------------------------------
showPauseMenu proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ; --- 1. Draw Pause Menu Background Box (Filled Rectangle) ---
    mov di, [pauseBoxY]     ; Start Y in DI (current row to draw)
    local endY_SMP:word     ; SMP for ShowMenuPause
    mov ax, [pauseBoxY]
    add ax, [pauseBoxH]
    mov endY_SMP, ax        ; End Y

FillPauseBoxLoop_SMP:
    cmp di, endY_SMP        ; Have we drawn all rows?
    jge DoneFillingBox_SMP  ; If current Y >= end Y, box is filled

    mov ax, [pauseBoxX]     ; Get value of pauseBoxX
    mov xlocRec, ax
    mov ylocRec, di         ; Current Y row (DI is a word register)
    mov ax, [pauseBoxW]     ; Get value of pauseBoxW
    mov widRec, ax
    mov heightRec, 1        ; Height of the line is 1 pixel
    mov al, [PauseBoxColor] ; Get the box color
    mov color, al           ; Assuming 'color' is the variable AddRec uses
    call AddRec

    inc di                  ; Move to the next row
    jmp FillPauseBoxLoop_SMP
DoneFillingBox_SMP:

    ; --- 2. Display "GAME PAUSED" Title ---
    mov ah, 02h
    mov bh, 0
    mov dh, [PauseTitleRow]
    mov dl, [PauseTitleCol]
    int 10h
    mov ah, 09h
    lea dx, pausedMsg
    int 21h

    ; --- 3. Display "RESUME" Option ---
    mov ah, 02h
    mov bh, 0
    mov dh, [PauseResumeRow]
    mov dl, [PauseResumeCol]
    int 10h
    mov ah, 09h
    lea dx, pauseResumeText
    int 21h

    ; --- 4. Display "MAIN MENU" Option ---
    mov ah, 02h
    mov bh, 0
    mov dh, [PauseMainRow]
    mov dl, [PauseMainCol]
    int 10h
    mov ah, 09h
    lea dx, pauseMainMenuText
    int 21h

    ; --- 5. Initialize selection and Set Underline for "RESUME" ---
    mov byte ptr [pauseOpt], 1  ; Default select "RESUME"

    mov al, [PauseResumeCol]
    mov bl, PixelsPerChar
    mul bl
    mov xloc, ax

    mov al, [PauseResumeRow]
    mov bl, PixelsPerChar
    mul bl
    add ax, PixelsPerChar
    mov yloc, ax

    mov ax, 6 ; Length of "RESUME"
    mov bl, PixelsPerChar
    mul bl
    mov wid, ax
    call drawSelect

PauseMenuInputLoop_SMP:
    mov ah, 00h
    int 16h

    cmp soundOn, 1
    jne NoBeep_SMP
    call beep
NoBeep_SMP:

    cmp ah, 48h             ; Up Arrow?
    jne CheckDown_SMP
    jmp PauseOptUp_SMP_Action
CheckDown_SMP:
    cmp ah, 50h             ; Down Arrow?
    jne CheckEnter_SMP
    jmp PauseOptDown_SMP_Action
CheckEnter_SMP:
    cmp ax, 1C0Dh           ; Enter key?
    jne CheckP_SMP
    jmp PauseOptSelected_SMP_Action
CheckP_SMP:
    cmp al, 'p'
    jne CheckCapsP_SMP
    jmp QuickResumeHandler_SMP_Action
CheckCapsP_SMP:
    cmp al, 'P'
    jne LoopNoKey_SMP
    jmp QuickResumeHandler_SMP_Action
LoopNoKey_SMP:
    jmp PauseMenuInputLoop_SMP

PauseOptUp_SMP_Action:
    cmp byte ptr [pauseOpt], 1
    jne WasOnMain_SMP
    ; Was on RESUME, loop to MAIN MENU
    call deleteSelect
    mov byte ptr [pauseOpt], 2
    mov al, [PauseMainCol]
    mov bl, PixelsPerChar
    mul bl; mov xloc, ax
    mov xloc, ax
    mov al, [PauseMainRow]
    mov bl, PixelsPerChar
    mul bl; add ax, PixelsPerChar; mov yloc, ax
    add ax, PixelsPerChar
    mov yloc, ax
    mov ax, 9; "MAIN MENU" length
    mov bl, PixelsPerChar
    mul bl; mov wid, ax
    mov wid, ax
    jmp DrawNewSel_SMP

WasOnMain_SMP:
    ; Was on MAIN MENU, move to RESUME
    call deleteSelect
    dec byte ptr [pauseOpt]
    mov al, [PauseResumeCol]
    mov bl, PixelsPerChar
    mul bl; mov xloc, ax
    mov xloc, ax
    mov al, [PauseResumeRow]
    mov bl, PixelsPerChar
    mul bl; add ax, PixelsPerChar; mov yloc, ax
    add ax, PixelsPerChar
    mov yloc, ax
    mov ax, 6; "RESUME" length
    mov bl, PixelsPerChar
    mul bl; mov wid, ax
    mov wid, ax
    ; Fall through to DrawNewSel_SMP

DrawNewSel_SMP:
    call drawSelect
    jmp PauseMenuInputLoop_SMP

PauseOptDown_SMP_Action:
    cmp byte ptr [pauseOpt], 2
    jne WasOnResume_SMP
    ; Was on MAIN MENU, loop to RESUME
    call deleteSelect
    mov byte ptr [pauseOpt], 1
    mov al, [PauseResumeCol]
    mov bl, PixelsPerChar
    mul bl; mov xloc, ax
    mov xloc, ax
    mov al, [PauseResumeRow]
    mov bl, PixelsPerChar
    mul bl; add ax, PixelsPerChar; mov yloc, ax
    add ax, PixelsPerChar
    mov yloc, ax
    mov ax, 6; "RESUME" length
    mov bl, PixelsPerChar
    mul bl; mov wid, ax
    mov wid, ax
    jmp DrawNewSel_SMP

WasOnResume_SMP:
    ; Was on RESUME, move to MAIN MENU
    call deleteSelect
    inc byte ptr [pauseOpt]
    mov al, [PauseMainCol]
    mov bl, PixelsPerChar
    mul bl; mov xloc, ax
    mov xloc, ax
    mov al, [PauseMainRow]
    mov bl, PixelsPerChar
    mul bl; add ax, PixelsPerChar; mov yloc, ax
    add ax, PixelsPerChar
    mov yloc, ax
    mov ax, 9; "MAIN MENU" length
    mov bl, PixelsPerChar
    mul bl; mov wid, ax
    mov wid, ax
    jmp DrawNewSel_SMP

QuickResumeHandler_SMP_Action:
    mov byte ptr [pauseOpt], 1
    ; Fall through

PauseOptSelected_SMP_Action:
    call deleteSelect       ; Delete underline BAGO mag-clear/mag-action

    cmp byte ptr [pauseOpt], 1
    jne GoToMainMenu_SMP_Path

    ; RESUME Path
    call clearPauseMenu     ; Burahin ang pause menu graphics at i-redraw ang game
    mov isPaused, 0
    jmp ExitShowPauseMenu_SMP   ; Direktang exit para bumalik sa game loop

GoToMainMenu_SMP_Path:
    ; MAIN MENU Path
    ; Hindi na kailangan i-call ang clearPauseMenu dito kasi ang StartPage magse-setVideoMode
    mov isPaused, 0
    mov begin, 0            ; Mahalaga para ang gameLoop ay huminto at makabalik sa StartPage flow
    call StartPage
    ; After StartPage returns (e.g. user exits game), then we exit showPauseMenu

ExitShowPauseMenu_SMP:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
showPauseMenu endp

clearPauseMenu proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ; --- 1. Erase the Pause Menu Box and Text Area by drawing a black rectangle ---
    ;    Gagamitin natin yung pauseBoxX, Y, W, H.
    mov di, [pauseBoxY]     ; Start Y
    local endY_CPM:word     ; CPM for ClearPauseMenu
    mov ax, [pauseBoxY]
    add ax, [pauseBoxH]
    mov endY_CPM, ax        ; End Y

ClearFillLoop_CPM:
    cmp di, endY_CPM
    jge DoneClearingBox_CPM

    mov ax, [pauseBoxX]
    mov xlocRec, ax
    mov ylocRec, di         ; Current Y row
    mov ax, [pauseBoxW]
    mov widRec, ax
    mov heightRec, 1
    mov color, 0            ; COLOR BLACK to erase
    call AddRec

    inc di
    jmp ClearFillLoop_CPM
DoneClearingBox_CPM:

    ; --- 2. CRITICAL: Redraw all active game elements ---
    call BuildB             ; Redraw all bricks (kung nagbabago sila, or just the visible ones)
    redrawStriker 13
    redrawBall 15           ; Redraw ball at its current position
    call printName          ; Kung naka-display ang pangalan habang naglalaro

    cmp gamemode, 0         ; Check game mode
    je RedrawLives_CPM      ; If level mode, redraw lives
    call printTime          ; If timed mode, redraw timer (uses timer_color)
    jmp EndRedraw_CPM

RedrawLives_CPM:
    call drawLives
EndRedraw_CPM:

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clearPauseMenu endp






; ----------------------------------------
;                 Score
; ----------------------------------------
DrawScores proc
    push dx
    push ax
       
	;---prints "Time Consumed:" text 
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 0Ch
    int 10h
    
    lea dx, score_text
    mov ah, 09h
    int 21h
    
    call printScore                       ;prints score after the text 

    pop ax
    pop dx
    ret
DrawScores endp

computeScore proc
    push ax
    push bx
    push cx
    push dx

    mov al, tens    ; Load ASCII char from tens (DB)
    sub al, '0'     ; Convert to numeric value (e.g., '5' -> 5)
    mov bl, al      ; Store numeric tens digit in BL

    ; Your logic for calculating score based on '5 - tens_digit'
    mov ax, 5       ; Or whatever your base for tens calculation is
    sub al, bl      ; AL = base - (numeric tens digit)
    cbw             ; Extend AL to AX

    mov bl, 10
    mul bl          ; AX = AL * BL
    mov timeScore, ax ; timeScore is dw, AX is word -> OK

    mov al, ones    ; Load ASCII char from ones (DB)
    sub al, '0'     ; Convert to numeric value
    mov bl, al      ; Store numeric ones digit in BL

    ; Your logic for calculating score based on '10 - ones_digit' (or similar)
    mov ax, 10      ; Or whatever your base for ones calculation is
    sub al, bl      ; AL = base - (numeric ones digit)
    cbw             ; Extend AL to AX

    add timeScore, ax ; Add to existing timeScore (dw) -> OK

    pop dx
    pop cx
    pop bx
    pop ax
    ret
computeScore endp

printScore proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0                             ;sets cx to 0
    mov ax, timeScore                     ;moves the value of timeScore to ax
	
    fetch:                              
		mov bx, 10                        ;sets bx to 10
		mov dx, 0                         ;sets dx to 0 
		div bx                            ;divides the value of ax to bx, stores the quotient in ax, and the remainder in dx
		push dx                           ;pushes the value of dx (remainder) to the stack 
		inc cx                            ;increments cx (ctr for print loop) 
		cmp ax, 0                         ;checks if ax=0
		jne fetch                         ;if not, jump to fetch 
    
    print:                              
		pop dx                            ;pops the top of the stack
		mov ah, 02h                       ;char output instruction 
		add dl, '0'                       ;adds 48 (ASCII of 0) to the value of dx to ensure that the number will be printed 
		int 21h
		loop print                        ;loops to print until cx is 0
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
printScore endp


; ----------------------------------------
;            Game Result Page
; ----------------------------------------
GameCompletedPage proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	
	;---prints "YOU DID IT!" text 
	drawTitle 67, 24, 5, 19, 13         ;draw Y
    drawTitle 73, 37, 13, 6, 13
    drawTitle 87, 24, 5, 19, 13
    drawTitle 77, 44, 6, 13, 13 
	
	drawTitle 98, 24, 6, 33, 13          ;draw O
    drawTitle 115, 24, 4, 33, 13
    drawTitle 120, 24, 0, 32, 13
    drawTitle 105, 24, 9, 6, 13
    drawTitle 105, 52, 9, 5, 13

	drawTitle 127, 24, 6, 33, 13         ;draw U
    drawTitle 144, 24, 6, 33, 13
    drawTitle 127, 52, 23, 6, 13
	
	drawTitle 168, 24, 5, 33, 13         ;draw D
    drawTitle 174, 24, 14, 6, 13
    drawTitle 174, 52, 14, 5, 13
    drawTitle 184, 28, 6, 27, 13  
	
	drawTitle 197, 24, 23, 6, 13         ;draw I
    drawTitle 197, 52, 23, 5, 13
    drawTitle 206, 31, 6, 20, 13
	
	drawTitle 227, 24, 5, 33, 13         ;draw D
    drawTitle 233, 24, 14, 6, 13
    drawTitle 233, 52, 14, 5, 13
    drawTitle 243, 28, 6, 27, 13 
	
	drawTitle 130, 67, 23, 6, 13         ;draw I
    drawTitle 130, 94, 23, 5, 13
    drawTitle 139, 73, 6, 20, 13 
	
	drawTitle 159, 67, 26, 6, 13         ;draw T
    drawTitle 169, 74, 6, 25, 13
	
	drawTitle 191, 67, 6, 23, 13         ;draw !
    drawTitle 191, 94, 6, 5, 13
	
	mov ah, 02h
    mov bh, 00h
    mov dh, 11h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, nextlevel_text
    int 21h
	
	no_next:
	mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 10h
    int 10h
    
    mov ah, 09h
    lea dx, mainmenu_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 15h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, exit_text
    int 21h
    
	call drawTrophy                       ;draws trophy on the screen 
	
	;---sets variables to required values---
	mov xloc, 145
	mov yloc, 145
	mov wid, 25
    call drawSelect
	
	cmp gamemode, 1                       ;checks if timed mode is chosen 
	jne congratulations                   ;if not, jump to congratulations 
	
	call computeScore                     ;computes the score for timed mode  
	call DrawScores                       ;draws the score on the screen 
	jmp selectCompleted
	
	;---if level mode is chosen--- 
	congratulations:
		call message                      ;prints the congratulatory message 
	
	;---checks which menu option is selected---
	selectCompleted:
		mov ah, 00h                
		int 16h
		cmp soundOn, 1
		jne noSound5
		call beep
		
		noSound5:
		cmp ax, 4800h                     ;up-arrow key 
		je upCompleted
		cmp ax, 5000h                     ;down-arrow key
		je downCompleted
		cmp ax, 1C0Dh                     ;enter key
		je selectedCompleted
		
		downCompleted:
			cmp optCompleted, 3            
			je backCompleted
			
			add optCompleted, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectCompleted
		
		upCompleted:
			cmp optCompleted, 1
			je nextCompleted
			
			sub optCompleted, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectCompleted
			
		backCompleted:
			mov optCompleted, 1
			call deleteSelect
			mov yloc, 145          
			call drawSelect
			jmp selectCompleted
		
		nextCompleted:
			mov optCompleted, 3
			call deleteSelect
			mov yloc, 177          
			call drawSelect
			jmp selectCompleted
		
	selectedCompleted:
		cmp optCompleted, 1
		je nextLevel1
		cmp optCompleted, 2
		je backMain
		cmp optCompleted, 3
		je quit

	nextLevel1:
		call playNext                     ;prepares the next level
		ret

	backMain:
		call StartPage                    ;goes to the main menu 
		ret
		
	quit:
		call setVideoMode                 ;terminates the program 
		mov ah, 4Ch
		int 21h
		
	pop ax 
	pop bx
	pop dx
	ret
GameCompletedPage endp

message proc
	push dx
    push ax
    
	;---prints "Congratulations, [player's name]" text 
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 09h
    int 10h
    
    lea dx, congratulations_text
    mov ah, 09h
    int 21h
    
    mov ah, 02h
	mov dh, 0Eh 
    mov dl, 12h
    int 10h
    
    lea dx, playername
    mov ah, 09h
    int 21h

    pop ax
    pop dx
	ret 
message endp 

drawTrophy proc
	mov cx, 20                            ;x-location of trophy 
	mov dx, 130                           ;y-loc 
	mov si, offset trophy                 ;sets source to the offset of trophy
	
	;---prints the trophy on the screen pixel by pixel---
	drawTrophy1:
		mov ah, 0Ch 
		mov al, [si]
		mov bh, 00h
		int 10h
		
		inc si 
		inc cx 
		mov ax, cx
		sub ax, 20
		cmp ax, 50
		jne drawTrophy1 
		
		mov cx, 20
		inc dx
		mov ax, dx
		sub ax, 130
		cmp ax, 50
		jne drawTrophy1 
	ret 
drawTrophy endp 

GameOverPage proc
	push ax
	push bx
	push dx
	
	call setVideoMode
	call drawBorder
	call drawBg
	  
	drawTitle 91, 32, 30, 6, 5            ;draw G 
	drawTitle 115, 38, 6, 6, 5  
	drawTitle 91, 38, 6, 35, 5  
	drawTitle 97, 67, 25, 6, 5  
	drawTitle 107, 53, 15, 6, 5  
	drawTitle 116, 59, 6, 8, 5  

    drawTitle 127, 32, 6, 41, 5           ;draw A 
    drawTitle 133, 32, 18, 6, 5  
	drawTitle 152, 32, 6, 41, 5  
	drawTitle 133, 50, 18, 6, 5  

    drawTitle 163, 32, 6, 41, 5           ;draw M 
    drawTitle 169, 32, 18, 6, 5  
	drawTitle 175, 38, 6, 18, 5  
	drawTitle 188, 32, 6, 41, 5  

    drawTitle 199, 32, 6, 41, 5           ;draw E 
    drawTitle 205, 32, 25, 6, 5  
	drawTitle 205, 49, 22, 6, 5  
	drawTitle 205, 67, 25, 6, 5  
  
    drawTitle 91, 78, 6, 41, 5            ;draw O 
    drawTitle 97, 78, 19, 6, 5  
	drawTitle 116, 78, 6, 41, 5  
	drawTitle 97, 113, 19, 6, 5  

    drawTitle 127, 78, 6, 35, 5           ;draw V 
    drawTitle 152, 78, 6, 35, 5  
	drawTitle 133, 113, 19, 6, 5  

    drawTitle 163, 78, 6, 41, 5           ;draw E 
    drawTitle 169, 78, 25, 6, 5  
	drawTitle 169, 95, 22, 6, 5  
	drawTitle 169, 113, 25, 6, 5  

    drawTitle 199, 78, 6, 41, 5           ;draw R
    drawTitle 205, 78, 19, 6, 5  
	drawTitle 205, 94, 19, 6, 5  
	drawTitle 224, 84, 6, 10, 5  
	drawTitle 224, 100, 6, 18, 5  
	
	mov ah, 02h
    mov bh, 00h
    mov dh, 13h
    mov dl, 10h
    int 10h
    
    mov ah, 09h
    lea dx, mainmenu_text
    int 21h
    
    mov ah, 02h
    mov bh, 00h
    mov dh, 15h
    mov dl, 12h
    int 10h
    
    mov ah, 09h
    lea dx, exit_text
    int 21h
    
	;---sets variables to required values--- 
	mov xloc, 145
	mov yloc, 161
	mov wid, 25
    call drawSelect
	
	;---checks which menu optionis selected---
	selectOver:
		mov ah, 00h                ;read keyboard input
		int 16h
		cmp soundOn, 1
		jne noSound6
		call beep
		
		noSound6:
		cmp ax, 4800h              ;up arrow key 
		je upOver
		cmp ax, 5000h              ;down arrow key
		je downOver
		cmp ax, 1C0Dh              ;enter key
		je selectedOver
		
		downOver:
			cmp optOver, 2             ;4 -> number of buttons, varies
			je backOver
			
			add optOver, 1
			call deleteSelect
			add yloc, 16           
			call drawSelect
			jmp selectOver
		
		upOver:
			cmp optOver, 1
			je nextOver
			
			sub optOver, 1
			call deleteSelect
			sub yloc, 16
			call drawSelect
			jmp selectOver 
			
		backOver:
			mov optOver, 1
			call deleteSelect
			mov yloc, 161          ;129 -> y location of first underline, varies
			call drawSelect
			jmp selectOver
		
		nextOver:
			mov optOver, 2
			call deleteSelect
			mov yloc, 177          ;177 -> y location of last underline, varies
			call drawSelect
			jmp selectOver
		
	selectedOver:
		cmp optOver, 1
		je backMain1
		cmp optOver, 2
		je quit1

	backMain1:
		call StartPage              
		ret
		
	quit1:
		call setVideoMode
		mov ah, 4Ch
		int 21h
		
	pop ax 
	pop bx
	pop dx
	ret
GameOverPage endp


; ----------------------------------------
;                 Misc
; ----------------------------------------
setVideoMode proc
    ;---sets video mode to VGA---
	mov ah, 00h                              
    mov al, 13h 
    int 10h     
    
	;---sets background color to black---
	mov ah, 0Bh                           ;sets background color to black 
	mov bh, 13h
	mov bl, 00h
	int 10h
	
    ret
setVideoMode endp

AddRec proc
	mov cx, xlocRec                       ;moves the value of xlocRec (based on the drawTitle macro) to cx 
	mov dx, ylocRec                       ;moves the valueof ylocRec to dx 
	
	drawLoopRec:
		mov ah, 0Ch                       
		mov al, color                     ;sets the color of the pixel based on the argument passed to drawTitle 
		mov bh, 00h                      
		int 10h

		inc cx
		mov ax, cx
		sub ax, xlocRec
		cmp ax, widRec
		jng drawLoopRec
		
		mov cx, xlocRec
		inc dx
		
		mov ax, dx
		sub ax, ylocRec
		cmp ax, heightRec
		jng drawLoopRec
	ret
AddRec endp

drawSelect proc
	;---draws the underline---
	mov cx, xloc
	mov dx, yloc
	
	drawLoop:
		mov ah, 0Ch
		mov al, 0Dh                       ;color -> light magenta
		mov bh, 00h
		int 10h

		inc cx
		mov ax, cx
		sub ax, xloc
		cmp ax, wid
		jng drawLoop
	ret
drawSelect endp

deleteSelect proc
	;---draws the underline in black to make it invisible--- 
	mov cx, xloc
	mov dx, yloc
	
	drawLoop1:
		mov ah, 0Ch
		mov al, 00h
		mov bh, 00h
		int 10h

		inc cx
		mov ax, cx
		sub ax, xloc
		cmp ax, wid
		jng drawLoop1
	ret
deleteSelect endp

drawBoundary proc
    mov color, 07h             ; Sets the color to light gray

    ;---top---
    mov startx, 22
    mov endx, 300
    mov starty, 22
    mov endy, 23               ; Draws y=22 from x=22 to x=299
    call draw

    ;---right---
    mov startx, 299
    mov endx, 300              ; Draws x=299 from y=22 to y=179
    mov starty, 22
    mov endy, 180
    call draw

    ;---left---
    mov startx, 22
    mov endx, 23               ; Draws x=22 from y=22 to y=179
    mov starty, 22
    mov endy, 180
    call draw

    ;---bottom---
    mov startx, 22
    mov endx, 300
    mov starty, 179            ; Draws y=179 from x=22 to x=299
    mov endy, 180
    call draw

    ret
drawBoundary endp

drawBorder proc
	;---draws pixels outside of the border---
	drawTitle 17, 9, 0, 0, 05h
	drawTitle 60, 10, 0, 0, 05h
	drawTitle 95, 15, 0, 0, 05h
	drawTitle 131, 11, 0, 0, 05h
	drawTitle 167, 10, 0, 0, 05h
	drawTitle 247, 17, 0, 0, 05h
	drawTitle 7, 46, 0, 0, 05h
	drawTitle 11, 82, 0, 0, 05h
	drawTitle 13, 137, 0, 0, 05h
	drawTitle 7, 177, 0, 0, 05h
	drawTitle 39, 191, 0, 0, 05h
	drawTitle 74, 194, 0, 0, 05h
	drawTitle 164, 185, 0, 0, 05h
	drawTitle 217, 190, 0, 0, 05h
	drawTitle 277, 195, 0, 0, 05h
	drawTitle 315, 193, 0, 0, 05h
	drawTitle 309, 163, 0, 0, 05h
	drawTitle 302, 139, 0, 0, 05h
	drawTitle 313, 91, 0, 0, 05h
	drawTitle 306, 57, 0, 0, 05h
	drawTitle 39, 11, 0, 0, 0Fh
	drawTitle 112, 8, 0, 0, 0Fh
	drawTitle 205, 12, 0, 0, 0Fh
	drawTitle 279, 9, 0, 0, 0Fh
	drawTitle 311, 26, 0, 0, 0Fh
	drawTitle 306, 105, 0, 0, 0Fh
	drawTitle 296, 187, 0, 0, 0Fh
	drawTitle 144, 193, 0, 0, 0Fh
	drawTitle 95, 186, 0, 0, 0Fh
	drawTitle 7, 112, 0, 0, 0Fh
	ret
drawBorder endp

drawBg proc
	;---draws pixels inside the border---
	drawTitle 55, 43, 0, 0, 05h
	drawTitle 186, 51, 0, 0, 05h
	drawTitle 265, 58, 0, 0, 05h
	drawTitle 73, 94, 0, 0, 05h
	drawTitle 135, 87, 0, 0, 05h
	drawTitle 59, 130, 0, 0, 05h
	drawTitle 249, 122, 0, 0, 05h
	drawTitle 103, 154, 0, 0, 05h
	drawTitle 161, 140, 0, 0, 05h
	drawTitle 258, 163, 0, 0, 05h
	drawTitle 105, 52, 0, 0, 0Fh
	drawTitle 152, 45, 0, 0, 0Fh
	drawTitle 245, 51, 1, 1, 0Fh
	drawTitle 45, 69, 1, 1, 0Fh
	drawTitle 200, 98, 0, 0, 0Fh
	drawTitle 277, 101, 0, 0, 0Fh
	drawTitle 95, 114, 0, 0, 0Fh
	drawTitle 60, 166, 0, 0, 0Fh
	drawTitle 139, 152, 1, 1, 0Fh
	drawTitle 218, 151, 0, 0, 0Fh
	ret 
drawBg endp

draw proc
    push ax
    push cx
    push dx
     
	mov cx, startx                        ;starts drawing element from startx
    mov dx, starty                        ;starts drawing element from starty
    mov ah, 0Ch                           ;draw pixel instruction 
    mov al, color
	
    pixel:                              
		inc cx                            ;increments the x-loc of the element 
		int 10h                           ;draws the pixel 
		cmp cx, endx                      ;checks if the current x-loc value reaches the defined endx 
		jne pixel                         ;if not, loop pixel 

		mov cx, startx                    ;resets x-loc to the defined startx 
		inc dx                            ;sets the cursor to the next line/row 
		cmp dx, endy                      ;checks if the current y-loc value reaches the defined endy
		jne pixel                         ;if not, loop pixel
    
    pop dx
    pop cx
    pop ax
    ret
draw endp

sleep proc
	mov cx, 111111111111111b              ;sets counter for continuous loop

	l:
		loop l
		ret
sleep endp

beep proc
    push ax
    push bx
    push cx
    push dx
		
        mov al, 182                       ;sets al to 182
        out 43h, al                       ;sends the value of al to port 43h
        mov ax, 400                       ;sets ax to 400 
                                
        out 42h, al                       ;sends the lower bits of ax to port 42h 
        mov al, ah                        ;moves the higher bits to al
        out 42h, al                       ;sends the bits to port 42h 
        in al, 61h                        ;reads input from port 16 and stores it in al 
                                
        or al, 00000011b                  ;enables speaker output 
        out 61h, al                       ;sends the value of al to port 61h
        mov bx, 2                         ;sets loop ctr 
		
	.pause1:
        mov cx, 65535                     ;sets cx to the max number of a 16-bit register 
		
	.pause2:
        dec cx                            ;decrements cx 
        jne .pause2                       ;if cx!=0, kump to pause2 
        dec bx                            ;decrements bx 
        jne .pause1                       ;if bx!=0, jump to pause1 
        in al, 61h                        ;reads input from port 61h and stores it in al 
                                
        and al, 11111100b                 ;disables the speaker output 
        out 61h, al                       ;sends the value of al to port 61h

    pop dx
    pop cx
    pop bx
    pop ax

	ret
beep endp
end main