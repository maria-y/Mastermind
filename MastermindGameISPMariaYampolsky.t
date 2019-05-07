%June 11th, 2018
%Maria Yampolsky
%Ms. Krasteva
%This program allows the user to play the game Mastermind, a colour patterning game.

%Set screen up
import GUI
setscreen ("offscreenonly")
setscreen ("noecho")


%Forwarding Necessary Procedures
forward proc drawGameBoard
forward proc mainMenu
forward proc userInput
forward proc instructions
forward proc check
forward proc error

%Declaration Section
var instructionsWin, inputOutputWin, errorWin : int := 0 %Windows to be defined further on
var playButton, instructButton, exitButton, checkButton : int := 0 %Buttons to be defined further on
var mainWin := Window.Open ("position: 500;400, graphics:600;400")
var menuButton : int := GUI.CreateButton (250, 5, 0, "Main Menu", mainMenu)
var myFont : int := Font.New ("Magneto:26")
var mouseYposition, mouseXposition, button : int %mouse control variables
var colourOptionsNum, triesNum : int := 0
var correctColours, guessColours : array 1 .. 4 of int %array that will hold correct values and array that will hold inputted guess values
var backgroundColour : int 

%Title
procedure title
    colourback (backgroundColour)
    cls
    Font.Draw ("Mastermind", maxx div 2 - 118, maxy - 25, myFont, 107)
    Font.Draw ("Mastermind", maxx div 2 - 115, maxy - 25, myFont, 58)
end title

%Pause Program to be used to exit error message
procedure pauseProgram
    var reply : string (1)
    put "Press any key to continue..."..
    getch (reply)
end pauseProgram

%Creates random colour sequence that is four colours long
procedure randomColour
    triesNum:=0
    for i : 1 .. 4
	correctColours (i) := Rand.Int (1, colourOptionsNum)
	%number of colours to choose form changes depending on user's choice (colourOptionsNum)
	if correctColours (i) = 1 then
	    correctColours (i) := 12 %red
	elsif correctColours (i) = 2 then
	    correctColours (i) := 42 %orange
	elsif correctColours (i) = 3 then
	    correctColours (i) := 46 %light green
	elsif correctColours (i) = 4 then
	    correctColours (i) := 126 %dark blue
	elsif correctColours (i) = 5 then
	    correctColours (i) := 34 %purple
	elsif correctColours (i) = 6 then
	    correctColours (i) := 38 %pink
	elsif correctColours (i) = 7 then
	    correctColours (i) := 120 %green
	elsif correctColours (i) = 8 then
	    correctColours (i) := 21 %grey
	elsif correctColours (i) = 9 then
	    correctColours (i) := 53 %light blue
	elsif correctColours (i) = 10 then
	    correctColours (i) := 0 %white
	end if
    end for
    if correctColours (1) = correctColours (2) or correctColours (1) = correctColours (3) or correctColours (1) = correctColours (4) or correctColours (2) = correctColours (3) or correctColours (2) = correctColours (4) or correctColours (3) = correctColours (4) then
	randomColour %does not allow for duplicates in the pattern
    end if
end randomColour


