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
    ${cookies_exist}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//button[text()="Allow all cookies"]
    IF    ${cookies_exist}
        Click Button    xpath=//button[text()="Allow all cookies"]
    END

Go to hamk homepage
    Go To    ${url}
    Wait For Condition    return document.readyState=="complete"
    Handle cookies and switch to english

*** Test Cases ***
Test “Latest News” section articles
    Sleep    3s    # waiting for page to load

    # targeting the buttons through the mutual youngest(?) parent
    ${parent_relative_buttons_location}=    Set Variable    xpath=//div[@class="wp-block-buttons em-radiobutton-select__buttons"]/div
    ${articles}=    Set Variable    xpath=//div[@id="overflow-slider-1"] 

    # Info
    Sleep    2s
    Scroll Element Into View    ${parent_relative_buttons_location}
    ${button_text}=    Get Text    ${parent_relative_buttons_location}/div[1]/button
    Click Button    ${parent_relative_buttons_location}/div[1]/button
    Scroll Element Into View    ${articles}
    Wait Until Element Is Visible    ${articles}/article[1]
    Click Element    ${articles}//article[1]
    Sleep    2s
    Page Should Contain    ${button_text}
    Page Should Contain    Make the Most of Your Time at HAMK – Join HAMKO and Your Campus Association!
    Go Back

    # News
    Sleep    2s
    Scroll Element Into View    ${parent_relative_buttons_location}
    ${button_text}=    Get Text    ${parent_relative_buttons_location}/div[2]/button
    Click Button    ${parent_relative_buttons_location}/div[2]/button
    Scroll Element Into View    ${articles}
    Wait Until Element Is Visible    ${articles}/article[1]
    Click Element    ${articles}/article[1]
    Sleep    2s
    Page Should Contain    ${button_text}
    Page Should Contain    Language Café Brings Locals and Internationals Together for the Third Year
    Go Back

    # Press releases
    Sleep    2s
    Scroll Element Into View    ${parent_relative_buttons_location}
    ${button_text}=    Get Text    ${parent_relative_buttons_location}/div[3]/button
    Click Button    ${parent_relative_buttons_location}/div[3]/button
    Scroll Element Into View    ${articles}
    Wait Until Element Is Visible    ${articles}/article[1]
    Click Element    ${articles}/article[1]
    Sleep    2s
    Page Should Contain    ${button_text}
    Page Should Contain    New degree programme responds to the growing demand in defence industry 
    Go Back

    # Stories
    Sleep    2s
    Scroll Element Into View    ${parent_relative_buttons_location}
    ${button_text}=    Get Text    ${parent_relative_buttons_location}/div[4]/button
    Click Button    ${parent_relative_buttons_location}/div[4]/button
    Scroll Element Into View    ${articles}
    Wait Until Element Is Visible    ${articles}/article[1]
    Click Element    ${articles}/article[1]
    Sleep    2s
    Page Should Contain    ${button_text}
    Page Should Contain    Internship Insights: My Time at HAMK Career Services
    Go Back

    # Student voice
    Sleep    2s
    Scroll Element Into View    ${parent_relative_buttons_location}
    ${button_text}=    Get Text    ${parent_relative_buttons_location}/div[5]/button
    Click Button    ${parent_relative_buttons_location}/div[5]/button
    Scroll Element Into View    ${articles}
    Wait Until Element Is Visible    ${articles}/article[1]
    Click Element    ${articles}/article[1]
    Sleep    2s
    Page Should Contain    ${button_text}
    Page Should Contain    How is it like to absolve Aalto Product Development Project? – A student assistant perspective
    Go Back




    # testing each button through loop
    # FOR    ${button}    IN    @{buttons}
    #     Sleep    2s
    #     Scroll Element Into View    ${button}
    #     Click Button    ${button}

    #     # save variable to confirm
    #     ${button_text}=    Get Text    ${button}
    #     Log To Console    ${button_text}
        
    #     # targeting first the article container, then selecting first article link.
    #     # the xpath index starts from 1, not 0.
    #     ${article_container}=    Set Variable    div[@id="overflow-slider-1"]
    #     Wait Until Element Is Visible    xpath=(//${article_container}//article)[1]
    #     Click Element    xpath=(//${article_container}//article)[1]
        
    #     Page Should Contain    ${button_text}
    #     Go Back
    # END


    
    
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

