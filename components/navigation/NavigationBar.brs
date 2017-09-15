sub initNavigationBar()
    initializeOpenState()
    initializeCloseState()
    switchAccountOpen()
    switchAccountClose()
    showOpenState()
End sub

sub initializeOpenState()
    m.navRectangleOpen = m.top.FindNode("navRectangleOpen")
    m.navRectangleOpen.color = nevigationBarBackground()
    m.buttonGroupOpen = m.top.FindNode("navButtonGroupOpen")
    
    m.buttonHomeOpen = m.top.FindNode("buttonHomeOpen")
    m.buttonHomeOpen.unobserveField("buttonSelected")
    m.buttonHomeOpen.observeField("buttonSelected", "showHomeScreen")
    
    m.buttonCategoryOpen = m.top.FindNode("buttonCategoryOpen")
    m.buttonCategoryOpen.unobserveField("buttonSelected")
    m.buttonCategoryOpen.observeField("buttonSelected", "showCategoryScreen")

    m.buttonFavoriteOpen = m.top.FindNode("buttonFavoriteOpen")
    m.buttonFavoriteOpen.unobserveField("buttonSelected")
    m.buttonFavoriteOpen.observeField("buttonSelected", "showFavoriteScreen")
    
    m.buttonSearchOpen = m.top.FindNode("buttonSearchOpen")
    m.buttonSearchOpen.unobserveField("buttonSelected")
    m.buttonSearchOpen.observeField("buttonSelected", "showSearchScreen")
    
    m.buttonProfileOpen = m.top.FindNode("buttonProfileOpen")
    m.buttonProfileOpen.unobserveField("buttonSelected")
    m.buttonProfileOpen.observeField("buttonSelected", "showProfileScreen")
    
End sub

sub initializeCloseState()
    m.navRectangleClose = m.top.FindNode("navRectangleClose")
    m.navRectangleClose.color = nevigationBarBackground()
    m.navButtonGroupClose = m.top.FindNode("navButtonGroupClose")
    
    m.buttonHomeClose = m.top.FindNode("buttonHomeClose")
    m.buttonCategoryClose = m.top.FindNode("buttonCategoryClose")
    m.buttonFavoriteClose = m.top.FindNode("buttonFavoriteClose")
    m.buttonSearchClose = m.top.FindNode("buttonSearchClose")
    m.buttonProfileClose = m.top.FindNode("buttonProfileClose")
End sub

sub initializeOpenStateWC()
    m.navRectangleOpen = m.top.FindNode("navRectangleOpen")

    m.navRectangleOpen.color = nevigationBarBackground()
    m.buttonGroupOpen = m.top.FindNode("navButtonGroupOpen")
    
    m.buttonHomeOpen = m.top.FindNode("buttonHomeOpen")
    m.buttonHomeOpen.observeField("buttonSelected", "showHomeScreen")
    
    m.buttonCategoryOpen = m.top.FindNode("buttonCategoryOpen")
    m.buttonCategoryOpen.observeField("buttonSelected", "showCategoryScreen")

    m.buttonFavoriteOpen = m.top.FindNode("buttonFavoriteOpen")
    m.buttonFavoriteOpen.observeField("buttonSelected", "showFavoriteScreen")
    
    m.buttonSearchOpen = m.top.FindNode("buttonSearchOpen")
    m.buttonSearchOpen.observeField("buttonSelected", "showSearchScreen")
    
    m.buttonProfileOpen = m.top.FindNode("buttonProfileOpen")
    m.buttonProfileOpen.observeField("buttonSelected", "showProfileScreen")
    
End sub

sub switchAccountOpen()
    m.rectSwitchAccountLarge = m.top.FindNode("rectSwitchAccountLarge")
    m.rectSwitchAccountBorder = m.top.FindNode("rectSwitchAccountBorder")
    m.rectSwitchAccountPoster = m.top.FindNode("rectSwitchAccountPoster")
    
    m.labelSwitchAccountLarge = m.top.FindNode("labelSwitchAccountLarge")
    
    m.switchAccountPoster = m.top.FindNode("switchAccountPoster")
    if(getValueInRegistryForKey("selectedAccountThumbValue") <> "")
        m.rectSwitchAccountPoster.color = "0xFFFFFFFF"
        m.labelSwitchAccountLarge.visible = false
        m.switchAccountPoster.uri = getValueInRegistryForKey("selectedAccountThumbValue")
    else
        m.rectSwitchAccountPoster.color = m.appConfig.primary_color
        m.labelSwitchAccountLarge.visible = true
        m.labelSwitchAccountLarge.text = UCase(Left(getValueInRegistryForKey("selectedAccountNameValue"), 1))
        m.labelSwitchAccountLarge.font.size = 60
    end if
    
    m.buttonSwitchAccount = m.top.FindNode("buttonSwitchAccount")
    m.buttonSwitchAccount.unobserveField("buttonSelected")
    m.buttonSwitchAccount.observeField("buttonSelected", "showSwitchAccount")
    
    m.labelSwitchAccount = m.top.FindNode("labelSwitchAccount")
    m.labelSwitchAccount.font.size = 25
End sub

sub switchAccountClose()
    m.rectSwitchAccountSmall = m.top.FindNode("rectSwitchAccountSmall")
    
    primaryColor = m.appConfig.primary_color
    m.rectSwitchAccountSmall.color = m.appConfig.primary_color
    
    m.labelAccount = m.top.FindNode("labelAccount")
    m.labelAccount.text = UCase(Left(getValueInRegistryForKey("selectedAccountNameValue"), 1))
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
    profileScreen.appConfig = m.appConfig
    profileScreen.userData = m.userData
End sub

sub showSwitchAccount()

    print "Switch Account"
End sub