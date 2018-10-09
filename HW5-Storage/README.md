## HW5 - Storage

**Features highlight:**

\*`PropertyListEncoder` is used to encode and decode the data.

\*Search bar is added to the main table view. The search bar currently supports case-insensitive searching for all matched people given: 
1. Any part of an input first name or last name. 
2. Any part of an input team name (only applicable to students). 
3. A specified degree (MS, Meng, BS, PhD, other, and NA). 

Clear the input on the search bar to return to the original table view. You can also delete a person cell from the search results.

\*Segmented controls (`UISegmentedControl`) are used to replace the original UITextFields for input gender, role, and degree information.

\*Pop-up messages (`UIAlertController`) are used to display the error messages when invalid user input is detected.

\*Keyboard is dismissed when the user clicks anywhere outside the input text fields or taps the return key.

\*UI improvements, including a customized fancy transition animation is added to the segue between the information view and the drawing view, and additional colors, fonts, and images.

\*More strict error checking, including unintentional extra whitespaces checking and input case-sensitive checking. For example, if "Michael Jackson" is already in the class, neither "michael jackson" (and other similar input with same letters but different upper/lower cases) nor "Michael Jackson     " (and other similar input that has leading and trailing whitespaces) would be added to the class since these inputs are considered as the duplicates.

**Notes:**

\*The App is built with Xcode 10, and was tested on an iPhone 6/7/8 simulator.

\*It is assumed that 'team' input is **only applicable to students**. 

\*It is assumed that the professor section and TA section would not be deleted, so the functionality of swiping left to delete a cell within the professor's section or the TAs' section is **disabled**.

\*It is assumed that once successfully added to the class, the name of a person **cannot** be modified.

\*Based on my data structure used, the teams displayed in the table are able to maintain a persistent ordering that is sorted by the creation time of each team, i.e. the earlier a given team is created, the earlier that team will be displayed in the table.




## HW4 - Graphics

\* Refactored all HWs on Oct. 3

\* "Flip" button is only available for myself (Yifan Li)

\* Added rotation effect for the soccer image

\* A crowd cheering audio is added to the drawing view 




## HW3 - Table VC

**Extra features added:**

\*"Team" field has been added to person information screen and to the data model. "Team" field only applies to students.

\*More detailed person description message, including degree information and team information if applicable.

\*More detailed table view cell design, including the avatar image view. Clear button is enabled in all editable text fields.

\*All the files are well organized based on MVC pattern.

\*Dismiss the keyboard when the user clicks outside of text fields or presses the return key.





## HW2 - View

**Features added:**

\*Add button has the "update" functionality and now becomes the "Add/Update" button.

\*The keyboard is dismissed whenever the user clicks outside of text fields.

\*Nicer looking fonts. Use of colors, style and imageView.

\*Extensive error checking. I apply a strict rule that requires all text fields be entered to add or update a person's information. Only first name and last name are needed to find someone's information.
As for degree information, all inputs besides MS, BS, NA, PhD, and MENG are classified as "other". Gender and role must be chosen from the options provided.
Also, the maximum number of hobbies and programming languages is 3.







## HW1 - Playground


**Features added:**

\* More class properties, including age, alma mater, and NetID, etc.

\* Search for people by NetID.

\* Search for people who love a specific programming language.

\* Additional classmates' information.

\* Specific information checking. Ex: Gender and pronoun checking (he/she), 
    degree information checking (received/will receive BS degree)
    
` P.S. It may take a while (~30 seconds) to run the entire code and display the results in the console. Thanks for your patience.`