Test navigation to contact page
    # Scrolling up and clicking "About Us"
    Scroll Element Into View    xpath=//div[@class="navigation-bar__logo"]
    Sleep    2s
    Click Element    xpath=//div[@class="header-menu-desktop"]/ul/li[5]

    # Clicking "Contact Us"
    Wait Until Element Is Visible    xpath=//ul[@class="sub-menu is-open"]/li[5]
    Click Element    xpath=//ul[@class="sub-menu is-open"]/li[5]

    # Clicking "Search experts"
    Sleep    2s
    Click Element    xpath=//div[@class="wp-block-button"]/a

    # Typing lecturer's name in the search
    Sleep    5s
    Scroll Element Into View    xpath=//div[@class="em-block-contact-feed__app"]
    Input Text    xpath=//div[@class="em-block-contact-feed__app"]/div[1]/div[1]/div[1]/div[2]/input    Jawad Yasin
    Sleep    3s

    # Clicking "More information"
    Scroll Element Into View    xpath=//div[@class="wp-block-button is-style-outline"]
    Click Element    xpath=//div[@class="wp-block-button is-style-outline"]/a

    # Checking if the header element equals to lecturer name
    Sleep    2s
    ${lecturer_name}=    Get Text    xpath=//div[@class="wp-block-column"]/h1
    Should Be Equal    ${lecturer_name}    Jawad Yasin

Test come to study and visit Computer Applications

    # Navigate to hamk homepage if not there
    ${current_url}=    Get Location
    ${expected_url}=    Catenate    SEPARATOR=    ${url}    en/
    IF    $expected_url != $current_url
        Go to hamk homepage
    END    
    
    # opening come to study menu
    Wait Until Element Is Visible   xpath=//button[@data-menu="sub-toggle" and .//span[normalize-space(.)="Come to Study"]]    10s
        Click Element   xpath=//button[@data-menu="sub-toggle" and .//span[normalize-space(.)="Come to Study"]]

    # go to search study options
    Wait Until Element Is Visible   xpath=//a[.//span[normalize-space(.)='Search Study Options']]    15s
    Click element   xpath=//a[.//span[normalize-space(.)='Search Study Options']]

    # search course name
    Wait Until Element Is Visible   xpath=//input[contains(@placeholder," Search with a search term")]    10s
    Scroll Element Into View    xpath=//input[contains(@placeholder," Search with a search term")]
    Click Element   xpath=//input[contains(@placeholder," Search with a search term")]
    Clear Element Text    xpath=//input[contains(@placeholder," Search with a search term")] 
    Input Text      xpath=//input[contains(@placeholder," Search with a search term")]     computer applications
    Sleep    2s

    # open filters
    Click Element    xpath=//button[contains(@class,"hamk-checkboxbutton-select__toggle")]
    
    # select IT & ICT
    Wait Until Element Is Visible   xpath=//label[normalize-space(.)="IT and ICT"]     10s
    Scroll Element Into View    xpath=//label[normalize-space(.)="IT and ICT"] 
    Click Element   xpath=//label[normalize-space(.)="IT and ICT"] 

    # select computer applications in IT & ICT
    Wait Until Element Is Visible   xpath=//label[normalize-space(.)="Computer Applications"]    10s
    Scroll Element Into View    xpath=//label[normalize-space(.)="Computer Applications"]
    Click Element   xpath=//label[normalize-space(.)="Computer Applications"]

    # open computer applicatons
    Wait Until Element Is Visible   xpath=//a[contains(@href,"/degree/computer-applications")]   15s
    Scroll Element Into View    xpath=//a[contains(@href,"/degree/computer-applications")]
    Click Link  xpath=//a[contains(@href,"/degree/computer-applications")]

