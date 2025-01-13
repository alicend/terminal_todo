#!/bin/bash

TODO_DIR="$HOME/.todo_terminal"
TODO_FILE="$TODO_DIR/todo_list"
CONFIG_FILE="$TODO_DIR/config"
LANGUAGE="en"  # デフォルト言語

# ディレクトリとファイルを初期化
initialize_todo_dir() {
    if [ ! -d "$TODO_DIR" ]; then
        mkdir -p "$TODO_DIR"
        echo "create TODO directory: $TODO_DIR"
    fi
    if [ ! -f "$TODO_FILE" ]; then
        touch "$TODO_FILE"
        echo "create TODO file: $TODO_FILE"
    fi
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "LANGUAGE=en" > "$CONFIG_FILE"
        echo "create config file: $CONFIG_FILE"
    fi
}

# 設定をロード
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
}

# メッセージ定義
messages() {
    case "$LANGUAGE" in
        en)
            case "$1" in
                init_dir) echo "Initializing TODO directory and files...";;
                add_success) echo "Task added: $2";;
                add_empty) echo "Please provide a task name.";;
                delete_invalid) echo "Please specify a valid task number to delete.";;
                delete_success) echo "Task $2 deleted.";;
                delete_empty) echo "TODO list is empty.";;
                clear_confirm) echo "Are you sure you want to clear all tasks? (y/n): ";;
                clear_success) echo "All tasks cleared.";;
                clear_cancel) echo "Clear operation cancelled.";;
                list_empty) echo "TODO list is empty.";;
                usage) echo "Usage: todo {add|delete|clear|list|count|lang}";;
            esac
            ;;
        ja)
            case "$1" in
                init_dir) echo "TODOディレクトリとファイルを初期化しています...";;
                add_success) echo "タスクを追加しました: $2";;
                add_empty) echo "タスク名を入力してください。";;
                delete_invalid) echo "削除するタスク番号を指定してください。";;
                delete_success) echo "タスク $2 を削除しました。";;
                delete_empty) echo "TODOリストは空です。";;
                clear_confirm) echo "本当に全てのタスクを削除しますか？ (y/n): ";;
                clear_success) echo "全てのタスクを削除しました。";;
                clear_cancel) echo "削除をキャンセルしました。";;
                list_empty) echo "TODOリストは空です。";;
                usage) echo "使用方法: todo {add|delete|clear|list|count|lang}";;
            esac
            ;;
    esac
}

# タスクを追加
add_task() {
    local task="$1"
    if [ -z "$task" ]; then
        messages add_empty
        return 1
    fi
    echo "$task" >> "$TODO_FILE"
    messages add_success "$task"
}

# タスクを削除
delete_task() {
    local num="$1"
    if [ -z "$num" ] || ! [[ "$num" =~ ^[0-9]+$ ]]; then
        messages delete_invalid
        return 1
    fi
    if [ ! -s "$TODO_FILE" ]; then
        messages delete_empty
        return 1
    fi
    if [ "$num" -le 0 ] || [ "$num" -gt "$(wc -l < "$TODO_FILE")" ]; then
        messages delete_invalid
        return 1
    fi
    sed -i "" "${num}d" "$TODO_FILE"
    messages delete_success "$num"
}

# タスクを全て削除
clear_task() {
    if [ ! -s "$TODO_FILE" ]; then
        messages delete_empty
        return 1
    fi
    read -p "$(messages clear_confirm)" confirmation
    if [[ "$confirmation" != "y" ]]; then
        messages clear_cancel
        return 1
    fi
    > "$TODO_FILE"
    messages clear_success
}

# タスクを一覧表示
list_tasks() {
    if [ ! -s "$TODO_FILE" ];then
        messages list_empty
    else
        nl -w1 -s'. ' "$TODO_FILE"
    fi
}

# TODOの個数を取得
todo_count() {
    wc -l < "$TODO_FILE" | tr -d ' '
}

# 言語を設定
set_language() {
    case "$1" in
        en)
            LANGUAGE="$1"
            echo "LANGUAGE=$LANGUAGE" > "$CONFIG_FILE"
            echo "Language has been changed to: English"
            ;;
        ja)
            LANGUAGE="$1"
            echo "LANGUAGE=$LANGUAGE" > "$CONFIG_FILE"
            echo "言語が日本語に変更されました。"
            ;;
        *)
            case "$LANGUAGE" in
                ja)
                    echo "サポートされていない言語です。「ja」または「en」を指定してください。"
                    ;;
                *)
                    # デフォルトは英語
                    echo "Unsupported language. Please specify 'ja' or 'en'."
                    ;;
            esac
            ;;
    esac
}

# 初期化
initialize_todo_dir
load_config

# メインコマンド
case "$1" in
    add)
        shift
        add_task "$*"
        ;;
    delete)
        shift
        delete_task "$1"
        ;;
    clear)
        clear_task
        ;;
    list)
        list_tasks
        ;;
    count)
        todo_count
        ;;
    lang)
        shift
        set_language "$1"
        ;;
    *)
        messages usage
        ;;
esac
