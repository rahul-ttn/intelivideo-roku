sub initNavigationBar(isCategory as string)
    initializeOpenState(isCategory)
    initializeCloseState(isCategory)
    showOpenState()
End sub

sub initializeOpenState(isCategory as string)
    m.navRectangleOpen = m.top.FindNode("navRectangleOpen")

    m.navRectangleOpen.color = nevigationBarBackground()
    m.buttonGroupOpen = m.top.FindNode("navButtonGroupOpen")
    
    m.buttonHomeOpen = m.top.FindNode("buttonHomeOpen")
    m.buttonHomeOpen.observeField("buttonSelected", "showHomeScreen")
    
    m.buttonCategoryOpen = m.top.FindNode("buttonCategoryOpen")
    m.buttonCategoryOpen.observeField("buttonSelected", "showCategoryScreen")
    'if isCategory <> "true"
        'm.buttonCategoryOpen.visible = false
    'end if
    
    m.buttonFavoriteOpen = m.top.FindNode("buttonFavoriteOpen")
    m.buttonFavoriteOpen.observeField("buttonSelected", "showFavoriteScreen")
    
    m.buttonSearchOpen = m.top.FindNode("buttonSearchOpen")
    m.buttonSearchOpen.observeField("buttonSelected", "showSearchScreen")
    
    m.buttonProfileOpen = m.top.FindNode("buttonProfileOpen")
    m.buttonProfileOpen.observeField("buttonSelected", "showProfileScreen")
    
    m.rectSwitchAccountLarge = m.top.FindNode("rectSwitchAccountLarge")
    m.rectSwitchAccountBorder = m.top.FindNode("rectSwitchAccountBorder")
    m.rectSwitchAccountPoster = m.top.FindNode("rectSwitchAccountPoster")
    m.labelSwitchAccountLarge = m.top.FindNode("labelSwitchAccountLarge")
    m.switchAccountPoster = m.top.FindNode("switchAccountPoster")
    
    m.buttonSwitchAccount = m.top.FindNode("buttonSwitchAccount")
    m.buttonSwitchAccount.observeField("buttonSelected", "showSwitchAccount")
    
    m.labelSwitchAccount = m.top.FindNode("labelSwitchAccount")
    m.labelSwitchAccount.font.size = 25
End sub

sub initializeCloseState(isCategory as string)
    m.navRectangleClose = m.top.FindNode("navRectangleClose")
    m.navRectangleClose.color = "0x565656FF"
    m.navButtonGroupClose = m.top.FindNode("navButtonGroupClose")
    
    m.buttonHomeClose = m.top.FindNode("buttonHomeClose")
    'm.buttonHomeClose.observeField("buttonSelected", "showHomeScreen")
    
    m.buttonCategoryClose = m.top.FindNode("buttonCategoryClose")
    'm.buttonCategoryClose.visible = false
    
    m.buttonFavoriteClose = m.top.FindNode("buttonFavoriteClose")
    'm.buttonFavoriteClose.observeField("buttonSelected", "showFavoriteScreen")
    
    m.buttonSearchClose = m.top.FindNode("buttonSearchClose")
    'm.buttonSearchClose.observeField("buttonSelected", "showSearchScreen")
    
    m.buttonProfileClose = m.top.FindNode("buttonProfileClose")
    'm.buttonProfileClose.observeField("buttonSelected", "showProfileScreen")
    
    m.rectSwitchAccountSmall = m.top.FindNode("rectSwitchAccountSmall")
End sub


sub showOpenState()
    m.navRectangleClose.visible = false
    m.navRectangleOpen.visible = true
    
    m.rectSwitchAccountLarge.visible = true
    m.rectSwitchAccountSmall.visible = false
    
    m.buttonGroupOpen.setFocus(true)
    m.navButtonGroupClose.setFocus(false)
End sub

sub showCloseState()
    m.navRectangleOpen.visible = false
    m.navRectangleClose.visible = true
    
    m.rectSwitchAccountLarge.visible = false
    m.rectSwitchAccountSmall.visible = true
    
    m.navButtonGroupClose.setFocus(false)
    m.buttonGroupOpen.setFocus(false)
End sub

sub showHomeScreen()
    print "Home Screen"
    homeScreen = m.top.createChild("HomeScreen")
    homeScreen.setFocus(true)
End sub

sub showCategoryScreen()
    print "showCategoryScreen " 
End sub

sub showFavoriteScreen()
    print "Favorite Screen"
End sub

sub showSearchScreen()
    print "Search Screen"
End sub

sub showProfileScreen()
    print "Profile Screen"
    profileScreen = m.top.createChild("ProfileScreen")
    profileScreen.setFocus(true)
End sub

sub showSwitchAccount()
    print "Switch Account"
End sub