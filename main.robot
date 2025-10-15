*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    OperatingSystem
Suite Setup    Open browser and go to hamk.fi

*** Variables ***
${url}    https://www.hamk.fi/

*** Keywords ***
Open browser and go to hamk.fi
    Open Browser    ${url}    chrome
    Maximize Browser Window
    Handle cookies and switch to english

Handle cookies and switch to english
    Sleep    3s
    Click Element    xpath=//a[text()="English"]

    Sleep    1s
    Click Button    xpath=//button[text()="Allow all cookies"]

Go to hamk homepage
    Go To    ${url}
    Wait For Condition    return document.readyState=="complete"
    Handle cookies and switch to english

*** Test Cases ***
Test “Latest News” section articles
    Sleep    3s    # waiting for page to load

    # targeting the buttons through the mutual youngest(?) parent
    ${parent_relative_buttons_location}=    Set Variable    xpath=//div[@class="wp-block-buttons em-radiobutton-select__buttons"]/div/div/button
    @{buttons}=    Get WebElements    ${parent_relative_buttons_location}

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
    

Test screenshot of the first picture in article
    
    # Navigate to hamk homepage if not there
    ${current_url}=    Get Location
    ${expected_url}=    Catenate    SEPARATOR=    ${url}    en/
    IF    $expected_url != $current_url
        Go to hamk homepage
    END    
    
    # Wait until hamk homepage loaded
    Sleep    2s

    # Find article
    @{articles}=    Get WebElements    xpath=//div[@class="em-block-news-feed__posts em-block-news-slider"]/article
    ${article}=    Get From List    ${articles}    0

    # Open article
    Click Element    ${article}
    Sleep    2s

    # Get first image element from article
    ${img}=    Get WebElement    xpath=//article[@class="block-root"]/div[@class="single-post__img"]/figure/img
    
    # Refresh scroll so the whole element is visible
    Scroll Element Into View    xpath=//footer
    Scroll Element Into View    xpath=//article[@class="block-root"]/div[@class="single-post__img"]    #xpath=//p[@class="is-style-lead"]
    
    # Delete the old screen and take a new one
    ${file_exists}=    Run Keyword And Return Status    File Should Exist    screenshots/element_screenshot.png
    IF    ${file_exists}
        Remove File    screenshots/element_screenshot.png
    END
    Capture Element Screenshot    ${img}    screenshots/element_screenshot.png
    File Should Exist    screenshots/element_screenshot.png