### Robocorp level 2 automation certificate robot

## The structure of the robot:

*** Tasks ***<br/>
Order robots from RobotSpareBin Industries Inc<br/>
    &nbsp;&nbsp;Open the robot order website<br/>
    &nbsp;&nbsp;${orders}=    Get orders<br/>
    FOR    ${row}    IN    @{orders}<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;Close the annoying modal<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;Fill the form    ${row}<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;Preview the robot<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;Submit the order<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;${pdf}=    Store the receipt as a PDF file    ${row}[Order number<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;${screenshot}=    Take a screenshot of the robot    ${row}[Order number]<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}<br/>
        &nbsp;&nbsp;&nbsp;&nbsp;Go to order another robot<br/>
    &nbsp;&nbsp;END<br/>
    Create a ZIP file of the receipts<br/>
