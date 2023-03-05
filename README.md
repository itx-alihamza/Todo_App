# Flutter App Folder Structure Template
My goal creating this is I want to make a clean and modular flutter project :)


## How to use?
For example you want to create a login page. Here is what you have to do.
1. Create folder login inside `lib/views/pages`.
2. Create file `login.dart` as the main file and `_login.dart` to place your necessary modules import in `lib/views/pages/login`.
3. In `_login.dart` below the modules import, add `part "login.dart"`.
4. In `login.dart` add `part of "_login.dart"` as the first line.
5. Add `export "../pages/login/_login.dart"` in `lib/views/pages/_pages.dart`.
6. That's all, now you can use login wherever you want :D.

_notes: you can use these steps for everything (models, utils, pages, and widgets)._

---

originally this folder structure made by [Fadhlan](https://github.com/fadhlanhasyim) in our group project back then in my 3rd semester.

---

Will update this template along the time.

`Last update: March 5th, 2023`
