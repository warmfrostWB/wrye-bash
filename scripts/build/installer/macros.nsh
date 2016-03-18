; macros.nsh
; Install/Uninstall macros for Wrye Bash NSIS installer.


; Prevent redefining the macro if included multiple times
!ifmacrondef InstallBashFiles
    !macro InstallBashFiles GameName GameTemplate GameDir RegValuePy RegValueExe RegPath DoPython DoExe DoAII
        ; Parameters:
        ;  GameName - name of the game files are being installed for.  This is used for registry entries
        ;  GameTemplate - name of the game that the template files are coming from (for example, Nehrim uses Oblivion files for templates)
        ;  GameDir - base directory for the game (one folder up from the Data directory)
        ;  RegValuePy - Registry value for the python version (Usually of the form $Reg_Value_OB_Py)
        ;  RegValueExe - Registry value for the standalone version
        ;  RegPath - Name of the registry string that will hold the path installing to
        ;  DoPython - Install python version of Wrye Bash (should be {BST_CHECKED} for true - this allows you to simple pass the state of the checkbox)
        ;  DoExe - Install the standalone version of Wrye Bash (should be {BST_CHECKED} for true)
        ;  IsExtra - true or false: if false, template files are not installed (since we don't know which type of game it is)
        ;  DoAII - true or false: if true, installs the ArchiveInvalidationInvalidated files (Oblivion based games)

        ; Install common files
        SetOutPath "${GameDir}\Mopy"
        File /r /x "*.bat" /x "*.py*" /x "*.template" /x "Wrye Bash.exe" "Mopy\*.*"
        ${If} ${DoAII} == true
            ; Some games don't use ArchiveInvalidationInvalidated
            SetOutPath "${GameDir}\Data"
            File /r "Mopy\templates\Oblivion\ArchiveInvalidationInvalidated!.bsa"
        ${EndIf}
        WriteRegStr HKLM "SOFTWARE\Wrye Bash" "${RegPath}" "${GameDir}"
        ${If} ${DoPython} == ${BST_CHECKED}
            ; Install Python only files
            SetOutPath "${GameDir}\Mopy"
            File /r "Mopy\*.py" "Mopy\*.pyw" "Mopy\*.bat" "Mopy\*.template"
            ; Write the installation path into the registry
            WriteRegStr HKLM "SOFTWARE\Wrye Bash" "${GameName} Python Version" "True"
        ${ElseIf} ${RegValuePy} == $Empty
            ; Only write this entry if it's never been installed before
            WriteRegStr HKLM "SOFTWARE\Wrye Bash" "${GameName} Python Version" ""
        ${EndIf}
        ${If} ${DoExe} == ${BST_CHECKED}
            ; Install the standalone only files
            SetOutPath "${GameDir}\Mopy"
            File "Mopy\Wrye Bash.exe"
            ; HACK: remove empty dirs added by the File "Mopy\*.*" - clear errors ??
            RMDir /r "${GameDir}\Mopy\bash\basher"
            RMDir /r "${GameDir}\Mopy\bash\basher"
            RMDir /r "${GameDir}\Mopy\bash\bosh"
            RMDir /r "${GameDir}\Mopy\bash\chardet"
            RMDir /r "${GameDir}\Mopy\bash\game"
            RMDir /r "${GameDir}\Mopy\bash\patcher"
            ; Write the installation path into the registry
            WriteRegStr HKLM "SOFTWARE\Wrye Bash" "${GameName} Standalone Version" "True"
        ${ElseIf} ${RegValueExe} == $Empty
            ; Only write this entry if it's never been installed before
            WriteRegStr HKLM "SOFTWARE\Wrye Bash" "${GameName} Standalone Version" ""
        ${EndIf}
    !macroend


    !macro RemoveRegistryEntries GameName
        ; Parameters:
        ;  GameName -  name of the game to remove registry entries for

        DeleteRegValue HKLM "SOFTWARE\Wrye Bash" "${GameName} Path"
        DeleteRegValue HKLM "SOFTWARE\Wrye Bash" "${GameName} Python Version"
        DeleteRegValue HKLM "SOFTWARE\Wrye Bash" "${GameName} Standalone Version"
    !macroend


    !macro RemoveOldFiles Path
        ; Old old files to delete (from before 294, the directory restructure)
        Delete "${Path}\Mopy\BashBugDump.log"
        Delete "${Path}\Mopy\DebugLog(Python2.7).bat"
        Delete "${Path}\Mopy\7zUnicode.exe"
        Delete "${Path}\Mopy\Wizard Images\Thumbs.db"
        Delete "${Path}\Data\Bashed Lists.txt"
        Delete "${Path}\Data\Bashed Lists.html"
        Delete "${Path}\Data\Ini Tweaks\Autosave, Never [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Autosave, ~Always [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Border Regions, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Border Regions, ~Enabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Fonts 1, ~Default [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Fonts, ~Default [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Grass, Fade 4k-5k [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Grass, ~Fade 2k-3k [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Intro Movies, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Intro Movies, ~Normal [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Joystick, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Joystick, ~Enabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Local Map Shader, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Local Map Shader, ~Enabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Music, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Music, ~Enabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Refraction Shader, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Refraction Shader, ~Enabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Save Backups, 1 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Save Backups, 2 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Save Backups, 3 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Save Backups, 5 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Screenshot, Enabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Screenshot, ~Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\ShadowMapResolution, 10 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\ShadowMapResolution, ~256 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\ShadowMapResolution, 1024 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 24 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, ~32 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 128 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 16 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 192 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 48 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 64 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 8 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound Card Channels, 96 [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound, Disabled [Oblivion].ini"
        Delete "${Path}\Data\Ini Tweaks\Sound, ~Enabled [Oblivion].ini"
        Delete "${Path}\Data\Bash Patches\Assorted to Cobl.csv"
        Delete "${Path}\Data\Bash Patches\Assorted_Exhaust.csv"
        Delete "${Path}\Data\Bash Patches\Bash_Groups.csv"
        Delete "${Path}\Data\Bash Patches\Bash_MFact.csv"
        Delete "${Path}\Data\Bash Patches\ShiveringIsleTravellers_Names.csv"
        Delete "${Path}\Data\Bash Patches\TamrielTravellers_Names.csv"
        Delete "${Path}\Data\Bash Patches\Guard_Names.csv"
        Delete "${Path}\Data\Bash Patches\Kmacg94_Exhaust.csv"
        Delete "${Path}\Data\Bash Patches\P1DCandles_Formids.csv"
        Delete "${Path}\Data\Bash Patches\OOO_Potion_Names.csv"
        Delete "${Path}\Data\Bash Patches\Random_NPC_Alternate_Names.csv"
        Delete "${Path}\Data\Bash Patches\Random_NPC_Names.csv"
        Delete "${Path}\Data\Bash Patches\Rational_Names.csv"
        Delete "${Path}\Data\Bash Patches\TI to Cobl_Formids.csv"
        Delete "${Path}\Data\Bash Patches\taglist.txt"
        Delete "${Path}\Data\Bash Patches\OOO, 1.23 Mincapped_NPC_Levels.csv"
        Delete "${Path}\Data\Bash Patches\OOO, 1.23 Uncapped_NPC_Levels.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Cities 15_Alternate_Names.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Cities 15_Names.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Cities 30_Alternate_Names.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Cities 30_Names.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Roads Revamped_Names.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Roads Revisited_Alternate_Names.csv"
        Delete "${Path}\Data\Bash Patches\Crowded Roads Revisited_Names.csv"
        Delete "${Path}\Data\Bash Patches\PTRoamingNPCs_Names.csv"
        Delete "${Path}\Mopy\uninstall.exe"
        Delete "${Path}\Mopy\*.html"
        Delete "${Path}\Mopy\7z.*"
        Delete "${Path}\Mopy\*CBash.dll"
        Delete "${Path}\Mopy\DebugLog(Python2.6).bat"
        Delete "${Path}\Mopy\ScriptParser.p*"
        Delete "${Path}\Mopy\balt.p*"
        Delete "${Path}\Mopy\barb.p*"
        Delete "${Path}\Mopy\barg.p*"
        Delete "${Path}\Mopy\bash.p*"
        Delete "${Path}\Mopy\basher.p*"
        Delete "${Path}\Mopy\bashmon.p*"
        Delete "${Path}\Mopy\belt.p*"
        Delete "${Path}\Mopy\bish.p*"
        Delete "${Path}\Mopy\bolt.p*"
        Delete "${Path}\Mopy\bosh.p*"
        Delete "${Path}\Mopy\bush.p*"
        Delete "${Path}\Mopy\cint.p*"
        Delete "${Path}\Mopy\Wrye Bash Debug.p*"
        Delete "${Path}\Mopy\gpl.txt"
        Delete "${Path}\Mopy\lzma.exe"
        Delete "${Path}\Mopy\Wrye Bash.txt"
        Delete "${Path}\Mopy\Wrye Bash.exe.log"
        Delete "${Path}\Mopy\wizards.txt"
        Delete "${Path}\Mopy\patch_option_reference.txt"
        RMDir /r "${Path}\Mopy\Data"
        RMDir /r "${Path}\Mopy\Extras"
        RMDir /r "${Path}\Mopy\images"
        ; image files were moved to Mopy\bash\images\tools as of version 300
        Delete "${Path}\Mopy\bash\images\3dsmax16.png"
        Delete "${Path}\Mopy\bash\images\3dsmax24.png"
        Delete "${Path}\Mopy\bash\images\3dsmax32.png"
        Delete "${Path}\Mopy\bash\images\abcamberaudioconverter16.png"
        Delete "${Path}\Mopy\bash\images\abcamberaudioconverter24.png"
        Delete "${Path}\Mopy\bash\images\abcamberaudioconverter32.png"
        Delete "${Path}\Mopy\bash\images\anifx16.png"
        Delete "${Path}\Mopy\bash\images\anifx24.png"
        Delete "${Path}\Mopy\bash\images\anifx32.png"
        Delete "${Path}\Mopy\bash\images\artofillusion16.png"
        Delete "${Path}\Mopy\bash\images\artofillusion24.png"
        Delete "${Path}\Mopy\bash\images\artofillusion32.png"
        Delete "${Path}\Mopy\bash\images\artweaver16.png"
        Delete "${Path}\Mopy\bash\images\artweaver24.png"
        Delete "${Path}\Mopy\bash\images\artweaver32.png"
        Delete "${Path}\Mopy\bash\images\audacity16.png"
        Delete "${Path}\Mopy\bash\images\audacity24.png"
        Delete "${Path}\Mopy\bash\images\audacity32.png"
        Delete "${Path}\Mopy\bash\images\autocad16.png"
        Delete "${Path}\Mopy\bash\images\autocad24.png"
        Delete "${Path}\Mopy\bash\images\autocad32.png"
        Delete "${Path}\Mopy\bash\images\Bashed-Patch-Dialogue-1.png"
        Delete "${Path}\Mopy\bash\images\Bashed-Patch-Dialogue-2.png"
        Delete "${Path}\Mopy\bash\images\Bashed-Patch-Dialogue-3.png"
        Delete "${Path}\Mopy\bash\images\Bashed-Patch-Dialogue-4.png"
        Delete "${Path}\Mopy\bash\images\Bashed-Patch-Dialogue-5-Build Progress.png"
        Delete "${Path}\Mopy\bash\images\Bashed-Patch-Dialogue-6-Build Report.png"
        Delete "${Path}\Mopy\bash\images\blender16.png"
        Delete "${Path}\Mopy\bash\images\blender24.png"
        Delete "${Path}\Mopy\bash\images\blender32.png"
        Delete "${Path}\Mopy\bash\images\bsacommander16.png"
        Delete "${Path}\Mopy\bash\images\bsacommander24.png"
        Delete "${Path}\Mopy\bash\images\bsacommander32.png"
        Delete "${Path}\Mopy\bash\images\cancel.png"
        Delete "${Path}\Mopy\bash\images\crazybump16.png"
        Delete "${Path}\Mopy\bash\images\crazybump24.png"
        Delete "${Path}\Mopy\bash\images\crazybump32.png"
        Delete "${Path}\Mopy\bash\images\ddsconverter16.png"
        Delete "${Path}\Mopy\bash\images\ddsconverter24.png"
        Delete "${Path}\Mopy\bash\images\ddsconverter32.png"
        Delete "${Path}\Mopy\bash\images\deeppaint16.png"
        Delete "${Path}\Mopy\bash\images\deeppaint24.png"
        Delete "${Path}\Mopy\bash\images\deeppaint32.png"
        Delete "${Path}\Mopy\bash\images\Doc-Browser-1.png"
        Delete "${Path}\Mopy\bash\images\Doc-Browser-2.png"
        Delete "${Path}\Mopy\bash\images\Doc-Browser-Set-Doc-Dialogue.png"
        Delete "${Path}\Mopy\bash\images\dogwaffle16.png"
        Delete "${Path}\Mopy\bash\images\dogwaffle24.png"
        Delete "${Path}\Mopy\bash\images\dogwaffle32.png"
        Delete "${Path}\Mopy\bash\images\eggtranslator16.png"
        Delete "${Path}\Mopy\bash\images\eggtranslator24.png"
        Delete "${Path}\Mopy\bash\images\eggtranslator32.png"
        Delete "${Path}\Mopy\bash\images\error.jpg"
        Delete "${Path}\Mopy\bash\images\evgaprecision16.png"
        Delete "${Path}\Mopy\bash\images\evgaprecision24.png"
        Delete "${Path}\Mopy\bash\images\evgaprecision32.png"
        Delete "${Path}\Mopy\bash\images\faststoneimageviewer16.png"
        Delete "${Path}\Mopy\bash\images\faststoneimageviewer24.png"
        Delete "${Path}\Mopy\bash\images\faststoneimageviewer32.png"
        Delete "${Path}\Mopy\bash\images\filezilla16.png"
        Delete "${Path}\Mopy\bash\images\filezilla24.png"
        Delete "${Path}\Mopy\bash\images\filezilla32.png"
        Delete "${Path}\Mopy\bash\images\finish.png"
        Delete "${Path}\Mopy\bash\images\fraps16.png"
        Delete "${Path}\Mopy\bash\images\fraps24.png"
        Delete "${Path}\Mopy\bash\images\fraps32.png"
        Delete "${Path}\Mopy\bash\images\freemind16.png"
        Delete "${Path}\Mopy\bash\images\freemind24.png"
        Delete "${Path}\Mopy\bash\images\freemind32.png"
        Delete "${Path}\Mopy\bash\images\freemind8.1custom_32.png"
        Delete "${Path}\Mopy\bash\images\freeplane16.png"
        Delete "${Path}\Mopy\bash\images\freeplane24.png"
        Delete "${Path}\Mopy\bash\images\freeplane32.png"
        Delete "${Path}\Mopy\bash\images\genetica16.png"
        Delete "${Path}\Mopy\bash\images\genetica24.png"
        Delete "${Path}\Mopy\bash\images\genetica32.png"
        Delete "${Path}\Mopy\bash\images\geneticaviewer16.png"
        Delete "${Path}\Mopy\bash\images\geneticaviewer24.png"
        Delete "${Path}\Mopy\bash\images\geneticaviewer32.png"
        Delete "${Path}\Mopy\bash\images\gimp16.png"
        Delete "${Path}\Mopy\bash\images\gimp24.png"
        Delete "${Path}\Mopy\bash\images\gimp32.png"
        Delete "${Path}\Mopy\bash\images\gimpshop16.png"
        Delete "${Path}\Mopy\bash\images\gimpshop24.png"
        Delete "${Path}\Mopy\bash\images\gimpshop32.png"
        Delete "${Path}\Mopy\bash\images\gmax16.png"
        Delete "${Path}\Mopy\bash\images\gmax24.png"
        Delete "${Path}\Mopy\bash\images\gmax32.png"
        Delete "${Path}\Mopy\bash\images\icofx16.png"
        Delete "${Path}\Mopy\bash\images\icofx24.png"
        Delete "${Path}\Mopy\bash\images\icofx32.png"
        Delete "${Path}\Mopy\bash\images\ini-all natural.png"
        Delete "${Path}\Mopy\bash\images\Ini-Edits-1.png"
        Delete "${Path}\Mopy\bash\images\Ini-Edits-2.png"
        Delete "${Path}\Mopy\bash\images\Ini-Edits-RClick-Ini-Header-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Ini-Edits-RClick-Ini-Header-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\Ini-Edits-RClick-Ini-Header-Menu-3.png"
        Delete "${Path}\Mopy\bash\images\ini-oblivion.png"
        Delete "${Path}\Mopy\bash\images\inkscape16.png"
        Delete "${Path}\Mopy\bash\images\inkscape24.png"
        Delete "${Path}\Mopy\bash\images\inkscape32.png"
        Delete "${Path}\Mopy\bash\images\insanity'sreadmegenerator16.png"
        Delete "${Path}\Mopy\bash\images\insanity'sreadmegenerator24.png"
        Delete "${Path}\Mopy\bash\images\insanity'sreadmegenerator32.png"
        Delete "${Path}\Mopy\bash\images\insanity'srng16.png"
        Delete "${Path}\Mopy\bash\images\insanity'srng24.png"
        Delete "${Path}\Mopy\bash\images\insanity'srng32.png"
        Delete "${Path}\Mopy\bash\images\Installers-1.png"
        Delete "${Path}\Mopy\bash\images\Installers-2.png"
        Delete "${Path}\Mopy\bash\images\Installers-3.png"
        Delete "${Path}\Mopy\bash\images\Installers-4.png"
        Delete "${Path}\Mopy\bash\images\Installers-5.png"
        Delete "${Path}\Mopy\bash\images\Installers-6.png"
        Delete "${Path}\Mopy\bash\images\Installers-7.png"
        Delete "${Path}\Mopy\bash\images\Installers-8.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Header-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Header-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Header-Menu-3.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Installer-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Installer-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Installer-Menu-3.png"
        Delete "${Path}\Mopy\bash\images\Installers-RClick-Installer-Menu-4-List-Packages.png"
        Delete "${Path}\Mopy\bash\images\Installers-Wizard-1.png"
        Delete "${Path}\Mopy\bash\images\Installers-Wizard-2.png"
        Delete "${Path}\Mopy\bash\images\interactivemapofcyrodiil16.png"
        Delete "${Path}\Mopy\bash\images\interactivemapofcyrodiil24.png"
        Delete "${Path}\Mopy\bash\images\interactivemapofcyrodiil32.png"
        Delete "${Path}\Mopy\bash\images\irfanview16.png"
        Delete "${Path}\Mopy\bash\images\irfanview24.png"
        Delete "${Path}\Mopy\bash\images\irfanview32.png"
        Delete "${Path}\Mopy\bash\images\isobl16.png"
        Delete "${Path}\Mopy\bash\images\isobl24.png"
        Delete "${Path}\Mopy\bash\images\isobl32.png"
        Delete "${Path}\Mopy\bash\images\logitechkeyboard16.png"
        Delete "${Path}\Mopy\bash\images\logitechkeyboard24.png"
        Delete "${Path}\Mopy\bash\images\logitechkeyboard32.png"
        Delete "${Path}\Mopy\bash\images\mapzone16.png"
        Delete "${Path}\Mopy\bash\images\mapzone24.png"
        Delete "${Path}\Mopy\bash\images\mapzone32.png"
        Delete "${Path}\Mopy\bash\images\maya16.png"
        Delete "${Path}\Mopy\bash\images\maya24.png"
        Delete "${Path}\Mopy\bash\images\maya32.png"
        Delete "${Path}\Mopy\bash\images\mediamonkey16.png"
        Delete "${Path}\Mopy\bash\images\mediamonkey24.png"
        Delete "${Path}\Mopy\bash\images\mediamonkey32.png"
        Delete "${Path}\Mopy\bash\images\milkshape3d16.png"
        Delete "${Path}\Mopy\bash\images\milkshape3d24.png"
        Delete "${Path}\Mopy\bash\images\milkshape3d32.png"
        Delete "${Path}\Mopy\bash\images\Mod-Checker-1.png"
        Delete "${Path}\Mopy\bash\images\modlistgenerator16.png"
        Delete "${Path}\Mopy\bash\images\modlistgenerator24.png"
        Delete "${Path}\Mopy\bash\images\modlistgenerator32.png"
        Delete "${Path}\Mopy\bash\images\Mods.png"
        Delete "${Path}\Mopy\bash\images\Mods-1.png"
        Delete "${Path}\Mopy\bash\images\Mods-2.png"
        Delete "${Path}\Mopy\bash\images\Mods-Plugin-Details-Panel.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-3.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-4.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-5.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-6.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-File-Header-Menu-7-List-Mods.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-3.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-4.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-5.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-6.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-7.png"
        Delete "${Path}\Mopy\bash\images\Mods-RClick-Mod-Menu-8-List-Patch-Config.png"
        Delete "${Path}\Mopy\bash\images\mudbox16.png"
        Delete "${Path}\Mopy\bash\images\mudbox24.png"
        Delete "${Path}\Mopy\bash\images\mudbox32.png"
        Delete "${Path}\Mopy\bash\images\mypaint16.png"
        Delete "${Path}\Mopy\bash\images\mypaint24.png"
        Delete "${Path}\Mopy\bash\images\mypaint32.png"
        Delete "${Path}\Mopy\bash\images\nifskope16.png"
        Delete "${Path}\Mopy\bash\images\nifskope24.png"
        Delete "${Path}\Mopy\bash\images\nifskope32.png"
        Delete "${Path}\Mopy\bash\images\notepad++16.png"
        Delete "${Path}\Mopy\bash\images\notepad++24.png"
        Delete "${Path}\Mopy\bash\images\notepad++32.png"
        Delete "${Path}\Mopy\bash\images\nvidiamelody16.png"
        Delete "${Path}\Mopy\bash\images\nvidiamelody24.png"
        Delete "${Path}\Mopy\bash\images\nvidiamelody32.png"
        Delete "${Path}\Mopy\bash\images\oblivionbookcreator16.png"
        Delete "${Path}\Mopy\bash\images\oblivionbookcreator24.png"
        Delete "${Path}\Mopy\bash\images\oblivionbookcreator32.png"
        Delete "${Path}\Mopy\bash\images\oblivionfaceexchangerlite16.png"
        Delete "${Path}\Mopy\bash\images\oblivionfaceexchangerlite24.png"
        Delete "${Path}\Mopy\bash\images\oblivionfaceexchangerlite32.png"
        Delete "${Path}\Mopy\bash\images\paint.net16.png"
        Delete "${Path}\Mopy\bash\images\paint.net24.png"
        Delete "${Path}\Mopy\bash\images\paint.net32.png"
        Delete "${Path}\Mopy\bash\images\paintshopprox316.png"
        Delete "${Path}\Mopy\bash\images\paintshopprox324.png"
        Delete "${Path}\Mopy\bash\images\paintshopprox332.png"
        Delete "${Path}\Mopy\bash\images\People-1.png"
        Delete "${Path}\Mopy\bash\images\People-2.png"
        Delete "${Path}\Mopy\bash\images\People-3-Menu.png"
        Delete "${Path}\Mopy\bash\images\photobie16.png"
        Delete "${Path}\Mopy\bash\images\photobie24.png"
        Delete "${Path}\Mopy\bash\images\photobie32.png"
        Delete "${Path}\Mopy\bash\images\photofiltre16.png"
        Delete "${Path}\Mopy\bash\images\photofiltre24.png"
        Delete "${Path}\Mopy\bash\images\photofiltre32.png"
        Delete "${Path}\Mopy\bash\images\photoscape16.png"
        Delete "${Path}\Mopy\bash\images\photoscape24.png"
        Delete "${Path}\Mopy\bash\images\photoscape32.png"
        Delete "${Path}\Mopy\bash\images\photoseam16.png"
        Delete "${Path}\Mopy\bash\images\photoseam24.png"
        Delete "${Path}\Mopy\bash\images\photoseam32.png"
        Delete "${Path}\Mopy\bash\images\photoshop16.png"
        Delete "${Path}\Mopy\bash\images\photoshop24.png"
        Delete "${Path}\Mopy\bash\images\photoshop32.png"
        Delete "${Path}\Mopy\bash\images\pixelstudiopro16.png"
        Delete "${Path}\Mopy\bash\images\pixelstudiopro24.png"
        Delete "${Path}\Mopy\bash\images\pixelstudiopro32.png"
        Delete "${Path}\Mopy\bash\images\pixia16.png"
        Delete "${Path}\Mopy\bash\images\pixia24.png"
        Delete "${Path}\Mopy\bash\images\pixia32.png"
        Delete "${Path}\Mopy\bash\images\PM-Archive-1.png"
        Delete "${Path}\Mopy\bash\images\PM-Archive-2.png"
        Delete "${Path}\Mopy\bash\images\radvideotools16.png"
        Delete "${Path}\Mopy\bash\images\radvideotools24.png"
        Delete "${Path}\Mopy\bash\images\radvideotools32.png"
        Delete "${Path}\Mopy\bash\images\randomnpc16.png"
        Delete "${Path}\Mopy\bash\images\randomnpc24.png"
        Delete "${Path}\Mopy\bash\images\randomnpc32.png"
        Delete "${Path}\Mopy\bash\images\readme\numpad.png"
        Delete "${Path}\Mopy\bash\images\readme\wizardscripthighlighter.jpg"
        Delete "${Path}\Mopy\bash\images\readme\wizard-testing_dotoperators.png"
        Delete "${Path}\Mopy\bash\images\readme\wizbaineditor_mousegesturemenu_example.png"
        Delete "${Path}\Mopy\bash\images\Saves.png"
        Delete "${Path}\Mopy\bash\images\Saves-1-RClick-Header-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Saves-1-RClick-Header-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\Saves-2-RClick-Save-1.png"
        Delete "${Path}\Mopy\bash\images\Saves-2-RClick-Save-2.png"
        Delete "${Path}\Mopy\bash\images\Saves-Click-Masters-Dialogue.png"
        Delete "${Path}\Mopy\bash\images\Saves-Delete-Spells.png"
        Delete "${Path}\Mopy\bash\images\Saves-Details-Panel.png"
        Delete "${Path}\Mopy\bash\images\Saves-Rename-Player.png"
        Delete "${Path}\Mopy\bash\images\Saves-Repair-ABomb.png"
        Delete "${Path}\Mopy\bash\images\Saves-Repair-Factions.png"
        Delete "${Path}\Mopy\bash\images\Saves-Reweigh-Potions.png"
        Delete "${Path}\Mopy\bash\images\Saves-Update-NPC-Levels.png"
        Delete "${Path}\Mopy\bash\images\Screenshots-1.png"
        Delete "${Path}\Mopy\bash\images\Screenshots-2.png"
        Delete "${Path}\Mopy\bash\images\Screenshots-3-RClick-Screenshot-Menu-1.png"
        Delete "${Path}\Mopy\bash\images\Screenshots-3-RClick-Screenshot-Menu-2.png"
        Delete "${Path}\Mopy\bash\images\sculptris16.png"
        Delete "${Path}\Mopy\bash\images\sculptris24.png"
        Delete "${Path}\Mopy\bash\images\sculptris32.png"
        Delete "${Path}\Mopy\bash\images\selectmany.jpg"
        Delete "${Path}\Mopy\bash\images\selectone.jpg"
        Delete "${Path}\Mopy\bash\images\Settings-1-Colour highlighted.png"
        Delete "${Path}\Mopy\bash\images\Settings-1-Colours-Dialogue-1.png"
        Delete "${Path}\Mopy\bash\images\Settings-1-Colours-Dialogue-2.png"
        Delete "${Path}\Mopy\bash\images\Settings-2-Tabs highlighted.png"
        Delete "${Path}\Mopy\bash\images\Settings-3-Status Bar and Icon size highlighted.png"
        Delete "${Path}\Mopy\bash\images\Settings-4-Language highlighted.png"
        Delete "${Path}\Mopy\bash\images\Settings-5-Plugin encoding highlighted.png"
        Delete "${Path}\Mopy\bash\images\Settings-6-Game highlighted.png"
        Delete "${Path}\Mopy\bash\images\Settings-7-Check for Updates highlighted.png"
        Delete "${Path}\Mopy\bash\images\softimagemodtool16.png"
        Delete "${Path}\Mopy\bash\images\softimagemodtool24.png"
        Delete "${Path}\Mopy\bash\images\softimagemodtool32.png"
        Delete "${Path}\Mopy\bash\images\speedtree16.png"
        Delete "${Path}\Mopy\bash\images\speedtree24.png"
        Delete "${Path}\Mopy\bash\images\speedtree32.png"
        Delete "${Path}\Mopy\bash\images\switch16.png"
        Delete "${Path}\Mopy\bash\images\switch24.png"
        Delete "${Path}\Mopy\bash\images\switch32.png"
        Delete "${Path}\Mopy\bash\images\tabula16.png"
        Delete "${Path}\Mopy\bash\images\tabula24.png"
        Delete "${Path}\Mopy\bash\images\tabula32.png"
        Delete "${Path}\Mopy\bash\images\tes4edit16.png"
        Delete "${Path}\Mopy\bash\images\tes4edit24.png"
        Delete "${Path}\Mopy\bash\images\tes4edit32.png"
        Delete "${Path}\Mopy\bash\images\tes4files16.png"
        Delete "${Path}\Mopy\bash\images\tes4files24.png"
        Delete "${Path}\Mopy\bash\images\tes4files32.png"
        Delete "${Path}\Mopy\bash\images\tes4gecko16.png"
        Delete "${Path}\Mopy\bash\images\tes4gecko24.png"
        Delete "${Path}\Mopy\bash\images\tes4gecko32.png"
        Delete "${Path}\Mopy\bash\images\tes4lodgen16.png"
        Delete "${Path}\Mopy\bash\images\tes4lodgen24.png"
        Delete "${Path}\Mopy\bash\images\tes4lodgen32.png"
        Delete "${Path}\Mopy\bash\images\tes4trans16.png"
        Delete "${Path}\Mopy\bash\images\tes4trans24.png"
        Delete "${Path}\Mopy\bash\images\tes4trans32.png"
        Delete "${Path}\Mopy\bash\images\tes4view16.png"
        Delete "${Path}\Mopy\bash\images\tes4view24.png"
        Delete "${Path}\Mopy\bash\images\tes4view32.png"
        Delete "${Path}\Mopy\bash\images\texturemaker16.png"
        Delete "${Path}\Mopy\bash\images\texturemaker24.png"
        Delete "${Path}\Mopy\bash\images\texturemaker32.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-10-Hover-OBSE-Toggle.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-11-RClick-Hide-GameLauncher.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-12-RClick-Hide-AutoQuit.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-13-RClick-Hide-OBSE-Toggle.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-1-Hover-HelpFile.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-2-Hover-Settings.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-3-Hover-ModChecker.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-4-Hover-DocBrowser.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-5-Hover-LaunchBashMon.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-6-Hover-LaunchBoss.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-7-Hover-LaunchGame.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-8-Hover-LaunchGameViaOBSE.png"
        Delete "${Path}\Mopy\bash\images\ToolBar-9-Hover-AutoQuit.png"
        Delete "${Path}\Mopy\bash\images\treed16.png"
        Delete "${Path}\Mopy\bash\images\treed24.png"
        Delete "${Path}\Mopy\bash\images\treed32.png"
        Delete "${Path}\Mopy\bash\images\twistedbrush16.png"
        Delete "${Path}\Mopy\bash\images\twistedbrush24.png"
        Delete "${Path}\Mopy\bash\images\twistedbrush32.png"
        Delete "${Path}\Mopy\bash\images\versions.png"
        Delete "${Path}\Mopy\bash\images\wings3d16.png"
        Delete "${Path}\Mopy\bash\images\wings3d24.png"
        Delete "${Path}\Mopy\bash\images\wings3d32.png"
        Delete "${Path}\Mopy\bash\images\winmerge16.png"
        Delete "${Path}\Mopy\bash\images\winmerge24.png"
        Delete "${Path}\Mopy\bash\images\winmerge32.png"
        Delete "${Path}\Mopy\bash\images\winsnap16.png"
        Delete "${Path}\Mopy\bash\images\winsnap24.png"
        Delete "${Path}\Mopy\bash\images\winsnap32.png"
        Delete "${Path}\Mopy\bash\images\wizardscripthighlighter.jpg"
        Delete "${Path}\Mopy\bash\images\wrye_monkey_150x57.bmp"
        Delete "${Path}\Mopy\bash\images\wrye_monkey_164x314.bmp"
        Delete "${Path}\Mopy\bash\images\wryebash_01.png"
        Delete "${Path}\Mopy\bash\images\wryebash_02.png"
        Delete "${Path}\Mopy\bash\images\wryebash_03.png"
        Delete "${Path}\Mopy\bash\images\wryebash_04.png"
        Delete "${Path}\Mopy\bash\images\wryebash_05.png"
        Delete "${Path}\Mopy\bash\images\wryebash_06.png"
        Delete "${Path}\Mopy\bash\images\wryebash_07.png"
        Delete "${Path}\Mopy\bash\images\wryebash_08.png"
        Delete "${Path}\Mopy\bash\images\wryebash_colors.png"
        Delete "${Path}\Mopy\bash\images\wryebash_docbrowser.png"
        Delete "${Path}\Mopy\bash\images\wryebash_peopletab.png"
        Delete "${Path}\Mopy\bash\images\WryeSplash_Original.png"
        Delete "${Path}\Mopy\bash\images\wtv16.png"
        Delete "${Path}\Mopy\bash\images\wtv24.png"
        Delete "${Path}\Mopy\bash\images\wtv32.png"
        Delete "${Path}\Mopy\bash\images\xnormal16.png"
        Delete "${Path}\Mopy\bash\images\xnormal24.png"
        Delete "${Path}\Mopy\bash\images\xnormal32.png"
        Delete "${Path}\Mopy\bash\images\xnview16.png"
        Delete "${Path}\Mopy\bash\images\xnview24.png"
        Delete "${Path}\Mopy\bash\images\xnview32.png"
        ; Some files from an older version of the Standalone that made non-standard
        ; compiled python file names (when loading python files present)
        Delete "${Path}\Mopy\bash\windowso"
        Delete "${Path}\Mopy\bash\libbsao"
        Delete "${Path}\Mopy\bash\cinto"
        Delete "${Path}\Mopy\bash\bwebo"
        Delete "${Path}\Mopy\bash\busho"
        Delete "${Path}\Mopy\bash\breco"
        Delete "${Path}\Mopy\bash\bosho"
        Delete "${Path}\Mopy\bash\bolto"
        Delete "${Path}\Mopy\bash\belto"
        Delete "${Path}\Mopy\bash\basso"
        Delete "${Path}\Mopy\bash\bashero"
        Delete "${Path}\Mopy\bash\basho"
        Delete "${Path}\Mopy\bash\bargo"
        Delete "${Path}\Mopy\bash\barbo"
        Delete "${Path}\Mopy\bash\bapio"
        Delete "${Path}\Mopy\bash\balto"
        ; As of 301 the following are obsolete:
        RMDir /r "${Path}\Mopy\macro"
        Delete "${Path}\Mopy\bash\installerstabtips.txt"
        Delete "${Path}\Mopy\bash\wizSTCo"
        Delete "${Path}\Mopy\bash\wizSTC.p*"
        Delete "${Path}\Mopy\bash\keywordWIZBAINo"
        Delete "${Path}\Mopy\bash\keywordWIZBAIN.p*"
        Delete "${Path}\Mopy\bash\keywordWIZBAIN2o"
        Delete "${Path}\Mopy\bash\keywordWIZBAIN2.p*"
        Delete "${Path}\Mopy\bash\settingsModuleo"
        Delete "${Path}\Mopy\bash\settingsModule.p*"
        RMDir /r "${Path}\Mopy\bash\images\stc"
        ; As of 303 the following are obsolete:
        Delete "${Path}\Mopy\templates\*.esp"
        ; As of 304.4 the following are obsolete
        Delete "${Path}\Mopy\bash\compiled\libloadorder32.dll"
        Delete "${Path}\Mopy\bash\compiled\boss32.dll"
        Delete "${Path}\Mopy\bash\bapi.p*"
        Delete "${Path}\Mopy\bash\compiled\boss64.dll"
        Delete "${Path}\Mopy\bash\compiled\libloadorder64.dll"
        ; As of 305, the following are obsolete:
        RMDir /r "${Path}\Mopy\bash\compiled\Microsoft.VC80.CRT"
        Delete "${Path}\Mopy\bash\images\WryeSplash_Original.png"
        Delete "${Path}\Mopy\bash\compiled\7zUnicode.exe"
        Delete "${Path}\Mopy\bash\compiled\7zCon.sfx"
        Delete "${Path}\Mopy\Bash Patches\Oblivion\taglist.txt"
        Delete "${Path}\Mopy\Bash Patches\Skyrim\taglist.txt"
        ${If} ${AtLeastWinXP}
            # Running XP or later, w9xpopen is only for 95/98/ME
            # Bash no longer ships with w9xpopen, but it may be left
            # over from a previous install
            Delete "${Path}\Mopy\w9xpopen.exe"
        ${EndIf}
    !macroend


    !macro RemoveCurrentFiles Path
        ; Remove files belonging to current build
        RMDir /r "${Path}\Mopy"
        ; Do not remove ArchiveInvalidationInvalidated!, because if it's registeredDelete
        ; in the users INI file, this will cause problems
        ;;Delete "${Path}\Data\ArchiveInvalidationInvalidated!.bsa"
        RMDir "${Path}\Data\INI Tweaks"
        RMDir "${Path}\Data\Docs"
        RMDir "${Path}\Data\Bash Patches"
        Delete "$SMPROGRAMS\Wrye Bash\*oblivion*"
    !macroend

    !macro UninstallBash GamePath GameName
        !insertmacro RemoveOldFiles "${GamePath}"
        !insertmacro RemoveCurrentFiles "${GamePath}"
        !insertmacro RemoveRegistryEntries "${GameName}"
    !macroend
!endif
