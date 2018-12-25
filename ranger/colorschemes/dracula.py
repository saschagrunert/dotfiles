from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Default(ColorScheme):
    progress_bar_color = 84

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
                fg = 203
                bg = default
            if context.border:
                fg = 84
            if context.media:
                if context.image:
                    fg = 215
                else:
                    fg = magenta
            if context.container:
                fg = 84
            if context.directory:
                attr |= bold
                fg = 117
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                fg = 84
            if context.socket:
                fg = magenta
                attr |= bold
            if context.fifo or context.device:
                fg = 215
                if context.device:
                    attr |= bold
            if context.link:
                fg = 212
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (203, magenta):
                    fg = white
                else:
                    fg = 203
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 215
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = context.bad and 203 or 84
            elif context.directory:
                fg = 117
            elif context.tab:
                if context.good:
                    fg = black
                    bg = 84
            elif context.link:
                fg = 117

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 117
                elif context.bad:
                    fg = magenta
            if context.marked:
                attr |= bold | reverse
                fg = 215
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 203
            if context.loaded:
                bg = self.progress_bar_color
                fg = black
            if context.vcsinfo:
                fg = 84
                attr &= ~bold
            if context.vcscommit:
                fg = 215
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 117

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
                fg = magenta
            elif context.vcschanged:
                fg = 203
            elif context.vcsunknown:
                fg = 203
            elif context.vcsstaged:
                fg = 84
            elif context.vcssync:
                fg = 84
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = 84
            elif context.vcsbehind:
                fg = 203
            elif context.vcsahead:
                fg = 117
            elif context.vcsdiverged:
                fg = magenta
            elif context.vcsunknown:
                fg = 203

        return fg, bg, attr
