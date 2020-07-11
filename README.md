# Zemoga


-- ASSUMPTIONS
- The refresh action intention was not very clear to me, soI assumed it was toREFRESH ALL, meaning toget again thewhole list with all details as in the first call(including unread/favorite details)
-  Third Party libraries
    - Alamofire
    
- Using Core Data to persist data

- Apple's MVC pattern
Since is a smalland quick app, there is no risk to end habing huge ViewControllers, so I thought Apple'sMVC patter fits good on this project.
ViewControllers act as bridge between the views and the model.

- Project structure:


--[Add ios version target] !!!!!!

--GENERAL notes:

-models CodingKeys // (The API used for thisexample match the model names, but still is good practice to keep this method updated for when API changes its keynames)

- Models arestructs since they donot need to hinerit from any other class
- Potential improvements
