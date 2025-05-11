# apex-ig-button-column
Enabling a button column in IG, displaying a button in every row. DA's (on click) can be attached or an action can be specified (from the action framework) for any button click follow up. There is support for conditional enabling and for button label/class substitution, based on the row data.

![image](https://github.com/kekema/apex-ig-button-column/blob/main/ig-button-column-preview.jpg)
Next settings are supported:

![image](https://github.com/user-attachments/assets/08d0836d-5abf-4ec4-b67b-4c01e5ea0347)

When making use of conditional enabling of buttons, it is important to have the column Source Type as 'None'. So the column won't have any values. Reasons is, when a button is disabled, any button column value won't be submitted upon a row save, resulting in a Session State Violation error in case initially there was a value.
