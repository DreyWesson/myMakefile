
# My Makefile Explanation

This markdown explains the basic logic of my makefile to future ME.

# Project Makefile Explanation

This README provides a comprehensive breakdown of the structure and functionality of the provided Makefile for a C++ project.

## Table of Contents

- [Variables](#variables)
- [Create Executables](#create-executables)
- [Include Dependencies](#include-dependencies)
- [Debuging Dependencies](#debuging-dependencies)
- [Generate Object Files](#generate-object-files)
- [Build rule for each object file](#build-rule-for-each-object-file)
- [Clean Up Object Files and Deps](#clean-up-object-files-and-deps)
- [Rebuild](#rebuild)

## Variables

```make
# Define the name of the target executable
NAME = form

# Compiler and compiler flags
CC = c++
CFLAGS = -Werror -Wall -Wextra -std=c++98
DEPFLAGS = -MMD -MP

# Command for removing files and directories
RM = rm -rf

# Command for creating directories
MKDIR = mkdir -p

# DIRECTORIES
OBJ_DIR = obj # Object files directory
DEP_DIR = dep # Dependency files directory
INC_DIR = inc  # Include files directory - Specify the directory of your header files

# Get all .cpp files in the root directory and its subdirectories
SRC = $(wildcard *.cpp **/*.cpp **/*/*.cpp)

# Generate a list of object files by replacing .cpp with .o
OBJS = $(SRC:%.cpp=$(OBJ_DIR)/%.o)

# Define colors for terminal output
NONE='\033[0m'
GREEN='\033[32m'
CURSIVE='\033[3m'
GRAY='\033[2;37m'
```

## Create Executables
```make
$(NAME): $(OBJS)
	@$(CC) $(OBJS) $(CFLAGS) -o $(NAME)
	@echo $(GREEN)"- Compiled -"$(NONE)

'$(NAME): $(OBJS)': This line defines a target named $(NAME) (in your case, "form"). It depends on the list of object files specified by $(OBJS). This means that before building the executable $(NAME), the object files listed in $(OBJS) must be built.

@$(CC) $(OBJS) $(CFLAGS) -o $(NAME): This is the command to link the object files and create the executable. It uses the compiler specified by $(CC) (in your case, "c++") and includes the object files $(OBJS). The compiler flags are provided by $(CFLAGS). The -o flag is used to specify the output file, and $(NAME) is the name of your target executable.

@echo $(GREEN)"- Compiled -"$(NONE): This command prints a message to the terminal indicating that the compilation is complete. The $(GREEN) and $(NONE) are variables containing ANSI escape codes for colored output. In this case, it prints the message in green, making it visually distinct.
The @ symbol at the beginning of each command suppresses the echoing of the command itself in the terminal. This is a common practice in Makefiles to make the output cleaner.

In summary, this part of the Makefile ensures that the target executable ($(NAME)) is built by linking the specified object files ($(OBJS)) using the C++ compiler ($(CC)), and it prints a message indicating that the compilation is complete.
```



## Include Dependencies

```make
DEPFLAGS = -MMD -MP
DEP_DIR = dep
-include $(wildcard $(DEP_DIR)/*.d)
INC_FLAGS = -I$(INC_DIR)
DEPFLAGS = -MMD -MP: These are dependency generation flags used during compilation.

-MMD: Specifies that the compiler should generate dependency information as a makefile rule.
-MP: Ensures that phony target rules are generated for missing dependencies, avoiding errors during parallel builds.
DEP_DIR = dep: This variable specifies the directory where dependency files will be stored.

For example, if your source file is file.cpp, the dependency file will be dep/file.d.
-include $(wildcard $(DEP_DIR)/*.d): This line includes dependency files if they exist.

$(wildcard $(DEP_DIR)/*.d): Uses the wildcard function to get a list of all .d files in the DEP_DIR.
-include: Includes the dependency files in the Makefile. The leading dash (-) suppresses errors if the files are not found (which is common on the first build).
This line essentially includes the dependency information if it has been previously generated.

INC_FLAGS = -I$(INC_DIR): This variable specifies the include directory flags for the compiler.

-I$(INC_DIR): Instructs the compiler to look for header files in the directory specified by $(INC_DIR)

In summary, these lines are related to dependency tracking and header file inclusion during compilation:

DEPFLAGS defines flags for generating dependency files during compilation.
DEP_DIR specifies the directory for storing dependency files.
-include includes any existing dependency files.
INC_FLAGS specifies the include directory for header files during compilation
```

## Debuging Dependencies

```make
@echo "Dependencies for $*:"
@: Suppresses the echoing of the command itself in the terminal. This is a common practice in Makefiles to make the output cleaner.

echo "Dependencies for $*:": Prints a message to the console indicating that the following lines will show the dependencies for a specific target. $* is a special variable in Makefiles that represents the stem of the pattern rule. In this context, it represents the base name of the source file without the extension.

@cat $(DEP_DIR)/$*.d
@: Suppresses the echoing of the command itself in the terminal.

cat $(DEP_DIR)/$*.d: Uses the cat command to concatenate and display the contents of a file. $(DEP_DIR)/$*.d represents the dependency file corresponding to the current source file (stem). This file typically contains a list of dependencies for the source file, generated during compilation.

So, these lines together print a message indicating that the following lines will display dependencies and then display the actual dependencies for a specific source file. It's a helpful addition during debugging to understand the dependencies that the Makefile has identified for a particular target. If you no longer need this information or want to keep the output cleaner, you can remove these lines.
```

## Generate Object Files
```
OBJS = $(SRC:%.cpp=$(OBJ_DIR)/%.o)
This line uses a feature of the GNU Makefile syntax called pattern substitution. Let's break it down:

SRC: This variable contains a list of source files obtained using the wildcard function. In your case, it includes all .cpp files in the current directory and its subdirectories.

$(SRC:%.cpp=$(OBJ_DIR)/%.o): This part is the pattern substitution syntax. It says, "for each element in the $(SRC) list that ends with .cpp, replace it with the same name but change the directory to $(OBJ_DIR) and the extension to .o."

% is a wildcard character that matches any sequence of characters.
$< represents the target of the rule, which is the source file in this context.
$@ represents the target of the rule, which is the corresponding object file.
So, for each source file (%.cpp), it generates a corresponding object file (%.o) in the $(OBJ_DIR) directory. This line essentially creates a list of object files with the same base names as the source files but located in the specified object file directory.
```

## Build rule for each object file
```
$(OBJ_DIR)/%.o: %.cpp
	@echo $(CURSIVE) "     - Building $<" $(NONE)
	@$(MKDIR) $(OBJ_DIR)
	@$(MKDIR) $(DEP_DIR)
	@$(CC) $(CFLAGS) $(DEPFLAGS) $(INC_FLAGS) -c $< -o $@
	@mv $(OBJ_DIR)/$*.d $(DEP_DIR)/

$(OBJ_DIR)/%.o: %.cpp: This line defines a pattern rule for building object files. It says that any file matching the pattern %.o in the $(OBJ_DIR) directory depends on a corresponding source file with the same base name but a .cpp extension.

@echo $(CURSIVE) " - Building $<" $(NONE): This line prints a message to the console indicating that a particular source file is being built. The use of @ suppresses the printing of the command itself, making the output cleaner. $(CURSIVE) and $(NONE) are variables containing ANSI escape codes for colored output.

@$(MKDIR) $(OBJ_DIR): This line ensures that the object file directory $(OBJ_DIR) exists. If it doesn't, it creates the directory using the mkdir command. The -p option ensures that the command does not fail if the directory already exists.

@$(MKDIR) $(DEP_DIR): Similar to the previous line, this ensures that the dependency file directory $(DEP_DIR) exists.

@$(CC) $(CFLAGS) $(DEPFLAGS) $(INC_FLAGS) -c $< -o $@: This is the compilation command. It uses the C++ compiler specified by $(CC) with the flags $(CFLAGS), $(DEPFLAGS), and $(INC_FLAGS).

-c: Instructs the compiler to generate an object file.
$<: Represents the first prerequisite, which is the source file (%.cpp).
-o $@: Specifies the output file, which is the target of the rule ($(OBJ_DIR)/%.o).
@mv $(OBJ_DIR)/$*.d $(DEP_DIR)/: This line moves the dependency file generated during compilation from the object file directory ($(OBJ_DIR)) to the dependency file directory ($(DEP_DIR)). The $* represents the stem of the pattern rule (the part that matches %), which is the base name of the source file.

In summary, this rule compiles a source file into an object file, creates the necessary directories, and moves the dependency file to the appropriate directory. The @ symbol is used to suppress the echoing of the commands in the console.
```







```
# Define the name of the target executable
NAME = form

# Compiler and compiler flags
CC = c++
CFLAGS = -Werror -Wall -Wextra -std=c++98
DEPFLAGS = -MMD -MP

# Command for removing files and directories
RM = rm -rf

# Command for creating directories
MKDIR = mkdir -p

# DIRECTORIES
OBJ_DIR = obj # Object files directory
DEP_DIR = dep # Dependency files directory
INC_DIR = inc  # Include files directory - Specify the directory of your header files

# Get all .cpp files in the root directory and its subdirectories
SRC = $(wildcard *.cpp **/*.cpp **/*/*.cpp)

# Generate a list of object files by replacing .cpp with .o
OBJS = $(SRC:%.cpp=$(OBJ_DIR)/%.o)

# Define colors for terminal output
NONE='\033[0m'
GREEN='\033[32m'
CURSIVE='\033[3m'
GRAY='\033[2;37m'

# Include dependency files
-include $(wildcard $(DEP_DIR)/*.d)

# Include directory flags
INC_FLAGS = -I$(INC_DIR)
# -I$(INC_DIR): Specifies the -I flag with the include directory, ensuring that the compiler looks for header files in the specified directory.

# Default target (build the executable)# Default target (build the executable)
all: $(NAME)

# Link the object files to create the executable
$(NAME): $(OBJS)
	@$(CC) $(OBJS) $(CFLAGS) -o $(NAME)
	@echo $(GREEN)"- Compiled -"$(NONE)

# Build rule for each object file
$(OBJ_DIR)/%.o: %.cpp
	@echo $(CURSIVE) "     - Building $<" $(NONE)
	@$(MKDIR) $(OBJ_DIR)
	@$(MKDIR) $(DEP_DIR)
	@$(CC) $(CFLAGS) $(DEPFLAGS) $(INC_FLAGS) -c $< -o $@
	@mv $(OBJ_DIR)/$*.d $(DEP_DIR)/
# @echo "Dependencies for $*:" 	# uncomment this to debug your dependencies
# @cat $(DEP_DIR)/$*.d			# uncomment this to debug your dependencies

# Clean up object files and dependencies
clean:
	@$(RM) $(OBJS) $(OBJ_DIR) $(DEP_DIR) > /dev/null || true
	@$(RM) $(NAME) > /dev/null || true
	@echo $(CURSIVE)$(GRAY) "     - Object files, dependencies, and $(NAME) removed" $(NONE)

# Remove the executable
fclean: clean
	@$(RM) $(NAME) > /dev/null || true
	@echo $(CURSIVE)$(GRAY) "     - $(NAME) removed" $(NONE)

# Rebuild the project by cleaning and building again
re: fclean all

# Define these targets as phony to avoid conflicts with file names
.PHONY: all clean fclean re
```

## Clean Up Object Files and Deps

```
clean:
	@$(RM) $(OBJS) $(OBJ_DIR) $(DEP_DIR) > /dev/null || true
	@$(RM) $(NAME) > /dev/null || true
	@echo $(CURSIVE)$(GRAY) "     - Object files, dependencies, and $(NAME) removed" $(NONE)
@$(RM) $(OBJS) $(OBJ_DIR) $(DEP_DIR) > /dev/null || true: This line removes object files ($(OBJS)), the object file directory ($(OBJ_DIR)), and the dependency file directory ($(DEP_DIR)).

@: Suppresses the echoing of the command in the console.
$(RM): Uses the rm command to remove files or directories.
> /dev/null: Redirects the output of the command to /dev/null, discarding any output.
|| true: Ensures that the command does not exit with an error if any of the files or directories do not exist.
@$(RM) $(NAME) > /dev/null || true: This line removes the target executable ($(NAME)).

Similar to the previous line, it uses @$(RM) to suppress echoing, removes the executable, redirects output to /dev/null, and uses || true to avoid errors if the file does not exist.
@echo $(CURSIVE)$(GRAY) " - Object files, dependencies, and $(NAME) removed" $(NONE): This line prints a message to the console indicating that object files, dependencies, and the executable have been removed.

The message is colored using $(CURSIVE) and $(GRAY) ANSI escape codes for formatting. $(NONE) resets the color to the default.
@ suppresses the echoing of the command.
In summary, the clean target is responsible for removing object files, dependency files, and the target executable. It provides feedback to the user by printing a message indicating what has been removed. The @ symbol is used to keep the console output clean by suppressing unnecessary information.
```

## Rebuild
```
re: fclean all: This line defines a target named re (short for "rebuild"). It specifies that in order to rebuild the project, it should first execute the fclean target (which removes object files, dependencies, and the executable) and then execute the all target (which builds the project again).

## Conflicts Avoidance

.PHONY: all clean fclean re: This line declares the targets all, clean, fclean, and re as phony targets. Phony targets are not associated with actual files and are always considered out-of-date, meaning they will always be executed when requested. This is necessary to avoid conflicts with actual file names with the same names as the targets.

In summary, the re target allows you to rebuild the entire project by first cleaning it (fclean) and then building it again (all). The .PHONY declaration ensures that these targets are always considered targets, even if there are files with the same names, and they will be executed when explicitly requested.
```
