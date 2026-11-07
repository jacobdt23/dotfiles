# =============================================================================
# HyprFrost Bobthefish & Oh My Fish Configuration
# Tokyo Night Palette, Nerd Fonts & Advanced Powerline Segments
# =============================================================================

# 1. Glyphs & Typography
set -g theme_nerd_fonts yes
set -g theme_powerline_fonts yes
set -g theme_avoid_ambiguous_glyphs yes

# 2. Two-Line Layout & Prompt Character
set -g theme_newline_cursor yes
set -g theme_newline_prompt "❯ "

# 3. User & Hostname Identification
set -g theme_display_user yes
set -g default_user ""
set -g theme_display_sudo_user yes
set -g theme_display_hostname yes

# 4. Path & Directory Presentation
set -g fish_prompt_pwd_dir_length 0
set -g theme_project_dir_length 0
set -g theme_show_project_parent yes

# 5. Live Clock / Timestamp (Right Prompt)
set -g theme_display_date yes
set -g theme_date_format "+%I:%M %p"

# 6. Comprehensive Git & VCS Status
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_stashed_verbose yes
set -g theme_display_git_default_branch yes
set -g theme_git_default_branches main master
set -g theme_git_worktree_support yes
set -g theme_use_abbreviated_branch_name yes

# 7. Developer Environment Segments
set -g theme_display_node yes
set -g theme_display_virtualenv yes
set -g theme_display_ruby yes
set -g theme_display_go verbose
set -g theme_display_docker_machine yes
set -g theme_display_vagrant yes
set -g theme_display_k8s_context yes

# 8. Command Status, Jobs & Diagnostics
set -g theme_display_cmd_duration yes
set -g theme_display_jobs_verbose yes
set -g theme_show_exit_status yes
set -g theme_title_display_process yes
set -g theme_title_display_path yes
set -g theme_title_display_user yes

# 9. Custom Tokyo Night Segment Color Mapping
function bobthefish_colors -S -d 'Custom Tokyo Night scheme for bobthefish'
    # Initial status segments (exits, root, background jobs)
    set -x color_initial_segment_exit     c0caf5 f7768e --bold
    set -x color_initial_segment_private  c0caf5 1a1b26
    set -x color_initial_segment_su       c0caf5 9ece6a --bold
    set -x color_initial_segment_jobs     c0caf5 7aa2f7 --bold

    # User & Host chips
    set -x color_username                 161722 7aa2f7 --bold
    set -x color_hostname                 1a1b26 bb9af7

    # Path breadcrumbs
    set -x color_path                     24283b a9b1d6
    set -x color_path_basename            24283b c0caf5 --bold
    set -x color_path_nowrite             24283b f7768e
    set -x color_path_nowrite_basename    24283b f7768e --bold

    # Git status segments
    set -x color_repo                     1f2335 7aa2f7
    set -x color_repo_work_tree           1f2335 c0caf5 --bold
    set -x color_repo_dirty               1f2335 f7768e
    set -x color_repo_staged              1f2335 9ece6a

    # Vi mode indicators (if enabled)
    set -x color_vi_mode_default          7aa2f7 1a1b26 --bold
    set -x color_vi_mode_insert           9ece6a 1a1b26 --bold
    set -x color_vi_mode_visual           e0af68 1a1b26 --bold

    # Developer runtimes
    set -x color_node                     1f2335 9ece6a --bold
    set -x color_virtualfish              1f2335 e0af68 --bold
    set -x color_virtualgo                1f2335 7dcfff --bold
    set -x color_vagrant                  7dcfff 1a1b26
    set -x color_k8s                      bb9af7 c0caf5 --bold
    set -x color_screen                   9ece6a 1a1b26 --bold
end
