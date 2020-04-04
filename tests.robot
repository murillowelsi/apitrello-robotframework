*** Settings ***
Documentation    Tests using the Trello API
Library          RequestsLibrary
Library          Collections

*** Variables ***
${BASE_URL}    https://api.trello.com/1
${KEY}         178abd63edc86db7e1198a5148d7b0e9
${TOKEN}       f72b1a6aa481263286a2334a65dedb73d56d003ab2ade77708a1d312d1bf4851


*** Test Cases ***
Search Board
    Trello Session
    List Board By ID    xUezf5qu

Creating New Boards
    Trello Session
    Create Board      RobotFrameworkBoardTest
    FOR    ${LIST}    IN RANGE      1   10
        Create List       CARD ${LIST}
    END
    Sleep             15s
    Delete Board


*** Keywords ***
Trello Session
    Create Session    alias=trelloBoards    url=${BASE_URL}    disable_warnings=True

List Board By ID
    [Arguments]    ${BOARD_ID}
    &{PARAMS}      Create Dictionary     fields=name,url            key=${KEY}            token=${TOKEN}
    ${RESPONSE}    Get Request           uri=/boards/${BOARD_ID}    alias=trelloBoards    params=${PARAMS}
    Log            ${RESPONSE.json()}

Create Board
    [Arguments]                           ${BOARD_NAME}
    &{PARAMS}                             Create Dictionary        name=${BOARD_NAME} defaultLabels=true    defaultLists=true            keepFromSource=none    prefs_permissionLevel=private
    ...                                   prefs_voting=disabled    prefs_comments=members                   prefs_invitations=members    prefs_selfJoin=true    prefs_cardCovers=true            
    ...                                   prefs_background=blue    prefs_cardAging=regular                  key=${KEY}                   token=${TOKEN}
    ${RESPONSE}                           Post Request             uri=/boards                              alias=trelloBoards           params=${PARAMS}       
    Set Suite Variable	${BOARD_VALUES}    ${RESPONSE.json()}

Delete Board
    &{PARAMS}      Create Dictionary    key=${KEY}                           token=${TOKEN}
    ${RESPONSE}    Delete Request       uri=/boards/${BOARD_VALUES['id']}    params=${PARAMS}    alias=trelloBoards
    Log            ${BOARD_VALUES}	

Create List
    [Arguments]    ${LIST_NAME}
    &{PARAMS}      Create Dictionary      name=${LIST_NAME}    idBoard=${BOARD_VALUES['id']}    key=${KEY}            token=${TOKEN}
    ${RESPONSE}    Post Request           uri=/lists           params=${PARAMS}                 alias=trelloBoards
    Log            ${RESPONSE.content}