Test the prices showing up correctly in the hamk shop
    
    # Navigate to hamk homepage if not there
    ${current_url}=    Get Location
    ${expected_url}=    Catenate    SEPARATOR=    ${url}    en/
    IF    $expected_url != $current_url
        Go to hamk homepage
    END  

    # Find the shop button
    ${shop_button}=    Get WEbElement    xpath=//a[@href="https://shop.hamk.fi/"]
    Scroll Element Into View    ${shop_button}
    Sleep    0.5s

    # Go to the shop
    Click Element    ${shop_button}

    # Check if you are in the shop
    Page Should Contain    HAMK Shop
    Page Should Contain    Latest Products

    # Handle cookies if they show up
    ${cookie_button}=    Set Variable    xpath=//button[@class="cky-btn cky-btn-accept"]
    ${cookie_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${cookie_button}
    IF    ${cookie_exists}
        Click Button    ${cookie_button}
    END

    # Go to the products page
    ${product_page_button}=    Get WebElement    xpath=//a[contains(@href,"https://shop.hamk.fi/tuote-osasto/hamk-products/")]
    Click Element    ${product_page_button}
    
    # Get the products
    ${product_path}=    Set Variable    xpath=//main/ul[@class="products columns-3"]/li
    ${product}=    Get WebElement    ${product_path}
    Scroll Element Into View    ${product}
    Sleep    0.5s

    # Price and name for checking later
    ${product_price}=    Get Text    ${product_path}/a/span/span
    ${product_price}=    Split String    ${product_price}         
    ${product_price}=    Get From List    ${product_price}    0
    ${product_name}=    Get Text    ${product_path}/a/h2
    
    # Go to the product page
    Click Element    ${product}
    Sleep    0.5s

    # Check if it is the correct product and that the price is the same
    Page Should Contain    ${product_name}
    Page Should Contain    ${product_price}

    # Add proruct to the cart
    Click Button    xpath=//button[text()="Add to cart"]
    Sleep    2s

    # Go to the cart
    Click Element    xpath=//a[contains(@href,"https://shop.hamk.fi/cart/")]

    # Check that you are in the cart and that the product is there with the correct price
    Page Should Contain    Cart
    Page Should Contain    ${product_name}
    Page Should Contain    ${product_price}

Test mobile and navbar accessibility

    # Navigate to hamk homepage if not there
    ${current_url}=    Get Location
    ${expected_url}=    Catenate    SEPARATOR=    ${url}    en/
    IF    $expected_url != $current_url
        Go to hamk homepage
    END 

    # setting browser to mobile size
    Set Window Size    375    800

    # open navbar
    Wait Until Element Is Visible   xpath=//span[contains(@class,'menu-toggle__icon')]    5s
    Click Element   xpath=//span[contains(@class,'menu-toggle__icon')]
    Sleep    1s

    # click come to study
    Click Element   xpath=//div[contains(@class,'header-menu-mobile')]//button[@data-menu='sub-toggle' and .//span[normalize-space(.)='Come to Study']]
    Wait Until Element Is Visible   xpath=//ul[@id='sub-menu-1-0']//button[contains(@class,'js-sub-menu-close')]   10s
    Click Element   xpath=//ul[@id='sub-menu-1-0']//button[contains(@class,'js-sub-menu-close')]
    Sleep    0.5s
    # click cooperation and services
    Click Element   xpath=//div[contains(@class,'header-menu-mobile')]//button[@data-menu='sub-toggle' and .//span[normalize-space(.)='Cooperation and Services']]
    Wait Until Element Is Visible   xpath=//ul[@id='sub-menu-1-1']//button[contains(@class,'js-sub-menu-close')]    10s
    Click Button    xpath=//ul[@id='sub-menu-1-1']//button[contains(@class,'js-sub-menu-close')]
    
    # close the nav 
    Press Keys      xpath=//body    ESCAPE
    Maximize Browser Window

Test Hamk events
    # Navigate to hamk homepage if not there
    ${current_url}=    Get Location
    ${expected_url}=    Catenate    SEPARATOR=    ${url}    en/
    IF    $expected_url != $current_url
        Go to hamk homepage
    END 

    # go to check out our research page
    Wait Until Element Is Visible   xpath=//a[normalize-space(.)="Check out our research"]    15s
    Scroll Element Into View    xpath=//a[normalize-space(.)="Check out our research"]
    Click Element   xpath=//a[normalize-space(.)="Check out our research"] 

    # click on More events button
    Wait Until Element Is Visible   xpath=//a[contains(@href,"/tapahtuma/")]    15s
    Scroll Element Into View    xpath=//a[contains(@href,"/tapahtuma/")]
    Wait Until Element Is Enabled   xpath=//a[contains(@href,"/tapahtuma/")]    5s
    Click Element   xpath=//a[contains(@href,"/tapahtuma/")] 

    # using for loop to make the robot click next button for higest 4 times if button is available 
    ${next_btn}=    Set Variable    xpath=//a[contains(@class,'next') and contains(@class,'page-numbers')]
    FOR    ${i}    IN RANGE    4
        ${count}=   Get Element Count   ${next_btn}
        IF  ${count} == 0
            Exit For Loop
        END
        Scroll Element Into View    ${next_btn}
        Click Element   ${next_btn}
        Wait For Condition  return document.readyState=="complete"
    END

