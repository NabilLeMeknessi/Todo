# Todo

## Introduction
This project is a simple task management system implemented as a Bash script. It provides a command-line interface for managing tasks, making it ideal for users who prefer to work in a terminal environment. Despite its simplicity, it offers a range of features typically found in more complex task management systems.

## Design Choices

### Data Storage
The tasks are stored in a CSV file named `tasks.csv`. Each task is represented as a row in the CSV file, with columns for the title, due date, description, location, and completion status. This format was chosen for its simplicity and ease of use with standard Unix utilities such as `awk` and `sed`.

### Code Organization
The code is organized into functions, each of which performs a specific task such as creating a task, updating a task, deleting a task, listing tasks, or searching for a task. This modular design makes the code easier to understand and maintain.

## Features

### Create a Task
Users can create a new task by entering details such as the title and due date. The script will prompt the user for each of these details, ensuring that all necessary information is captured. The description and location fields are optional.

### Update a Task
Users can update an existing task by entering the task ID and the new details. The script will prompt the user for each detail, allowing them to change any aspect of the task. This makes it easy to adjust task details as circumstances change.

### Delete a Task
Users can delete an existing task by entering the task ID. This is a straightforward operation, but it should be used with caution, as deleted tasks cannot be recovered.

### Show a Task
Users can view the details of a specific task by entering the task ID. This allows for quick access to all the information associated with a particular task.

### List Tasks for a Specific Day
Users can list tasks for a specific day, separated into completed and uncompleted sections. This provides a clear overview of what needs to be done on any given day.

### Search for a Task
Users can search for tasks by entering a search term. The script will search all fields of all tasks for the search term, providing a powerful tool for finding specific tasks.

### Show Today's Tasks
When invoked without arguments, the script lists tasks for the current day, separated into completed and uncompleted sections.

## Usage
To use this script, simply run it in a Bash shell:

```sh
/bin/bash /path/to/todo.sh