%Introduction
procedure introduction
    GUI.Hide (menuButton) %hides menu button

    %loading screen
    for i : 0 .. maxx
	drawbox (0, 0, i, maxy, 80)
    end for
    for i : 1 .. 200
	drawfillarc (300, 200, 25, 25, 0 + i, 120 + i, 34)
	drawfillarc (300, 200, 25, 25, 120 + i, 240 + i, 35)
	drawfillarc (300, 200, 25, 25, 240 + i, 360 + i, 33)
	drawfilloval (300, 200, 15, 15, 80)
	View.Update
	delay (5)
    end for

    %Introduction to game
    backgroundColour := 67
    title
    locate (4, 25)
    put "Welcome to Mastermind, the original colour"
    put "" : 24, "patterning game! Test your ability to crack"
    put "" : 24, "the colour code that is randomly created by"
    put "" : 24, "the computer. Use your problem-solving skills"
    put "" : 24, "to get through all three levels of difficulty:"
    put "" : 24, "six, eight or even ten colours to choose from!"
    put ""
    put ""
    put "" : 24, "Who knew logic puzzles could be so fun?"

    %purple lines on the right
    for i : 1 .. 10
	drawbox (590, 10, 162, 10 + i, 82)
	drawbox (590, 10, 590 - i, 500, 82)
    end for

    %drawing game board on the left side
    for i : 1 .. 340
	drawbox (25, 10, 161, 10 + i, 114) %brown box
	drawbox (4, 10, 24, 10 + i, 26) %grey box
    end for

    for x : 0 .. 3
	for y : 0 .. 9
	    for i : 0 .. 16
		drawoval (42 + 34 * x, 27 + 34 * y, i, i, 139) %brown circles
		drawoval (41 + 34 * x, 27 + 34 * y, i, i, 139) %brown circles
		drawoval (42 + 34 * x, 26 + 34 * y, i, i, 139) %brown circles
	    end for
	end for
    end for

    for i : 1 .. 340 by 34 %grey circles
	for x : 1 .. 3
	    drawoval (9, 32 + i, x, x, 28)
	    drawoval (9, 22 + i, x, x, 28)
	    drawoval (19, 32 + i, x, x, 28)
	    drawoval (19, 22 + i, x, x, 28)
	end for
    end for

    for i : 0 .. 9 %coloured circles animation
	drawfilloval (42, 26 + i * 34, 14, 14, 12 + i mod 2 * 9)
	delay (150)
	drawfilloval (76, 26 + i * 34, 14, 14, 42 + i mod 2 * 4)
	delay (150)
	drawfilloval (110, 26 + i * 34, 14, 14, 120 + i mod 2 * 6)
	delay (150)
	drawfilloval (144, 26 + i * 34, 14, 14, 38 + i mod 2 * 15)
	delay (150)
    end for
    GUI.Show (menuButton) %allows user to access main menu
end introduction

%Main Menu (allows user to navigate game)
body procedure mainMenu
    triesNum := 10
    Window.Hide (instructionsWin) % hides instructions window
    Window.Hide (inputOutputWin) % hides the window where game play occurs
    Window.Show (mainWin) %shows the main window
    GUI.Dispose (menuButton) %removes button that allows user to access main menu
    backgroundColour := 89
    title
    for i : 0 .. 350 by 12
	drawline (600, 350 - i, 0, 120 + i, white) %white lines for the game's aesthetic
    end for
    for i : 1 .. 140
	drawbox (230, 310, 230 + i, 150, 82) %purple box on to which buttons are drawn
    end for

    %creates buttons
    playButton := GUI.CreateButton (250, 270, 100, "Play Game", drawGameBoard)
    instructButton := GUI.CreateButton (250, 220, 100, "Instructions", instructions)
    exitButton := GUI.CreateButton (250, 170, 100, "Exit", GUI.Quit)
end mainMenu


