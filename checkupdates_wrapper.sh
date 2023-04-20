#!/bin/bash

# Temporary script, that uses checkupdates to make sure we actually need an update
# Currently unused, since we should always make sure to use up-to-date databases (so that installs don't fail because packages can't be found)
# and checkupdates does not do that any faster than regular pacman anyway.

if [[ "${DO_UPDATES}" == true ]]; then
    do_update=false
    # Use checkupdates if available to check for updates
    which checkupdates &>/dev/null
    if [[ $? -eq 0 ]]; then
        do_update=true
        to_update_packages=( $(checkupdates | sort) )
    else
        do_update=true
        to_update_packages=()
    fi
    if [[ ${do_update} == true ]]; then
        if [[ ${#to_update_packages[@]} -ne 0 ]]; then
            [[ "${SILENT}"  == "false" ]] && echo "Updating packages:"
            [[ "${SILENT}"  == "false" ]] && printf '  %s\n' "${to_update_packages[@]}"
        else
            [[ "${SILENT}"  == "false" ]] && echo "Updating packages"
        fi
        [[ "${DRY_RUN}" == "false" ]] && sudo pacman -Syu "${PACMAN_OPTIONS[@]}"
    fi
fi
