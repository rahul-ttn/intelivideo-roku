Function emailValidation(textToDisplay as String)     
     checkRegex = CreateObject("roRegex", "(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)","i")
     
     return checkRegex.IsMatch(textToDisplay)
End Function

Function phoneValidation(textToDisplay as String)
    checkRegex = CreateObject("roRegex", "[0-9]", "i")
    arrayForValidation =[]
    arrayForValidation = checkRegex.Match(textToDisplay)
    return arrayForValidation
End Function

Function pinValidation(textToDisplay as String)
    checkRegex = CreateObject("roRegex", "[0-9]+", "i")
    arrayForValidation =[]
    arrayForValidation = checkRegex.Match(textToDisplay)
    return arrayForValidation
End Function
