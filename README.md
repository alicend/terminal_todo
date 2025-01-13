###### Language
- English
- [日本語](README-ja.md) 

# TODO App (Shell Script)

This TODO app is a simple shell script that helps you manage tasks. It allows you to easily add, delete, list, and display the number of tasks in your TODO list.

---

## 機能

- **Add Task** (`add`):
  - Adds a new task and automatically assigns a number.

- **Delete Task** (`delete`):
  - Deletes a task by specifying its number.
  
- **Clear All Tasks** (`clear`):
  - Deletes all tasks from the list.

- **List Tasks** (`list`):
  - Displays the current TODO list.

- **Count Tasks** (`count`):
  - Displays the number of tasks currently in the TODO list.

- **Set Language** (`lang`):
  - Set the language to either English or Japanese.

---

## Installation

1. Download the script file and save it to any directory of your choice.
2. Open the terminal and navigate to the directory where todo.sh is stored.
3. Grant execute permissions to the script.

```zsh
chmod +x todo.sh
```

---

## Dependencies

- This script works in an environment where **zsh** is installed.
- No special libraries or tools are required.

---

## Display Task Count in Prompt (zsh)

To display the number of TODO tasks in your terminal prompt, add the following to your .zshrc file:

```zsh
precmd() {
    local todo_count=$(bash ~/todo.sh count) # Specify the appropriate directory where todo.sh is stored
    PS1="%~ [TODO: $todo_count] \$ "
}
```

To apply the changes to the current shell, run the following command:

```zsh
source ~/.zshrc
```

---

## Create Aliases (zsh)

To easily run the TODO script, create an alias by adding the following to your .zshrc file:

```zsh
alias todo="bash ~/todo.sh" # Specify the appropriate directory where todo.sh is stored
```

To apply the changes to the current shell, run the following command:

```zsh
source ~/.zshrc
```

---