%This procedure sets up the game
body procedure drawGameBoard
    Window.Hide (mainWin) %hides the main window

    %allows user to choose how many colours to choose from
    var selectColourNumWin : int := Window.Open ("position: 500;400, graphics:250;200")
    backgroundColour := 67
    title
    colourOptionsNum := 0
    locate (3, 1)
    put "" : 7, "Select one of the"
    put "" : 3, "following boxes to choose"
    put "" : 4, "how many colour options"
    put "" : 3, "you want in your game."
    put "" : 1, "Remember, the more options,"
    put "" : 4, "the tougher it will be!"
    for i : 1 .. 40
	drawbox (45, 20, 85, 20 + i, blue)
	drawbox (105, 20, 145, 20 + i, blue)
	drawbox (165, 20, 205, 20 + i, blue)
    end for
    Font.Draw ("6", 53, 30, myFont, 0) %if clicked, user will have six colours to choose from
    Font.Draw ("8", 113, 30, myFont, 0) %if clicked, user will have eight colours to choose from
    Font.Draw ("10", 164, 30, myFont, 0) %if clicked, user will have ten colours to choose from
    loop
	mousewhere (mouseXposition, mouseYposition, button) %mouse commands decide which box user clicked colour number selected
	if button = 1 then
	    if (mouseXposition > 44 and mouseXposition < 86) and (mouseYposition > 19 and mouseYposition < 61) then
		colourOptionsNum := 6
	    elsif (mouseXposition > 104 and mouseXposition < 146) and (mouseYposition > 19 and mouseYposition < 61) then
		colourOptionsNum := 8
	    elsif (mouseXposition > 164 and mouseXposition < 206) and (mouseYposition > 19 and mouseYposition < 61) then
		colourOptionsNum := 10
	    end if
	end if
	exit when colourOptionsNum > 0 %loop is exited when this variable is given a value, which will be either six, eight or ten
    end loop
    Window.Close (selectColourNumWin) %closes small window that was used to make that decision

    randomColour %random colour pattern is created
    inputOutputWin := Window.Open ("position: 500;300, graphics:500;550") %window on which game play occurs is created
    title
    for i : 1 .. 510
	drawbox (25, 10, 246, 10 + i, 114) %draws brown game board
	drawbox (4, 10, 24, 10 + i, 26) %draws grey rectangle
    end for
    for i : 1 .. 510 by 51
	for x : 1 .. 4
	    drawoval (9, 30 + i, x, x, 28) %draws grey circles where red and white check circles will be outputted
	    drawoval (9, 40 + i, x, x, 28)
	    drawoval (19, 30 + i, x, x, 28)
	    drawoval (19, 40 + i, x, x, 28)
	end for
    end for
    for i : 0 .. 200 by 55
	for j : 0 .. 509 by 51
	    for x : 1 .. 24
		drawoval (52 + i, 35 + j, x, x, 139) %draws big brown circles
		drawoval (51 + i, 35 + j, x, x, 139) %draws big brown circles
		drawoval (52 + i, 34 + j, x, x, 139) %draws big brown circles
	    end for
	end for
    end for

    %draws colours that can be selected by user
    for i : 1 .. 22
	drawoval (275, 86, i, i, 12)
	drawoval (274, 86, i, i, 12)
	drawoval (275, 85, i, i, 12)
	drawoval (325, 86, i, i, 42)
	drawoval (324, 86, i, i, 42)
	drawoval (325, 85, i, i, 42)
	drawoval (375, 86, i, i, 46)
	drawoval (374, 86, i, i, 46)
	drawoval (375, 85, i, i, 46)
	drawoval (275, 136, i, i, 126)
	drawoval (274, 136, i, i, 126)
	drawoval (275, 135, i, i, 126)
	drawoval (325, 136, i, i, 34)
	drawoval (324, 136, i, i, 34)
	drawoval (325, 135, i, i, 34)
	drawoval (375, 136, i, i, 38)
	drawoval (374, 136, i, i, 38)
	drawoval (375, 135, i, i, 38)
    end for
    %draws colours that can be selected by user if they chose 8 or 10 colours options
    if colourOptionsNum > 6 then
	for i : 1 .. 22
	    drawoval (425, 86, i, i, 120)
	    drawoval (424, 86, i, i, 120)
	    drawoval (425, 85, i, i, 120)
	    drawoval (425, 136, i, i, 21)
	    drawoval (424, 136, i, i, 21)
	    drawoval (425, 135, i, i, 21)
	end for
	%draws colours that can be selected by user if they chose 10 colours options
	if colourOptionsNum > 8 then
	    for i : 1 .. 22
		drawoval (475, 86, i, i, 53)
		drawoval (474, 86, i, i, 53)
		drawoval (475, 85, i, i, 53)
		drawoval (475, 136, i, i, 0)
		drawoval (474, 136, i, i, 0)
		drawoval (475, 135, i, i, 0)
	    end for
	end if
    end if
    %creates buttons that will be during game play
    menuButton := GUI.CreateButton (250, 10, 0, "Main Menu", mainMenu) %button to return to main menu
    checkButton := GUI.CreateButton (260, 490, 0, "Check", check) %button to check colour pattern
    for i : 1 .. 221
	drawbox (25, 10 + triesNum * 51, 25 + i, 60 + triesNum * 51, 57)     %draws purple box indicating which row user is on
    end for
    for i : 0 .. 200 by 55
	for x : 1 .. 24
	    drawoval (52 + i, 35 + triesNum * 51, x, x, 139) % re-draws big brown circles
	    drawoval (51 + i, 35 + triesNum * 51, x, x, 139) % re-draws big brown circles
	    drawoval (52 + i, 34 + triesNum * 51, x, x, 139) % re-draws big brown circles
	end for
    end for
    %loops user input
    loop
	userInput
	View.Update
	exit when GUI.ProcessEvent
    end loop
end drawGameBoard

%Button Sound to Play When Clicked
process ButtonSound
    Music.PlayFile ("ButtonClick.mp3")
end ButtonSound

