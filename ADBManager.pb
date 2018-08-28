;
;ADB Manager. Copyright Nunonical Software.
UserWhereis.i = 0
;Definicja Okna
InitNetwork()
OpenWindow(0, 100, 200, 300, 0, "ADB Manager Redefined")
CreateMenu(0, WindowID(0))
MenuTitle("Program")
MenuItem(1, "Ręcznie sprawdź aktualizacje.")
MenuItem(2, "Sprawdź obecność ADB na komputerze")
MenuItem(3, "Odwiedź stronę domową programu")
MenuItem(4, "Zamknij program")
MenuTitle("Kopia zapasowa")
MenuItem(5, "Utwórz kopię zapasową urządzenia. (Wymagane Custom Recovery)")
MenuItem(6, "Przywróć kopię zapasową z pliku .zip")
MenuItem(7, "Preferencje kopii zapasowych")
MenuTitle("Urządzenie")
MenuItem(8, "Restart do systemu Android.")
MenuItem(9, "Restart do Recovery (bez sideload)")
MenuItem(10, "Restart do trybu Fastboot")
MenuItem(11, "Restart do Recovery (Z Sideload)")
MenuTitle("Modyfikacja")
MenuItem(12, "Wgraj Custom Recovery. Wymagane będzie przejście w tryb Fastboot")
MenuItem(13, "Wgraj Custom ROMa. Wymagane będzie przejście w tryb Recovery")
MenuItem(14, "Wgraj nowy plik 'boot.img'. Wyjątkowo niebezpieczne! Wymagane będzie przejście do trybu fastboot")
MenuTitle("Zarządzanie plikami")
MenuItem(15, "Wgraj plik na urządzenie")
MenuItem(16, "Pobierz plik z urządzenia")
MenuTitle("Zarządzanie aplikacjami")
MenuItem(17, "Wgraj aplikację na urządzenie")
MenuItem(18, "Odinstaluj aplikację z urządzenia")
MenuItem(19, "Pokarz listę zainstalowanych pakietów")
MenuTitle("Pomoc")
MenuItem(20, "Pokaż plik Readme")
MenuItem(21, "Pokaż plik Changelog")
MenuItem(22, "Skontaktuj się z autorem")
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Menu
            Select EventMenu()
        Case 1
          MessageRequester("Błąd","Błąd: Nie mam gdzie hostować")
        Case 2
          If FileSize("adb.exe") <> -1
            MessageRequester("Sukces","ADB jest zainstalowany")
          Else
            MessageRequester("Pytanie","ADB nie jest zainstalowany. Czy chcesz go pobrać i zainstalować?", #PB_MessageRequester_YesNo)
            If #PB_MessageRequester_Yes
              If ReceiveHTTPFile("http://nuno-software.pl/ADBManager/adb.exe","adb.exe")
                                Else
                  MessageRequester("Błąd","Błąd pobierania pliku")
                EndIf             
                ElseIf #PB_MessageRequester_No
            EndIf
              EndIf
Case 3
          RunProgram("http://nuno-srv.pl")
        Case 4
          quit = 1
         Case 5
           RunProgram("adb.exe", "backup create", "")
       EndSelect
       EndSelect
       Until quit = 1
End
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 61
; FirstLine = 37
; EnableXP
; EnableAdmin
; Executable = ADBManager.exe