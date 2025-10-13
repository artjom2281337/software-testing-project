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

    # targeting the buttons through the mutual youngest(?) parent
    ${parent_relative_buttons_location}=    Set Variable    xpath=//div[@class="wp-block-buttons em-radiobutton-select__buttons"]/div/div/button
    ${buttons}=    Get WebElements    ${parent_relative_buttons_location}

    # testing each button through loop
    FOR    ${button}    IN    @{buttons}
        Sleep    2s
        Scroll Element Into View    ${button}
        Click Button    ${button}

        # save variable to confirm
        ${button_text}=    Get Text    ${button}
        Log To Console    ${button_text}
        
        # targeting first the article container, then selecting first article link.
        # the xpath index starts from 1, not 0.
        ${article_container}=    Set Variable    div[@id="overflow-slider-1"]
        Wait Until Element Is Visible    xpath=(//${article_container}//article)[1]
        Click Element    xpath=(//${article_container}//article)[1]
        
        Page Should Contain    ${button_text}
        Go Back
    END
    
    
Test search feature from main page: "services"
    Sleep    3s

    # search button is targeted through its class.
    # this script does not work unless viewport is on most top. js command is necessary, otherwise the test fails.
    ${search_button_identifier}=    Set Variable    xpath=//button[@class="search-toggle js-search-open"]
    Execute JavaScript    window.scrollTo(0, 0);    # https://stackoverflow.com/questions/1144805/scroll-to-the-top-of-the-page-using-javascript
    Wait Until Element Is Visible    ${search_button_identifier}    10s
    Click Element    ${search_button_identifier}

    # wait animation
    Sleep    1s

    # entering input by targeting search input id
    ${search_input_id}=    Set Variable    site-search-input
    ${SEARCH_INPUT}=    Set Variable    services
    Input Text    id=${search_input_id}    ${SEARCH_INPUT}

    # wait for results to load
    Sleep    10s

    # targeting first result and storing its variable
    # the element tree goes as:
    # div > article > div > h3 > a
    ${first_result}=    Set Variable    xpath=//div[contains(@class,"site-search-results__items")]/article[1]
    ${first_result_title}=    Get Text    ${first_result}//h3/a
    
    Click Element    ${first_result}

    # checking if its related page
    Sleep    3s
    Page Should Contain    ${first_result_title}
    

