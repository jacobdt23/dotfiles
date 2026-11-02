CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra $(shell pkg-config --cflags libadwaita-1 gtk4)
LIBS ?= $(shell pkg-config --libs libadwaita-1 gtk4)

SRCS = src/main.c \
       src/utils/command.c \
       src/utils/hyprctl.c \
       src/pages/bluetooth.c \
       src/pages/network.c \
       src/pages/audio.c \
       src/pages/displays.c \
       src/pages/themes.c \
       src/pages/appearance.c \
       src/pages/wallpaper.c \
       src/pages/input.c \
       src/pages/shortcuts.c \
       src/pages/defaultapps.c \
       src/pages/power.c \
       src/pages/about.c

OBJS = $(SRCS:.c=.o)
TARGET = hypr-settings

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

install: $(TARGET)
	install -Dm755 $(TARGET) $(HOME)/.local/bin/$(TARGET)
	install -Dm644 src/style.css $(HOME)/.local/share/hypr-settings/style.css
	ln -sf $(HOME)/.local/bin/$(TARGET) $(HOME)/.local/bin/jacob-control-center

.PHONY: all clean install
