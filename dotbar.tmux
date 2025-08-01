#!/usr/bin/env bash

get_tmux_option() {
  local option=$1
  local default_value="$2"

  local option_value
  option_value=$(tmux show-options -gqv "$option")

  if [ "$option_value" != "" ]; then
    echo "$option_value"
    return
  fi
  echo "$default_value"
}

# colors
bg=$(get_tmux_option "@tmux-dotbar-bg" '#0B0E14')
fg=$(get_tmux_option "@tmux-dotbar-fg" '#475266')
fg_current=$(get_tmux_option "@tmux-dotbar-fg-current" '#BFBDB6')
fg_session=$(get_tmux_option "@tmux-dotbar-fg-session" '#565B66')
fg_prefix=$(get_tmux_option "@tmux-dotbar-fg-prefix" '#95E6CB')

status=$(get_tmux_option "@tmux-dotbar-position" "bottom")
justify=$(get_tmux_option "@tmux-dotbar-justify" "absolute-centre")

left_state=$(get_tmux_option "@tmux-dotbar-left" true)
status_left=$("$left_state" && get_tmux_option "@tmux-dotbar-status-left" "#[bg=$bg,fg=$fg_session]#{?client_prefix,, #S }#[bg=$fg_prefix,fg=$bg,bold]#{?client_prefix, #S ,}#[bg=$bg,fg=${fg_session}]")

right_state=$(get_tmux_option "@tmux-dotbar-right" false)
status_right=$("$right_state" && get_tmux_option "@tmux-dotbar-status-right" "#[bg=$bg,fg=$fg_session] %H:%M #[bg=$bg,fg=${fg_session}]")

window_status_format=$(get_tmux_option "@tmux-dotbar-window-status-format" ' #W ')
window_status_separator=$(get_tmux_option "@tmux-dotbar-window-status-separator" ' • ')

maximized_pane_icon=$(get_tmux_option "@tmux-dotbar-maximized-icon" '󰊓')
show_maximized_icon_for_all_tabs=$(get_tmux_option "@tmux-dotbar-show-maximized-icon-for-all-tabs" false)

tmux set-option -g status-position "$status"
tmux set-option -g status-style "bg=${bg},fg=${fg}"
tmux set-option -g status-justify "$justify"

tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"

tmux set-window-option -g window-status-separator "$window_status_separator"

tmux set-option -g window-status-style "bg=${bg},fg=${fg}"
tmux set-option -g window-status-format "$window_status_format"
"$show_maximized_icon_for_all_tabs" && tmux set-option -g window-status-format "${window_status_format}#{?window_zoomed_flag,${maximized_pane_icon},}"

tmux set-option -g window-status-current-format "#[bg=${bg},fg=${fg_current}]${window_status_format}#[fg=#39BAE6,bg=${bg}]#{?window_zoomed_flag,${maximized_pane_icon},}#[fg=${bg},bg=default]"
