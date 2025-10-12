*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open browser and go to hamk.fi
*** Keywords ***
Open browser and go to hamk.fi
    Open Browser    https://www.hamk.fi/    chrome
    Maximize Browser Window
*** Test Cases ***
Handle cookies and switch to english
    Sleep    3s
    Click Element    xpath=//a[text()="English"]

    Sleep    1s
    Click Button    xpath=//button[text()="Allow all cookies"]
Test “Latest News” section articles
    Sleep    3s    # waiting for page to load

    # selecting info button
    ${info_button_identifier}=    Set Variable    xpath=//button[@class="wp-block-button__link wp-element-button em-radiobutton-select"]
    Scroll Element Into View    ${info_button_identifier}
    Click Button    ${info_button_identifier}

    # targeting first the article container, then selecting first article link.
    # the xpath index starts from 1, not 0.
    ${info_article_container}=    Set Variable    div[@id="overflow-slider-1"]
    Wait Until Element Is Visible    xpath=(//${info_article_container}//article)[1]
    Click Element                    xpath=(//${info_article_container}//article)[1]
    Page Should Contain    Make the Most of Your Time at HAMK – Join HAMKO and Your Campus Association!
    Go Back
    