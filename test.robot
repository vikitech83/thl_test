*** Settings ***
Documentation    1. Navigate to https://google.co.nz
...             2. Search by “Maui” should have a link to ‘maui-rentals.com’ in the returns results
...             3. Search by “Brtiz” should have a link to ‘britz.com’ in the returns results
Library  SeleniumLibrary
Library   Collections
Suite Setup     Open Browser    ${URL}   Chrome
Suite Teardown  Close All Browsers
 
 
*** Variables ***
${URL}              http://www.google.co.nz
${BROWSER}          Chrome   options=executable_path="/Users/vikram/PycharmProjects/robotframework/chromedriver";
${Locator_Search}   name:q
 
*** Test Cases ***
Google Search for "Maui" and verify Link "maui-rentals.com"
    Given User is on Google search page
    When User search for Maui
    Then Page should have link of maui-rentals.com

Google Search for "Brtiz" and verify Link "britz.com"
    Given User is on Google search page
    When User search for Brtiz
    And User selects for Britz
    Then Page should have link of britz.com

*** Keywords ***
User is on Google search page
    Wait Until Element Is Visible   ${Locator_Search}

User search for ${Search_text}
    Set Test Variable    ${Search_text}
    Input Text  ${Locator_Search}   ${Search_text}
    Wait Until Element Does Not Contain    ${Locator_Search}   ${Search_text}
    Press Keys  ${Locator_Search}   RETURN

Page should have link of ${Match_link_text_url}
    ${list_links}=   Get list of links on page for search text   ${Search_text}
    Log List   ${list_links}
    Should Not Be Empty   ${list_links}
    List Should Contain Value   ${list_links}    https://www.${Match_link_text_url}/nz/en

User selects for ${text}
    ${related_matches}=   Run Keyword And Return Status    Element Should Be Visible   //*[@id="taw"]
    Run Keyword If   ${related_matches}    Click Element   	xpath:.//i[contains(., '${text}')]
    Run Keyword If   ${related_matches}    Wait Until Element Is Not Visible    //*[@id="taw"]   timeout=8secs

Get list of links on page for search text
    [Arguments]   ${match_text}
    Wait Until Location Contains   ${match_text}
    Capture PAge Screenshot
    ${list_of_links}=   Get WebElements    partial link:${match_text}
    ${text_url_in_links}=    Create List
    FOR   ${x}   IN   @{list_of_links}
        Scroll Element Into View    ${x}
        ${y}=   Get Element Attribute    ${x}   href
        Append To List   ${text_url_in_links}   ${y}
    END
    [Return]    ${text_url_in_links}
