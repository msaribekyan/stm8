TARGET := stm8test

SRC := src
OBJ := obj
INC := inc
BIN := bin

CC := sdcc
CFLAGS := --Werror --std-sdcc99 -mstm8 -I $(INC)
LDFLAGS = -lstm8 -mstm8 --out-fmt-ihx

FLASH := stm8flash
FFLAGS := -cstlinkv2 -pstm8s003f3

OUT=$(BIN)/$(TARGET).ihx
SRC_FILES := \
main.c

OBJ_FILES := $(SRC_FILES:.c=.rel)
OBJS := $(addprefix $(OBJ)/, $(OBJ_FILES))

all: $(OUT)

srcs/%.o: srcs/%.c

$(OUT): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

$(OBJ)/%.rel: $(SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

flash: $(OUT)
	$(FLASH) $(FFLAGS) -w $(OUT)

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f $(OUT)

re: fclean all
