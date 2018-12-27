from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

BACKGROUND = 17
LINE = 59
FOREGROUND = 231
COMMENT = 61
CYAN = 117
GREEN = 84
ORANGE = 215
PINK = 212
PURPLE = 141
RED = 203
YELLOW = 228

class Default(ColorScheme):
    progress_bar_color = GREEN

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                fg = RED
                bg = default
            if context.border:
                fg = PURPLE
            if context.media:
                if context.image:
                    fg = ORANGE
                else:
                    fg = PINK
            if context.container:
                fg = GREEN
            if context.directory:
                attr |= bold
                fg = CYAN
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                fg = GREEN
            if context.socket:
                fg = PINK
                attr |= bold
            if context.fifo or context.device:
                fg = ORANGE
                if context.device:
                    attr |= bold
            if context.link:
                fg = PINK
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (RED, PINK):
                    fg = white
                else:
                    fg = RED
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = ORANGE
            if context.badinfo:
                if attr & reverse:
                    bg = PINK
                else:
                    fg = PINK

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = context.bad and RED or GREEN
            elif context.directory:
                fg = CYAN
            elif context.tab:
                if context.good:
                    fg = black
                    bg = GREEN
            elif context.link:
                fg = CYAN

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = CYAN
                elif context.bad:
                    fg = PINK
            if context.marked:
                attr |= bold | reverse
                fg = ORANGE
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = RED
            if context.loaded:
                bg = self.progress_bar_color
                fg = black
            if context.vcsinfo:
                fg = GREEN
                attr &= ~bold
            if context.vcscommit:
                fg = ORANGE
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = CYAN

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = PINK
            elif context.vcschanged:
                fg = RED
            elif context.vcsunknown:
                fg = RED
            elif context.vcsstaged:
                fg = GREEN
            elif context.vcssync:
                fg = GREEN
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = GREEN
            elif context.vcsbehind:
                fg = RED
            elif context.vcsahead:
                fg = CYAN
            elif context.vcsdiverged:
                fg = PINK
            elif context.vcsunknown:
                fg = RED

        return fg, bg, attr
