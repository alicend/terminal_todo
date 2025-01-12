# TODOファイルのパスを定義
TODO_FILE="$HOME/.todo_list"

# TODOリストファイルを初期化
initialize_todo_file() {
    if [ ! -f "$TODO_FILE" ]; then
        touch "$TODO_FILE"
    fi
}

# タスクを追加
add_task() {
    initialize_todo_file
    local task="$1"
    if [ -z "$task" ]; then
        echo "タスク名を入力してください。"
        return 1
    fi
    echo "$task" >> "$TODO_FILE"
    echo "タスクを追加しました: $task"
}

# タスクを削除
delete_task() {
    initialize_todo_file
    local num="$1"
    if [ -z "$num" ] || ! [[ "$num" =~ ^[0-9]+$ ]]; then
        echo "削除するタスク番号を指定してください。"
        return 1
    fi
    if [ ! -s "$TODO_FILE" ]; then
        echo "TODOリストは空です。"
        return 1
    fi
    if [ "$num" -le 0 ] || [ "$num" -gt "$(wc -l < "$TODO_FILE")" ]; then
        echo "無効な番号です。"
        return 1
    fi
    sed -i "" "${num}d" "$TODO_FILE"
    echo "タスク $num を削除しました。"
}

# タスクを全て削除
clear_task() {
    initialize_todo_file
    if [ ! -s "$TODO_FILE" ]; then
        echo "TODOリストは空です。"
        return 1
    fi
    read -p "本当に全てのタスクを削除しますか？ (y/n): " confirmation
    if [[ "$confirmation" != "y" ]]; then
        echo "削除をキャンセルしました。"
        return 1
    fi
    > "$TODO_FILE"  # ファイルを空にする
    echo "全てのタスクを削除しました。"
}

# タスクを一覧表示
list_tasks() {
    initialize_todo_file
    if [ ! -s "$TODO_FILE" ]; then
        echo "TODOリストは空です。"
    else
        nl -w1 -s'. ' "$TODO_FILE"
    fi
}

# TODOの個数を取得
todo_count() {
    initialize_todo_file
    wc -l < "$TODO_FILE" | tr -d ' '
}

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
    *)
        echo "使用方法: todo {add|delete|clear|list|count}"
        ;;
esac
