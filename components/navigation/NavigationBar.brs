sub initNavigationBar()
    initializeOpenState()
    initializeCloseState()
    showOpenState()
End sub

sub initializeOpenState()
    m.navRectangleOpen = m.top.FindNode("navRectangleOpen")
    m.buttonGroupOpen = m.top.FindNode("navButtonGroupOpen")
    
    m.buttonHomeOpen = m.top.FindNode("buttonHomeOpen")
    m.buttonHomeOpen.observeField("buttonSelected", "showHomeScreen")
    
    m.buttonFavoriteOpen = m.top.FindNode("buttonFavoriteOpen")
    m.buttonFavoriteOpen.observeField("buttonSelected", "showFavoriteScreen")
    
    m.buttonSearchOpen = m.top.FindNode("buttonSearchOpen")
    m.buttonSearchOpen.observeField("buttonSelected", "showSearchScreen")
    
    m.buttonProfileOpen = m.top.FindNode("buttonProfileOpen")
    m.buttonProfileOpen.observeField("buttonSelected", "showProfileScreen")
End sub

sub initializeCloseState()
    m.navRectangleClose = m.top.FindNode("navRectangleClose")
    m.navButtonGroupClose = m.top.FindNode("navButtonGroupClose")
    
    m.buttonHomeClose = m.top.FindNode("buttonHomeClose")
    m.buttonHomeClose.observeField("buttonSelected", "showHomeScreen")
    
    m.buttonFavoriteClose = m.top.FindNode("buttonFavoriteClose")
    m.buttonFavoriteClose.observeField("buttonSelected", "showFavoriteScreen")
    
    m.buttonSearchClose = m.top.FindNode("buttonSearchClose")
    m.buttonSearchClose.observeField("buttonSelected", "showSearchScreen")
    
    m.buttonProfileClose = m.top.FindNode("buttonProfileClose")
    m.buttonProfileClose.observeField("buttonSelected", "showProfileScreen")
End sub

sub showOpenState()
    m.navRectangleClose.visible = false
    m.navRectangleOpen.visible = true
    m.buttonGroupOpen.setFocus(true)
    m.navButtonGroupClose.setFocus(false)
End sub

sub showCloseState()
    m.navRectangleOpen.visible = false
    m.navRectangleClose.visible = true
    m.navButtonGroupClose.setFocus(false)
    m.buttonGroupOpen.setFocus(false)
End sub

sub showHomeScreen()
    print "Home Screen"
    homeScreen = m.top.createChild("HomeScreen")
    homeScreen.setFocus(true)
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