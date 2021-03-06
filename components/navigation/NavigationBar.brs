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
    
    appendButtons()
    
End sub

sub appendButtons()
    m.buttonGroupOpen.appendChild(m.buttonHomeOpen)
    if m.top.getScene().appConfigContent.display_categories
        m.buttonGroupOpen.appendChild(m.buttonCategoryOpen)
    else
        m.buttonCategoryOpen.visible = false
    end if
    m.buttonGroupOpen.appendChild(m.buttonFavoriteOpen)
    m.buttonGroupOpen.appendChild(m.buttonSearchOpen)
    m.buttonGroupOpen.appendChild(m.buttonProfileOpen)
end sub

sub initializeCloseState()
    m.navRectangleClose = m.top.FindNode("navRectangleClose")
    m.navRectangleClose.color = nevigationBarBackground()
    m.navButtonGroupClose = m.top.FindNode("navButtonGroupClose")
    
    m.buttonHomeClose = m.top.FindNode("buttonHomeClose")
    m.buttonCategoryClose = m.top.FindNode("buttonCategoryClose")
    m.buttonFavoriteClose = m.top.FindNode("buttonFavoriteClose")
    m.buttonSearchClose = m.top.FindNode("buttonSearchClose")
    m.buttonProfileClose = m.top.FindNode("buttonProfileClose")
    appendPosters()
End sub

sub appendPosters()
    m.navButtonGroupClose.appendChild(m.buttonHomeClose)
    if m.top.getScene().appConfigContent.display_categories
        m.navButtonGroupClose.appendChild(m.buttonCategoryClose)
    else
        m.buttonCategoryClose.visible = false
    end if
    m.navButtonGroupClose.appendChild(m.buttonFavoriteClose)
    m.navButtonGroupClose.appendChild(m.buttonSearchClose)
    m.navButtonGroupClose.appendChild(m.buttonProfileClose)
end sub

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
    if getValueInRegistryForKey("selectedAccountThumbValue") <> ""
        m.rectSwitchAccountPoster.color = "0xFFFFFFFF"
        m.labelSwitchAccountLarge.visible = false
        m.switchAccountPoster.uri = getValueInRegistryForKey("selectedAccountThumbValue")
    else
        m.rectSwitchAccountPoster.color = m.top.getScene().appConfigContent.primary_color
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
    
    primaryColor = m.top.getScene().appConfigContent.primary_color
    m.rectSwitchAccountSmall.color = m.top.getScene().appConfigContent.primary_color
    
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
    if m.screenName <> homeScreen()
        homeScreen = m.top.createChild("HomeScreen")
        homeScreen.setFocus(true)
    end if
End sub

sub showCategoryScreen()
    print "showCategoryScreen "
     if m.screenName <> categoryScreen()
        m.categoryScreen = m.top.createChild("CategoriesScreen")
        m.categoryScreen.setFocus(true)
        m.categoryScreen.isbaseCategory = true
     end if
End sub

sub showFavoriteScreen()
    print "Favorite Screen"
    if m.screenName <> favoriteScreen()
        favoriteScreen = m.top.createChild("FavoriteScreen")
        favoriteScreen.setFocus(true)
    end if
End sub

sub showSearchScreen()
    print "Search Screen"
    if m.screenName <> searchScreen()
        searchScreen = m.top.createChild("SearchScreen")
        searchScreen.setFocus(true)
    end if
End sub

sub showProfileScreen()
    print "Profile Screen"
    if m.screenName <> profileScreen()
        profileScreen = m.top.createChild("ProfileScreen")
        profileScreen.setFocus(true)
    end if
End sub

sub showSwitchAccount()
    print "Switch Account"
    
    m.switchAccount = m.top.createChild("SwitchAccount")
    m.switchAccount.setFocus(true)
End sub