%User Input Procedure - Allows user to enter guesses
body procedure userInput
    var finished : boolean := false
    mousewhere (mouseXposition, mouseYposition, button) %will work , becauseentire procedure is being looped
    if button = 1 and whatdotcolour (mouseXposition, mouseYposition) not= 57 and triesNum < 10 then %when something that isn't the box is clicked, so only the circles can be selected
	button := 0   
	if (mouseXposition > 27 and mouseXposition < 77) and (mouseYposition > 10 + triesNum * 51 and mouseYposition < 60 + triesNum * 51) then %1st position
	    drawoval (52, 35 + triesNum * 51, 24, 24, yellow) %selects circle with yellow
	    drawoval (52, 35 + triesNum * 51, 23, 23, yellow)
	    fork ButtonSound %plays click sound
	    %loop during which colour is selected
	    loop
		mousewhere (mouseXposition, mouseYposition, button)
		if button = 1 and (mouseXposition > 252 and mouseXposition < 498) and (mouseYposition > 63 and mouseYposition < 159) and whatdotcolour (mouseXposition, mouseYposition) not= 67 %checks that user clicked in the area of the colour circles and did not click the background
			then
		    guessColours (1) := whatdotcolour (mouseXposition, mouseYposition) %choosing guess colour for the first position
		    for i : 1 .. 22
			drawoval (52, 35 + triesNum * 51,i, i, guessColours (1))
			drawoval (51, 35 + triesNum * 51, i, i, guessColours (1))
			drawoval (52, 34 + triesNum * 51, i, i, guessColours (1))
		    end for
		    drawoval (52, 35 + triesNum * 51, 24, 24, 139) %de-selects circle with brown
		    drawoval (52, 35 + triesNum * 51, 23, 23, 139)
		    finished := true
		end if
		exit when finished
	    end loop
	elsif (mouseXposition > 82 and mouseXposition < 132) and (mouseYposition > 10 + triesNum * 51 and mouseYposition < 60 + triesNum * 51) then %2nd position
	    drawoval (107, 35 + triesNum * 51, 24, 24, yellow)  %selects circle with yellow
	    drawoval (107, 35 + triesNum * 51, 23, 23, yellow)
	    fork ButtonSound %plays click sound
	    %loop during which colour is selected
	    loop
		mousewhere (mouseXposition, mouseYposition, button)
		if button = 1 and (mouseXposition > 252 and mouseXposition < 498) and (mouseYposition > 63 and mouseYposition < 159) and whatdotcolour (mouseXposition, mouseYposition) not= 67 %checks that user clicked in the area of the colour circles and did not click the background
			then
		    guessColours (2) := whatdotcolour (mouseXposition, mouseYposition) %choosing guess colour for the second position
		    for i : 1 .. 22
			drawoval (107, 35 + triesNum * 51, i, i, guessColours (2))
			drawoval (106, 35 + triesNum * 51, i, i, guessColours (2))
			drawoval (107, 34 + triesNum * 51, i, i, guessColours (2))
		    end for
		    drawoval (107, 35 + triesNum * 51, 24, 24, 139)%de-selects circle with brown
		    drawoval (107, 35 + triesNum * 51, 23, 23, 139)
		    finished := true
		end if
		exit when finished 
	    end loop
	elsif (mouseXposition > 137 and mouseXposition < 187) and (mouseYposition > 10 + triesNum * 51 and mouseYposition < 60 + triesNum * 51) then %3rd position
	    drawoval (162, 35 + triesNum * 51, 24, 24, yellow)  %selects circle with yellow
	    drawoval (162, 35 + triesNum * 51, 23, 23, yellow)
	    fork ButtonSound %plays click sound
	    %loop during which colour is selected
	    loop
		mousewhere (mouseXposition, mouseYposition, button)
		if button = 1 and (mouseXposition > 252 and mouseXposition < 498) and (mouseYposition > 63 and mouseYposition < 159) and whatdotcolour (mouseXposition, mouseYposition) not= 67 %checks that user clicked in the area of the colour circles and did not click the background
			then
		    guessColours (3) := whatdotcolour (mouseXposition, mouseYposition) %choosing guess colour for the third position
		    for i : 1 .. 22
			drawoval (162, 35 + triesNum * 51, i, i, guessColours (3))
			drawoval (161, 35 + triesNum * 51, i, i, guessColours (3))
			drawoval (162, 34 + triesNum * 51, i, i, guessColours (3))
		    end for
		    drawoval (162, 35 + triesNum * 51, 24, 24, 139)%de-selects circle with brown
		    drawoval (162, 35 + triesNum * 51, 23, 23, 139)
		    finished := true
		end if
		exit when finished
	    end loop
	elsif (mouseXposition > 192 and mouseXposition < 242) and (mouseYposition > 10 + triesNum * 51 and mouseYposition < 60 + triesNum * 51) then %4th position
	    drawoval (217, 35 + triesNum * 51, 24, 24, yellow) %selects circle with yellow
	    drawoval (217, 35 + triesNum * 51, 23, 23, yellow)
	    fork ButtonSound %plays click sound
	    %loop during which colour is selected
	    loop
		mousewhere (mouseXposition, mouseYposition, button)
		if button = 1 and (mouseXposition > 252 and mouseXposition < 498) and (mouseYposition > 63 and mouseYposition < 159) and whatdotcolour (mouseXposition, mouseYposition) not= 67 then %checks that user clicked in the area of the colour circles and did not click the background
		    guessColours (4) := whatdotcolour (mouseXposition, mouseYposition)%choosing guess colour for the fourth position
		    for i : 1 .. 22
			drawoval (217, 35 + triesNum * 51, i, i, guessColours (4))
			drawoval (216, 35 + triesNum * 51, i, i, guessColours (4))
			drawoval (217, 34 + triesNum * 51, i, i, guessColours (4))
		    end for
		    drawoval (217, 35 + triesNum * 51, 24, 24, 139)  %de-selects circle with brown
		    drawoval (217, 35 + triesNum * 51, 23, 23, 139)
		    finished := true
		end if
		exit when finished %exit when that position has a colour selected
	    end loop
	end if
    end if
