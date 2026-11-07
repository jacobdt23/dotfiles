# =============================================================================
# HyprFrost Bobthefish & Oh My Fish Configuration
# Tokyo Night Palette & Nerd Fonts
# =============================================================================

# Prompt Aesthetics & Nerd Font Icons
set -g theme_nerd_fonts yes
set -g theme_powerline_fonts yes
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_default_branch yes
set -g theme_git_default_branches main master
set -g theme_display_cmd_duration yes
set -g theme_display_jobs_verbose yes
set -g theme_show_exit_status yes
set -g theme_display_user ssh
set -g theme_display_hostname ssh
set -g theme_avoid_ambiguous_glyphs yes

# Custom Tokyo Night Colors for Bobthefish Segments
function bobthefish_colors -S -d 'Custom Tokyo Night scheme for bobthefish'
    set -x color_initial_segment_exit     c0caf5 f7768e --bold
    set -x color_initial_segment_su       c0caf5 9ece6a --bold
    set -x color_initial_segment_jobs     c0caf5 7aa2f7 --bold

    set -x color_path                     24283b a9b1d6
    set -x color_path_basename            24283b c0caf5 --bold
    set -x color_path_nowrite             24283b f7768e
    set -x color_path_nowrite_basename    24283b f7768e --bold

    set -x color_repo                     1f2335 7aa2f7
    set -x color_repo_work_tree           1f2335 c0caf5 --bold
    set -x color_repo_dirty               1f2335 f7768e
    set -x color_repo_staged              1f2335 9ece6a

    set -x color_username                 1a1b26 7aa2f7 --bold
    set -x color_hostname                 1a1b26 bb9af7
end
