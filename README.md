# Zemoga

- To run the app, just open XCode 11.*, select one of the available simulators and run the project.

- To easily run Unit tests, open with XCode *"ZemogaTestTests.swift"* file and click the play button on the left side inside the line numbers column.
 
- Apple's MVC pattern
Since is a small and quick app, there is no risk to end having huge ViewControllers, so I thought Apple'sMVC patter fits good on this project.
ViewControllers act as bridge between the views and the model.

- Project structure:
There are a groupd of three models: Post, User, Comment. These models use "CodingKeys" as away to keep a map of API parameter names and the names used inside each model. Also they are structs instead of classes, because as they are, the do not need to inherite anything.
A view and a view controller for the post list and for the post detail (where the user info and post comments appear).
There is a file (NetworkManager.swift) which manages all the networking. Inside this file, there is also a small struct used to decode data.This data decoder es used to parse the Web service answers to the objects I need. For this reason the functions that decodes deals with generics.

-- Additional comments:
Cells can ve deleted swiping to the left,the cell that needsto be deleted, following Apple's guidelines on this matter.
When the table getsempty, ananimated view appears indicating it and viceversa, it dissapears when table is filled again.

- Third Party libraries used
    - Alamofire: To handle the API calls
    -  KRProgressHUD: To show an activity indicator while the APIcalls arerunning on background

-- iOS deployment target: 13.5
-- Swift version: 5


-- Potential improvements
- Add more unit tests for the views.
- Get a more general method tomake API calls.

-- Known issues
- If a cell is removed while the table is stillsliding, the app will crash.

-- IMPORTANT ASSUMPTION
- The refresh action intention was not very clear to me, so I assumed it was to REFRESH ALL, meaning to get again the whole list with all details as in the first call (including unread/favorite details)