end userInput

%Check Procedure - Processes User's Guesses and Outputs a Reponse
body procedure check
    var correctPosCol : int := 0 %counts number of correct colours in the correct positions
    var correctCol : int := 0 %counts number of correct colours in the wrong positions
    if whatdotcolour (52, 35 + triesNum * 51) = 139 or whatdotcolour (107, 35 + triesNum * 51) = 139 or whatdotcolour (162, 35 + triesNum * 51) = 139 or whatdotcolour (217, 35 + triesNum * 51) = 139
	%checks to see if any of the positions lack colours
	    then
	error
    else
	for i : 1 .. 221
	    drawbox (25, 10 + (triesNum + 1) * 51, 25 + i, 61 + (triesNum + 1) * 51, 57) %draws purple rectangle
	end for
	for i : 0 .. 200 by 55
	    for x : 1 .. 24
		drawoval (52 + i, 35 + (triesNum + 1) * 51, x, x, 139) %re-draw big brown circles
		drawoval (51 + i, 35 + (triesNum + 1) * 51, x, x, 139)
		drawoval (52 + i, 34 + (triesNum + 1) * 51, x, x, 139)
	    end for
	end for
	for i : 1 .. 4 %checks to see how many times each guess colour comes up in the correct pattern
	    if correctColours (i) = guessColours (1) then
		correctCol := correctCol + 1
	    elsif correctColours (i) = guessColours (2) then
		correctCol := correctCol + 1
	    elsif correctColours (i) = guessColours (3) then
		correctCol := correctCol + 1
	    elsif correctColours (i) = guessColours (4) then
		correctCol := correctCol + 1
	    end if
	    if guessColours (i) = correctColours (i) then %checks to see if any colour is in teh right position
		correctPosCol := correctPosCol + 1 %add to this
		correctCol := correctCol - 1 %subtract, because this was already counted for before
	    end if
	end for
	triesNum := triesNum + 1 %adds to number of tries
    end if
    for i : 1 .. correctCol
	for x : 1 .. 4
	    drawoval (19 - (i mod 2) * 10, -10 - i div 3 * 10 + triesNum * 51, x, x, white) %draws white cirlces for correct colours in wrong positions
	end for
    end for
    for i : 1 .. correctPosCol
	for x : 1 .. 4
	    drawoval (9 + (i mod 2) * 10, -20 + i div 3 * 10 + triesNum * 51, x, x, 12) %draws red circles for correct colours in correct positions
	end for
    end for

    if correctPosCol = 4 then %if pattern is entirely correct
	GUI.Dispose (checkButton)
	title
	locate (5, 1)
	put "" : 27, "You win!"
	put ""
	put "" : 19, "The correct pattern was: "
	for i : 1 .. 20
	    drawoval (175, 400, i, i, correctColours (1)) %draw correct pattern
	    drawoval (174, 400, i, i, correctColours (1))
	    drawoval (175, 399, i, i, correctColours (1))
	    drawoval (225, 400, i, i, correctColours (2))
	    drawoval (224, 400, i, i, correctColours (2))
	    drawoval (225, 399, i, i, correctColours (2))
	    drawoval (275, 400, i, i, correctColours (3))
	    drawoval (274, 400, i, i, correctColours (3))
	    drawoval (275, 399, i, i, correctColours (3))
	    drawoval (325, 400, i, i, correctColours (4))
	    drawoval (324, 400, i, i, correctColours (4))
	    drawoval (325, 399, i, i, correctColours (4))
	end for
	locate (13, 22)
	put "It took you ", triesNum, " tries."
	for i : 0 .. 350 by 12
	    drawline (600, 250 - i, 0, 20 + i, white) %decorative lines
	end for
	for i : 0 .. 450 by 17
	    drawline (0, -300 + i, 650, 370 - i, 81)
	end for
	triesNum := 10
	play (">8c8e8c8e2g >8a<8f>8a<8f2d 8g8e8g8e2c <8g>8b<8g>8b4d<8g>8b8c1c<") %winning music
	GUI.Show (menuButton) %button allowing them to proceed to main menu
    elsif triesNum >= 10 then %if they used up all their tries
	GUI.Dispose (checkButton)
	title
	locate (5, 1)
	put "" : 27, "You lose!"
	put ""
	put "" : 19, "The correct pattern is: "
	for i : 1 .. 20
	    drawoval (175, 400, i, i, correctColours (1)) %draw correct pattern
	    drawoval (174, 400, i, i, correctColours (1))
	    drawoval (175, 399, i, i, correctColours (1))
	    drawoval (225, 400, i, i, correctColours (2))
	    drawoval (224, 400, i, i, correctColours (2))
	    drawoval (225, 399, i, i, correctColours (2))
	    drawoval (275, 400, i, i, correctColours (3))
	    drawoval (274, 400, i, i, correctColours (3))
	    drawoval (275, 399, i, i, correctColours (3))
	    drawoval (325, 400, i, i, correctColours (4))
	    drawoval (324, 400, i, i, correctColours (4))
	    drawoval (325, 399, i, i, correctColours (4))
	end for
	for i : 0 .. 350 by 12
	    drawline (600, 250 - i, 0, 20 + i, white) %decorative lines
	end for
	for i : 0 .. 450 by 17
	    drawline (0, -300 + i, 650, 370 - i, 81)
	end for
	play ("<1g1f+1f1e>") %losing music
	GUI.Show (menuButton) %button allowing them to proceed to main menu
    end if
