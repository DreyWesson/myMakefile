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
