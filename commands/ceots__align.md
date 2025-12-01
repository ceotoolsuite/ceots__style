Align $ARGUMENTS with CEOTS EcmaScript Style.

Work through each convention from style.md one by one:
1. Read the target file
2. Create a todo list of violations found
3. Fix each violation with a separate edit
4. Do not batch multiple fixes into one edit

Key rules to check:
- var not const/let
- snake_case not camelCase
- Semicolons on every statement
- Trailing commas in multi-line structures
- async/await not .then()
- Remove comments (except // todo: and // note:)
- Console.log patterns (::, >>=, <==, !!!)
