sub init()
    m.top.setFocus(true)
    initFields()
end sub

sub initFields()
    m.parentRectangle = m.top.findNode("rectangleouter")
    m.posterBackground = m.top.findNode("posterBackground")
    m.labelTitle = m.top.findNode("labelTitle")
    m.labelSubTitle = m.top.findNode("labelSubTitle")
    
    m.monthlyRectangle = m.top.findNode("monthlyRectangle")
    m.labelMonthlyPlan = m.top.findNode("labelMonthlyPlan")
    labelMonthlyPlanY = 50
    m.labelMonthlyPlan.translation = [0,labelMonthlyPlanY]
    m.labelMonthlyPlan.font.size = 45
    
    m.monthlylabelPlan = m.top.findNode("monthlylabelPlan")
    monthlylabelPlanY = labelMonthlyPlanY + 50
    m.monthlylabelPlan.translation = [0,monthlylabelPlanY]
    m.monthlylabelPlan.font.size = 45
    
    m.labelPoint1 = m.top.findNode("labelPoint1")
    labelPoint1Y = monthlylabelPlanY + 70
    m.labelPoint1.translation = [0,labelPoint1Y]
    m.labelPoint1.font.size = 20
    
    m.labelPoint2 = m.top.findNode("labelPoint2")
    labelPoint2Y = labelPoint1Y + 30
    m.labelPoint2.translation = [0,labelPoint2Y]
    m.labelPoint2.font.size = 20
    
    m.labelPoint3 = m.top.findNode("labelPoint3")
    labelPoint3Y = labelPoint2Y + 30
    m.labelPoint3.translation = [0,labelPoint3Y]
    m.labelPoint3.font.size = 20
    
    m.labelPoint4 = m.top.findNode("labelPoint4") 
    labelPoint4Y = labelPoint3Y + 30
    m.labelPoint4.translation = [0,labelPoint4Y]
    m.labelPoint4.font.size = 20
     
    m.labelOneMonth = m.top.findNode("labelOneMonth")
    labelOneMonthY = labelPoint4Y + 170
    m.labelOneMonth.translation = [0,labelOneMonthY]
    m.labelOneMonth.font.size = 28
    
    m.labelPrice = m.top.findNode("labelPrice")
    labelPriceY = labelOneMonthY + 40
    m.labelPrice.translation = [0,labelPriceY]
    m.labelPrice.font.size = 28
    
    m.selectButtonRectangle = m.top.findNode("selectButtonRectangle")
    m.buttonSelectMonthly = m.top.findNode("buttonSelectMonthly")
    m.selectButtonTextLabel = m.top.findNode("selectButtonTextLabel")
    
    selectButtonRectangleX = (m.monthlyRectangle.width - m.selectButtonRectangle.width)/2
    selectButtonRectangleY = labelPriceY + 50
    m.selectButtonRectangle.translation = [selectButtonRectangleX,selectButtonRectangleY]
   
'===================================Yearly card========================================== 
    m.yearlyRectangle = m.top.findNode("yearlyRectangle")
    m.labelYearlyPlan = m.top.findNode("labelYearlyPlan")
    labelYearlyPlanY = 50
    m.labelYearlyPlan.translation = [0,labelYearlyPlanY]
    m.labelYearlyPlan.font.size = 45
    
    m.labelPlan = m.top.findNode("labelPlan")
    labelPlanY = labelYearlyPlanY + 50
    m.labelPlan.translation = [0,labelPlanY]
    m.labelPlan.font.size = 45
    
    m.labelYearlyPoint1 = m.top.findNode("labelYearlyPoint1")
    labelYearlyPoint1Y = labelPlanY + 70
    m.labelYearlyPoint1.translation = [0,labelYearlyPoint1Y]
    m.labelYearlyPoint1.font.size = 20
    
    m.labelYearlyPoint2 = m.top.findNode("labelYearlyPoint2")
    labelYearlyPoint2Y = labelYearlyPoint1Y + 30
    m.labelYearlyPoint2.translation = [0,labelYearlyPoint2Y]
    m.labelYearlyPoint2.font.size = 20
    
    m.labelYearlyPoint3 = m.top.findNode("labelYearlyPoint3")
    labelYearlyPoint3Y = labelYearlyPoint2Y + 30
    m.labelYearlyPoint3.translation = [0,labelYearlyPoint3Y]
    m.labelYearlyPoint3.font.size = 20
    
    m.labelYearlyPoint4 = m.top.findNode("labelYearlyPoint4") 
    labelYearlyPoint4Y = labelYearlyPoint3Y + 30
    m.labelYearlyPoint4.translation = [0,labelYearlyPoint4Y]
    m.labelYearlyPoint4.font.size = 20
     
    m.labelYearlyOneMonth = m.top.findNode("labelYearlyOneMonth")
    labelYearlyOneMonthY = labelYearlyPoint4Y + 170
    m.labelYearlyOneMonth.translation = [0,labelYearlyOneMonthY]
    m.labelYearlyOneMonth.font.size = 28
    
    m.labelYearlyPrice = m.top.findNode("labelYearlyPrice")
    labelYearlyPriceY = labelYearlyOneMonthY + 40
    m.labelYearlyPrice.translation = [0,labelYearlyPriceY]
    m.labelYearlyPrice.font.size = 28
    
    m.selectButtonYearlyRectangle = m.top.findNode("selectButtonYearlyRectangle")
    m.buttonSelectYearly = m.top.findNode("buttonSelectYearly")
    m.selectButtonYearlyTextLabel = m.top.findNode("selectButtonYearlyTextLabel")
    
    selectButtonYearlyRectangleX = (m.yearlyRectangle.width - m.selectButtonYearlyRectangle.width)/2
    selectButtonYearlyRectangleY = labelYearlyPriceY + 50
    m.selectButtonYearlyRectangle.translation = [selectButtonYearlyRectangleX,selectButtonYearlyRectangleY]
      
end sub

