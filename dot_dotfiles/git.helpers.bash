#!/bin/bash

function updateChangelog() {
    today=$(date +%Y-%m-%d)
    header="## ${today}"
    content=$(git log --oneline HEAD~1..dev --pretty=format:%s | grep 'Merged PR' | sed -E 's/Merged PR ([0-9]+): (.*)/\2 (!\1)/'| sed 's/^/- /')
    # content=$(git log --merges --oneline HEAD~1..dev --pretty=format:%s | sed -E 's/Merged PR ([0-9]+): (.*)/\2 (!\1)/' | sed 's/^/- /')
    # content=$(git log --merges --oneline HEAD~1..dev --pretty=format:'%h %s' | sed -E 's/(.*) Merged PR ([0-9]+): (.*)/\3 (\1)/' | sed 's/^/- /')

    if [ -z "$content" ]; then
        echo "Someone squashed the commits..."
        content=$(git log --first-parent --oneline HEAD~1..dev --pretty=format:%s | sed -E 's/Merged PR ([0-9]+): (.*)/\2 (!\1)/' | sed 's/^/- /')
    fi

    changelog=""
    # Only update the changelog if there are changes to add
    if [ ! -z "$content" ]; then
        changelog="${header}\n\n${content}\n"
    fi

    # Only update the changelog if there are changes to add
    if [ ! -z "$changelog" ]; then
        # Find the line number of the first header with the same format as the generated header
        header_line=$(grep -nE "^## [0-9]{4}-[0-9]{2}-[0-9]{2}$" CHANGELOG.md | head -1 | cut -d':' -f1)

        # Insert the new changelog content before the header (if it exists)
        if [ ! -z "$header_line" ]; then
            echo "Adding to existing changelog"
            sed -i "${header_line}i ${changelog//$'\n'/$'\\\n'}" CHANGELOG.md
        else
            echo "Adding to a new changelog"
            echo -e "${changelog}\n$(cat CHANGELOG.md)" >CHANGELOG.md
        fi
    else
        echo "Nothing to add"
    fi
}

function copyArtifacts() {
    directory_name=$1
    directory_source=$(basename $(pwd))
    directory_target="../dt-webcomponents-ui/$directory_source/"

    cp $directory_name/dist/viviane.*.js $directory_name/dist/viviane.*.js.map CHANGELOG.md $directory_target
}

function mergeDevAndUpdateChangelog() {
    # Check if directory_name argument is empty
    if [ -z "$1" ]; then
        echo "Error: directory_name argument is missing. Please provide the directory name containing package.json as the first argument."
        return 0
    fi
    # Check if revision argument is provided
    if [ -z "$2" ]; then
        echo "Error: revision argument is missing. Please provide the revision like 1, 2..."
        return 0
    fi

    directory_name=$1
    revision=$2

    # Check if there are new commits in the dev branch
    git fetch
    dev_commits=$(git log --oneline origin/dev ^origin/releases)

    if [ -z "$dev_commits" ]; then
        echo "No new commits in the dev branch. Nothing to merge."
    else
        # Merge the dev branch into the releases branch and generate the changelog
        git checkout releases
        git merge dev --no-edit

        # Generate changelog and update it
        echo "Generating changelog"
        updateChangelog

        git add CHANGELOG.md

        # Check if the directory_name is not equal to "."
        if [ "${directory_name}" != "." ]; then
            # Build npm application in the specified directory
            echo "Building npm application in ${directory_name} folder"
            cd ${directory_name}
            npm run build
            # Add files that match the specified pattern to the git changes
            git add $(find dist/ -type f -name "viviane.*.js" -o -name "viviane.*.js.map")
            cd ..
        else
            # Build npm application in the current directory
            echo "Building npm application in current folder"
            npm run build
            # Add files that match the specified pattern to the git changes
            git add $(find dist/ -type f -name "viviane.*.js" -o -name "viviane.*.js.map")
        fi
        today=$(date +"%Y%m%d")
        git commit --amend -m "release: build ${today}.${revision}"
        echo "Dev branch merged into the releases branch and changelog updated."

        copyArtifacts $directory_name
        echo "Artifacts copied to dt-webcomponent folder."
    fi
}

alias npm-changelog=mergeDevAndUpdateChangelog
