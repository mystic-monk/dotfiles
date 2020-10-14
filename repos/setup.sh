#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*
REPO_PATH=$(realpath -m ~/dev/src/github/mystic-monk)

find * -name "*.list" | while read fn; do
    folder="${fn%.*}"

    info "Cloning $folder repositories..."


    mkdir -p "$REPO_PATH/$folder"
    substep_info "Folder created as $folder in $REPO_PATH..."

    while read repo; do
        if [[ $repo == $COMMENT ]];
        then continue; else
            pushd "$REPO_PATH/$folder" &> ~/dev/src/github/mystic-monk/$folder/null

            git clone $repo &> ~/dev/src/github/mystic-monk/$folder/null
            error_code=$?
            #substep_info "Repo cloned in $folder in path $REPO_PATH with error code as $error_code."

            if [[ error_code -eq 128 ]]; then
                substep_success "$repo in $REPO_PATH/$folder already exists."
            elif [[ $error_code -eq 0 ]]; then
                substep_success "Cloned $repo in $REPO_PATH/$folder."
            else
                substep_error "Failed to clone $repo in $REPO_PATH/$folder."
            fi
            popd &> ~/dev/src/github/mystic-monk/$folder/null
        fi
    done < "$fn"
    success "Finished cloning $folder repositories."
done
