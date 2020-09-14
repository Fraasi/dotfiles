@echo off

title Varmuuskopioidaan vsCode...

xcopy "C:\Users\Fra.AS.I\AppData\Roaming\Code\User" "G:\Code\GitHub\dotfiles\vsCode\user_backup"
xcopy "C:\Users\Fra.AS.I\AppData\Roaming\Code\User\snippets" "G:\Code\GitHub\dotfiles\vsCode\user_backup\snippets"

echo Valmista!

pause
