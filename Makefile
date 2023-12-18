# Variables
NAME = form

CC = c++										# Compiler and compiler flags
CFLAGS = -Werror -Wall -Wextra -std=c++98
DEPFLAGS = -MMD -MP

RM = rm -rf										# Command for removing files and directories
MKDIR = mkdir -p								# Command for creating directories

OBJ_DIR = obj									# Directories 
DEP_DIR = dep
INC_DIR = inc

SRC = $(wildcard *.cpp **/*.cpp **/*/*.cpp) 
OBJS = $(SRC:%.cpp=$(OBJ_DIR)/%.o)				# substitution syntax

NONE='\033[0m'									# Define colors for terminal output
GREEN='\033[32m'
CURSIVE='\033[3m'
GRAY='\033[2;37m'

all: $(NAME)									# Default target (build the executable)

-include $(wildcard $(DEP_DIR)/*.d)				# Include dependency files
INC_FLAGS = -I$(INC_DIR)						# look for header files

$(NAME): $(OBJS)
	@$(CC) $(OBJS) $(CFLAGS) -o $(NAME)
	@echo $(GREEN)"- Compiled -"$(NONE)

$(OBJ_DIR)/%.o: %.cpp							# Build rule for each object file
	@echo $(CURSIVE) "     - Building $<" $(NONE)
	@$(MKDIR) $(@D)
	@$(MKDIR) $(DEP_DIR)
	@$(CC) $(CFLAGS) $(DEPFLAGS) $(INC_FLAGS) -c $< -o $@
	@mv $(OBJ_DIR)/$*.d $(DEP_DIR)/
# @echo "Dependencies for $*:" 					# uncomment this to debug your dependencies
# @cat $(DEP_DIR)/$*.d							# uncomment this to debug your dependencies

clean:
	@$(RM) $(OBJS) $(OBJ_DIR) $(DEP_DIR) > /dev/null || true
	@echo $(CURSIVE)$(GRAY) "     - Object files, dependencies, and $(NAME) removed" $(NONE)

fclean: clean									# Remove the executable
	@$(RM) $(NAME) > /dev/null || true
	@echo $(CURSIVE)$(GRAY) "     - $(NAME) removed" $(NONE)

re: fclean all									# Rebuild the project by cleaning and building again

.PHONY: all clean fclean re
