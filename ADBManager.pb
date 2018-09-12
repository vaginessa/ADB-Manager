InitSound()
InitNetwork()
XIncludeFile "Tolk.pb"
EnableExplicit
#Version = "1.0"
Tolk::TrySapi(#True)
Tolk::Load()
Tolk::Speak("ADB Manager. Wersja: "+#version+" Naciśnij ALT, aby otworzyć menu główne programu. Naciśnij F1, aby uzyskać pomoc.")
Global WebVersion$
Global ActionResult.l
Global FileName.s
Global CommandEntered.l
Global DeviceFilePath.s
Global PackageName.s
Global Quit = 0
Global UserWhereis = 0
Global UpdateCall.l
Global PortToUse.s
Declare ProgramUpdateCHK()
Declare ADBPresenceCHK()
Declare BackupCreate()
Declare BackupRestore()
Declare RestartHandler(CommandEntered.l)
Declare CustomRecoveryHandler()
Declare CustomROMHandler()
Declare CustomKernelHandler()
Declare FilePush()
Declare FilePull()
Declare AppInstall()
Declare AppUninstall()
Declare ADBDownload()
Declare ProgramDownload()
Declare RemoteConfig()
Declare RemoteConnect()
ProgramUpdateCHK()
Enumeration
  #Window
  #Menu
  #ProgramUpdateCheck  
  #ProgramADBCheck
  #ProgramWebPageVisit
  #ProgramExit
  #BackupCreate
  #BackupRestore
  #BackupPreferences
  #DeviceRemoteConfig
  #DeviceRemoteConnect
  #DeviceAndroidRestart
  #DeviceRecovery0 ;No Sideload
  #DeviceFastboot
  #DeviceRecovery1 ;With Sideload
  #ModRecovery
  #ModROM
  #ModKernel
  #FilePull  
  #FilePush
  #AppInstall
  #AppUninstall
  #AppShowInstalled
  #HelpReadme
  #HelpChangelog
  #HelpSupport
EndEnumeration  
If OpenPreferences("adbman.ini") = 0
  
  CreatePreferences("adbman.ini")
  MessageRequester("informacja","Wygląda na to, że to Twoje pierwsze uruchomienie programu ADB Manager. Program jest otwarty i darmowy, ale jeżeli uważasz, że jest on przydatny, możesz zawsze wpłacić niewielką dotację. https://paypal.me/darknuno666. Ta wiadomość pokaże się tylko raz na tym komputerze, niezależnie od podjętej decyzji. Dziękujemy!")
  EndIf
OpenWindow(#Window, 100, 200, 300, 0, "ADB Manager Redefined")
CreateMenu(#Menu, WindowID(#Window))
MenuTitle("Program")
MenuItem(#ProgramUpdateCheck  , "Ręcznie sprawdź aktualizacje.")
MenuItem(#ProgramADBCheck, "Sprawdź obecność ADB na komputerze")
MenuItem(#ProgramWebPageVisit, "Odwiedź stronę domową programu")
MenuItem(#ProgramExit, "Zamknij program")
MenuTitle("Kopia zapasowa")
MenuItem(#BackupCreate, "Utwórz kopię zapasową urządzenia. (Wymagane Custom Recovery)")
MenuItem(#BackupRestore, "Przywróć kopię zapasową z pliku .zip")
MenuItem(#BackupPreferences, "Preferencje kopii zapasowych")
MenuTitle("Urządzenie")
MenuItem(#DeviceRemoteConfig, "Skonfiguruj połączenie bezprzewodowe")
MenuItem(#DeviceRemoteConnect, "Wykonaj połączenie bezprzewodowe do zdalnego urządzenia")
MenuItem(#DeviceAndroidRestart, "Restart do systemu Android.")
MenuItem(#DeviceRecovery0, "Restart do Recovery (bez sideload)")
MenuItem(#DeviceFastboot, "Restart do trybu Fastboot")
MenuItem(#DeviceRecovery1, "Restart do Recovery (Z Sideload)")
MenuTitle("Modyfikacja")
MenuItem(#ModRecovery, "Wgraj Custom Recovery. Wymagane będzie przejście w tryb Fastboot")
MenuItem(#ModROM, "Wgraj Custom ROMa. Wymagane będzie przejście w tryb Recovery")
MenuItem(#ModKernel, "Wgraj nowy plik 'boot.img'. Wyjątkowo niebezpieczne! Wymagane będzie przejście do trybu fastboot")
MenuTitle("Zarządzanie plikami")
MenuItem(#FilePull  , "Wgraj plik na urządzenie")
MenuItem(#FilePush, "Pobierz plik z urządzenia")
MenuTitle("Zarządzanie aplikacjami")
MenuItem(#AppInstall, "Wgraj aplikację na urządzenie")
MenuItem(#AppUninstall, "Odinstaluj aplikację z urządzenia")
MenuItem(#AppShowInstalled, "Pokarz listę zainstalowanych pakietów")
MenuTitle("Pomoc")
MenuItem(#HelpReadme, "Pokaż plik Readme")
MenuItem(#HelpChangelog, "Pokaż plik Changelog")
MenuItem(#HelpSupport, "Skontaktuj się z autorem")
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Menu
      Select EventMenu()
        Case #ProgramUpdateCheck
          ProgramUpdateCHK()
          Case #ProgramADBCheck
                ADBPresenceCHK()
              Case #ProgramWebPageVisit
                RunProgram("https://nuno-software.pl/projects/adbmanager/")
              Case #ProgramExit
                End
              Case #BackupCreate
                BackupCreate()
              Case #BackupRestore
                BackupRestore()
              Case #DeviceRemoteConfig
                RemoteConfig()
              Case #DeviceAndroidRestart            
                RestartHandler(0)
              Case #DeviceRecovery0
                RestartHandler(1)
              Case #DeviceFastboot
                RestartHandler(2)
              Case #DeviceRecovery1
                RestartHandler(3)
            EndSelect
            EndSelect
            Until quit = 1
            End
                                Procedure ProgramUpdateCHK()
                            Global *Buffer = ReceiveHTTPMemory("http://nuno-software.pl/projects/adbmanager/v.txt")
              If *Buffer
                WebVersion$ = PeekS(*buffer, MemorySize(*buffer), #PB_UTF8)
                If WebVersion$ <> #Version
                  ActionResult = MessageRequester("Pytanie","Dostępna jest nowa wersja programu ADB Manager. Aktualna wersja "+#version+", dostępna wersja "+WebVersion$+". Czy chcesz ją pobrać i zainstalować?", #PB_MessageRequester_YesNo)
                  If ActionResult = #PB_MessageRequester_Yes
                    ProgramDownload()
                  ElseIf ActionResult = #PB_MessageRequester_No
                  EndIf
                  Else
                  Tolk::Speak("Posiadasz najnowszą wersję programu... "+#version+"")
                  EndIf
                EndIf
              EndProcedure
Procedure ADBPresenceCHK()
  If ReadFile(0,"adb.exe")=0
    ActionResult = MessageRequester("Pytanie","ADB nie jest zainstalowany. Czy chcesz dokonać teraz jego instalacji?", #PB_MessageRequester_YesNo)
    If ActionResult = #PB_MessageRequester_Yes
      ADBDownload()
    Else
    EndIf
    EndIf
  EndProcedure
  Procedure ProgramDownload()
    ActionResult = ReceiveHTTPFile("http://nuno-software.pl/projects/adbmanager/adbmanager.exe","adbmanager.exe")
    If ActionResult = 0
      MessageRequester("Błąd","Błąd pobierania pliku.")
Else
   Tolk::Speak("Pobieranie programu ADB Manager. Wersja "+WebVersion$+"")   
 EndIf
 MessageRequester("Informacja","Plik został pobrany. Wciśnij OK aby przejść do instalacji")
 RunProgram("adbsetup.exe")
    EndProcedure
Procedure ADBDownload()
  If ReceiveHTTPFile("Http://nuno-software.pl/projects/adbmanager/adbsetup.exe","adbsetup.exe") = 0 : MessageRequester("Błąd","Błąd podczas pobierania pliku")
  Else
    MessageRequester("Informacja","Informacja. Plik został pobrany. Wciśnij 'OK' aby przejść do instalacji ADB.")
    RunProgram("adbsetup.exe")
  EndIf
EndProcedure
Procedure RemoteConfig()
  PortToUse = InputRequester("Port","Podaj port, którego chcesz użyć do połączenia bezprzewodowego z urządzeniem","5555")
  RunProgram("adb.exe", "tcpip "+PortToUse+"", "", #PB_Program_Read)
  MessageRequester("Informacja","Połączenie bezprzewodowe skonfigurowane na porcie: "+PortToUse+"")
EndProcedure

  Procedure BackupCreate()
  If UserWhereis <> 1
    ActionResult = MessageRequester("Informacja","W celu przeprowadzenia tej operacji wymagane jest przejście w tryb Recovery. Czy chcesz tego teraz dokonać? Uwaga! Zapisz wszystkie otwarte na urządzeniu pliki przed kontynuowaniem.", #PB_MessageRequester_YesNo)
    If ActionResult=#PB_MessageRequester_Yes
      RestartHandler(1)
      MessageRequester("Informacja","Urządzenie jest restartowane. Zaczekaj na wykrycie go przez system operacyjny, i spróbuj ponownie wykonać operację.")
    EndIf
  EndIf
EndProcedure
Procedure BackupRestore()
   FileName= OpenFileRequester("Wybierz plik z kopią zapasową ADB","","Pliki kopii zapasowych | *.zip", 0)
  If FileName = "" : EndIf
  If UserWhereis <>1 : MessageRequester("Informacja","Do wybranej operacji wymagane jest przejście do trybu recovery. Można To zrobić z menu 'urządzenie'")
  EndIf
  RunProgram("adb.exe","backup restore "+FileName+"", "", #PB_Program_Read)
  EndProcedure
  Procedure RestartHandler(CommandEntered.l)
    Select CommandEntered
      Case 0
        UserWhereis = CommandEntered
        RunProgram("adb.exe", "reboot", "", #PB_Program_Read)
        Case 1
        UserWhereis = CommandEntered
        RunProgram("adb.exe","reboot recovery", "", #PB_Program_Read)
        Debug "Telefon jest restartowany do trybu Recovery. No sideload"
      Case 2
        UserWhereis = CommandEntered
        RunProgram ("adb.exe","reboot fastboot","", #PB_Program_Read)
        Debug "Telefon jest restartowany do trybu fastboot."
      Case 3
        UserWhereis = CommandEntered
        RunProgram ("adb.exe","reboot sideload","",  #PB_Program_Read)
        Debug "Telefon jest restartowany do trybu recovery (sideload)"
      Default
        Debug "Nieznana wartość podana jako argument funkcji."
    EndSelect
  EndProcedure
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 88
; FirstLine = 60
; Folding = --
; EnableXP