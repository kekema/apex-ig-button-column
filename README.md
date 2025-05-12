# apex-ig-button-column
Enabling a button column in IG, displaying a button in every row. DA's (on click) can be attached or an action can be specified (from the action framework) for any button click follow up. In case of a DA, the this.data object will contain the row data. There is support for conditional enabling and for button label/class substitution, based on the row data.

![image](https://github.com/kekema/apex-ig-button-column/blob/main/ig-button-column-preview.jpg)
Next settings are supported:

![image](https://github.com/user-attachments/assets/08d0836d-5abf-4ec4-b67b-4c01e5ea0347)

As said, for a DA on click, the this.data object has the row data:

![image](https://github.com/user-attachments/assets/b6e3477e-7bcc-4bf1-ae56-73e567f469d2)

this.data.contextRecord has the record from the model. As an alternative, you also find the row data in this.data.contextData in the form of easily accessible native values (for example, the model record has a date as a formatted date; the contextData object has that same date as an ISO string, eg 2024-01-26T13:00:00).

When making use of conditional enabling of buttons, it is important to have the column Source Type as 'None'. 
![image](https://github.com/user-attachments/assets/173a9b65-93a8-437a-b9a4-99545d6c6788)

So the column won't have any values. Reasons is, when a button is disabled, any button column value won't be submitted upon a row save, resulting in a Session State Violation error in case initially there was a value.

Compatibility of the plugin is with APEX 24.2
