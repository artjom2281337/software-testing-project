*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open broser and go to hamk.fi
*** Keywords ***
Open broser and go to hamk.fi
    Open Browser    https://www.hamk.fi/    chrome
    Maximize Browser Window
*** Test Cases ***
Handle cookies and switch to english
    Sleep    3s
    Click Button    xpath=//button[text()="Salli valinta"]
    Click Element    xpath=//a[text()="English"]
Test “Latest News” section articles
    Scroll Element Into View    xpath=//button[contains(text(), 'Info')]
    Click Button    xpath=//button[contains(text(), 'Info')]
    Click Element    xpath=//a[@class="em-block-news-card__link absolute-link"]
    Page Should Contain    Make the Most of Your Time at HAMK – Join HAMKO and Your Campus Association!
    Go Back
    