end check

%Error procdure, used if less than four colours are entered in a row
body procedure error
    var errorFont : int := Font.New ("Minion Pro Cond:24")
    errorWin := Window.Open ("position: 500;500, graphics:250;200") %error iwndow open
    Window.Hide (inputOutputWin)
    title
    Draw.Text ("ERROR", 70, 130, errorFont, 109)
    locate (6, 1)
    put " You must select four colours,"
    put "  filling all the circles in"
    put "" : 2, "a row, before you can check."
    put ""
    pauseProgram %used to hold output
    Window.Show (inputOutputWin)
    Window.Close (errorWin)
end error

%Instructions Procedure
body procedure instructions
    Window.Hide (mainWin)
    instructionsWin := Window.Open ("position: 550;150, graphics:500;750") %open instructions window
    backgroundColour := 67         %sets background colour
    title
    locate (4, 1)
    put "This game is a colour pattern game, where the computer will"
    put "create a code of four different colours, each colour having a"
    put "specific position."
    put skip
    put "There will be no repeating colours in the pattern."
    put "While playing the game, you will try to figure out the code"
    put "by entering four colours into the board in the four positions."
    put "You will have ten tries, and the row that you should be"
    put "filling on that turn will be hihglitghed in purple."
    for i : 1 .. 216
	drawbox (20, 531, 20 + i, 480, 57) %purple rectangle
    end for
    for i : 0 .. 200 by 55
	for x : 1 .. 24
	    drawoval (45 + i, 505, x, x, 139) %draw big brown circles
	    drawoval (44 + i, 505, x, x, 139)
	    drawoval (45 + i, 504, x, x, 139)
	end for
    end for
    drawoval (100, 505, 24, 24, yellow) %selected circle outline
    drawoval (100, 505, 23, 23, yellow)
    for i : 1 .. 20
	drawbox (0, 531, i, 480, 26) %grey box
    end for
    for i : 1 .. 4
	drawoval (5, 515, i, i, 28) %small grey circles
	drawoval (5, 500, i, i, 28)
	drawoval (15, 515, i, i, 28)
	drawoval (15, 500, i, i, 28)
    end for
    locate (19, 1)
    put "To fill a space in the row, select the circle."
    put "When selected, the circle will be outlined in yellow."
    put "Then, click on a colour to fill that space with that colour."
    put "As long as a circle is selected, you will not be able to move on: you will not be able to select a different circle or press"
    put "a button until you select a colour. Clicking a colour will de-select the circle."
    put skip
    put "Clicking the 'check' button will make the computer check to"
    put "see how many of your inputted colours are used in the pattern."
    put "For every correct colour in the wrong position, the computer"
    put "will output a white circle, and for every correct colour in"
    put "the correct position, the computer will output a red circle."
    put skip
    put "You must fill a row entirely with four colours before clicking"
    put "'check'. You must use these coloured circle hints to find     the correct pattern."
    for i : 1 .. 216
	drawbox (20, 156, 20 + i, 105, 114) %brown rectangle
    end for
    for i : 0 .. 200 by 55
	for x : 1 .. 24
	    drawoval (45 + i, 130, x, x, 139) %draw big brown circles
	    drawoval (44 + i, 130, x, x, 139)
	    drawoval (45 + i, 129, x, x, 139)
	end for
    end for
    for i : 1 .. 22
	drawoval (45, 130, i, i, 53) %coloured circles
	drawoval (44, 130, i, i, 53)
	drawoval (45, 129, i, i, 53)
	drawoval (100, 130, i, i, 34)
	drawoval (99, 130, i, i, 34)
	drawoval (100, 129, i, i, 34)
	drawoval (155, 130, i, i, 21)
	drawoval (154, 130, i, i, 21)
	drawoval (155, 129, i, i, 21)
	drawoval (210, 130, i, i, 42)
	drawoval (209, 130, i, i, 42)
	drawoval (210, 129, i, i, 42)
    end for
    for i : 1 .. 20
	drawbox (0, 156, i, 105, 26) %grey box
    end for
    for i : 1 .. 4
	drawoval (5, 140, i, i, white) %white output circle
	drawoval (5, 125, i, i, 28) %grey circle
	drawoval (15, 140, i, i, white) %white output circle
	drawoval (15, 125, i, i, 12) %red output circle
    end for
    for i : 2 .. 10
	drawline (480 - i * 30, 0, maxx, -10 + i * 20, 5) %decorative lines
    end for
    for i : 2 .. 10
	drawline (480 - i * 30, -1, maxx, -11 + i * 20, 5)
    end for
    menuButton := GUI.CreateButton (200, 70, 0, "Main Menu", mainMenu) %button to return to main menu
end instructions

%Goodbye Procedure
procedure goodbye
    var goodbyeWin : int := Window.Open ("position: 500;500, graphics:400;400")
    setscreen ("offscreenonly")
    Window.Close (mainWin)
    backgroundColour := 68
    title
    for i : 0 .. 300 by 12 %decorative lines
	drawline (400, 349 - i, 0, 120 + i, 82)
    end for
    locate (11, 14)
    put "Thank you for playing!" ..
    locate (20, 10)
    put "Programmed by: Maria Yampolsky" ..
    for i : 1 .. 430 % Moving Flower
	drawfilloval (-11 + i, 30, 30, 30, 68)
	drawfilloval (-10 + i, 40, 10, 10, 89)
	drawfilloval (-20 + i, 30, 10, 10, 89)
	drawfilloval (0 + i, 30, 10, 10, 89)
	drawfilloval (-10 + i, 20, 10, 10, 89)
	drawfilloval (-10 + i, 30, 10, 10, red)
	delay (10)
	View.Update
    end for
    Window.Close (goodbyeWin)
end goodbye

%Main Program
introduction
loop
    exit when GUI.ProcessEvent
end loop
goodbye
%End Program
