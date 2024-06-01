#!/bin/bash

TODO_FILE="tasks.csv"

# Load tasks if file doesn't exist
if [[ ! -f $TODO_FILE ]]; then
    touch $TODO_FILE
fi

# Function to create a task
create_task() {
    echo "Creating a new task..."
    read -rp "Enter title (required): " title
    if [[ -z "$title" ]]; then
        echo "Error: Title is required." >&2
        return
    fi

    read -rp "Enter due date and time (YYYY-MM-DD HH:MM, required): " due_date
    if ! date -d "$due_date" &>/dev/null; then
        echo "Error: Invalid date format. Please use YYYY-MM-DD HH:MM." >&2
        return
    fi

    read -rp "Enter description (optional): " description
    read -rp "Enter location (optional): " location
    local completed="false"

    echo "$title,$due_date,$description,$location,$completed" >> $TODO_FILE
    echo "Task created successfully."
}

# Function to update a task
update_task() {
    echo "Updating a task..."
    read -rp "Enter task ID to update: " task_id
    if ! [[ "$task_id" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid task ID." >&2
        return
    fi

    local task=$(sed -n "${task_id}p" $TODO_FILE)
    if [[ -z "$task" ]]; then
        echo "Error: Task not found." >&2
        return
    fi

    IFS="," read -r _ title due_date description location completed <<< "$task"

    read -rp "Enter title (current: $title): " new_title
    [ -n "$new_title" ] && title="$new_title"

    read -rp "Enter due date and time (current: $due_date, YYYY-MM-DD HH:MM): " new_due_date
    if [ -n "$new_due_date" ]; then
        if ! date -d "$new_due_date" &>/dev/null; then
            echo "Error: Invalid date format." >&2
            return
        fi
        due_date="$new_due_date"
    fi

    read -rp "Enter description (current: $description): " new_description
    [ -n "$new_description" ] && description="$new_description"

    read -rp "Enter location (current: $location): " new_location
    [ -n "$new_location" ] && location="$new_location"

    read -rp "Is task completed? (yes/no, current: $completed): " new_completed
    if [[ "$new_completed" == "yes" ]]; then
        completed="true"
    elif [[ "$new_completed" == "no" ]]; then
        completed="false"
    fi

    sed -i.bak "${task_id}s/.*/$title,$due_date,$description,$location,$completed/" $TODO_FILE
    echo "Task updated successfully."
}

# Function to delete a task
delete_task() {
    echo "Deleting a task..."
    read -rp "Enter task ID to delete: " task_id
    if ! [[ "$task_id" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid task ID." >&2
        return
    fi

    if ! sed -i.bak "${task_id}d" $TODO_FILE; then
        echo "Error: Task not found." >&2
    else
        echo "Task deleted successfully."
    fi
}

# Function to show a task
show_task() {
    echo "Showing a task..."
    read -rp "Enter task ID to show: " task_id
    if ! [[ "$task_id" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid task ID." >&2
        return
    fi

    local task=$(sed -n "${task_id}p" $TODO_FILE)
    if [[ -z "$task" ]]; then
        echo "Error: Task not found." >&2
        return
    fi

    IFS="," read -r title due_date description location completed <<< "$task"
    echo "ID: $task_id"
    echo "Title: $title"
    echo "Due Date: $due_date"
    echo "Description: $description"
    echo "Location: $location"
    echo "Completed: $completed"
}

# Function to list tasks for a specific day
list_tasks() {
    echo "Listing tasks for a specific day..."
    read -rp "Enter date (YYYY-MM-DD): " date_str
    if ! date -d "$date_str" &>/dev/null; then
        echo "Error: Invalid date format." >&2
        return
    fi

    local completed_tasks=$(grep ",$date_str [0-9][0-9]:[0-9][0-9],.*,.*,true" $TODO_FILE)
    local uncompleted_tasks=$(grep ",$date_str [0-9][0-9]:[0-9][0-9],.*,.*,false" $TODO_FILE)

    echo "Completed tasks:"
    echo "$completed_tasks"

    echo "Uncompleted tasks:"
    echo "$uncompleted_tasks"
}

# Function to search for a task
search_task() {
    echo "Searching for a task..."
    read -rp "Enter search term: " search_term
    grep -i "$search_term" $TODO_FILE
}

# Function to show tasks of the current day
show_today_tasks() {
    local today=$(date +%Y-%m-%d)
    list_tasks $today
}

# Main program loop
if [[ $# -eq 0 ]]; then
    show_today_tasks
    exit 0
fi

case "$1" in
    create) create_task ;;
    update) update_task ;;
    delete) delete_task ;;
    show) show_task ;;
    list) list_tasks ;;
    search) search_task ;;
    *) echo "Usage: $0 {create|update|delete|show|list|search}" >&2 ;;
esac
