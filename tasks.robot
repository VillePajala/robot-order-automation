*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.Robocorp.Vault
Library           RPA.Tables
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           Dialogs
Library           RPA.Dialogs
Library           RPA.Desktop.Windows
Library           RPA.PDF

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the robot
        Submit the order
        ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        #    ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        #    Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
        #END
        # Create a ZIP file of the receipts
    END

*** Keywords ***
Open the robot order website
    ${robotUrl}=    Get Secret    robotSpareBinUrl
    Open Available Browser    ${robotUrl}[url]
    Wait Until Page Contains Element    css:#root > div > div > div > div:nth-child(1) > form > button
    Click Element    css:#root > header > div > ul > li:nth-child(2) > a

Get orders
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=${TRUE}
    ${csvFile}=    Read table from CSV    orders.csv    header=True
    [Return]    ${csvFile}

Close the annoying modal
    Click Button    css:button.btn.btn-dark

Fill the form
    [Arguments]    ${row}
    Select From List By Index    id:head    ${row}[Head]
    Select Radio Button    body    ${row}[Body]
    Press Keys    xpath=//body    Keys.TAB + Keys.up
    Input Text    css:input[placeholder="Enter the part number for the legs"]    ${row}[Legs]
    Input Text    name:address    ${row}[Address]

Preview the robot
    Click Button    preview

Submit the order
    Wait Until Keyword Succeeds
    ...    5x
    ...    1s
    ...    Validate order

Validate order
    Click Button    id:order
    Wait Until Page Contains Element    id:order-another

Store the receipt as a PDF file
    [Arguments]    ${orderNumber}
    Wait Until Element Is Visible    id:receipt
    ${receipt_html}=    Get Element Attribute    id:receipt    outerHTML
    ${pdfPath}=    Html To Pdf    ${receipt_html}    ${OUTPUT_DIR}${/}${orderNumber}.pdf
    [Return]    ${pdfPath}

Go to order another robot
    Wait Until Keyword Succeeds
    ...    5x
    ...    1 sec
    ...    Go to next order

Go to next order
    Click Button    id:order-another
    Wait Until Page Contains Element    id:order
