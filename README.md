# common-ci-pipeline

## Table of contents

- [common-ci-pipeline](#common-ci-pipeline)
  - [Table of contents](#table-of-contents)
  - [Description](#description)
  - [Actions/Workflows descriptions](#actionsworkflows-descriptions)
    - [Workflow: Create release branch](#workflow-create-release-branch)
    - [Workflow: Finish release](#workflow-finish-release)
    - [Workflow: Add Label Hotfix - Releases](#workflow-add-label-hotfix---releases)

## Description

This project aims at providing worlflow actions similar to Gitflow to your projects. The aim is to implement the project as is in the differents projects of the team or across multiple teams to simplify the migration to Gitflow.

## How to set up

This section explains how to set up the CI/CD workflows for you own project

### Github Variables 

In order to be able to run the workflow a runner must be defined. In this project, the runner name has been variablised and can be set up on your Github repo configuration. 

To do so, go to your Github project configuration, then Secrets and Variables  > Actions > Variables. In Repository variables add the following :
- `RUNNER_NAME` with the value corresponding to the name of your runner 

### Calling the actions from your repo

You will need to create a workflow for each of the workflow present in this repo. In those you will need to only set up the inputs and call the workflow from this repo. Nothing else is needed, no actions to write.

**Example below for the Create release workflow :**

```
name: Create release branch

on:
  workflow_dispatch:
    inputs:
      upgrade-type:
        type: choice
        required: true
        description: "Type of upgrade to apply for release"
        options:
          - patch
          - minor
          - major

jobs:
  create-release:
    runs-on: ${{ RUNNER_NAME }}
    steps:
      - name: Create release
        uses: data-engineering-helpers/common-ci-pipeline/.github/actions/create-release@<version>
        with:
          upgrade-type: ${{ github.event.inputs.upgrade-type }}
          repo-token: ${{ github.token }}
```

## Actions/Workflows descriptions

The workflows available in this project aims at reproducing the gitflow actions concerning releases.
Each workflow is detailed below.

More features and actions could be made available in the future.

### Workflow: Create release branch

This action will attempt to create a release branch from the latest commit of the develop branch and create the related Pull Request to the main branch with a automatic message. The branch can then be pulled and worked on.

**/!\\** The action will fail if there is already an opened Pull Request with the label "release" as there should not be two releases at the same time.

This action takes the upgrade type to apply (`upgrade-type`) as input. The value must be one of : **major**, **minor**, **patch**.

### Workflow: Finish release

This action is not to be run by the developer but will run automatically and proceed when a pull request concerning a release is merged.
The action will try to create the tag with the version number associated with the release Pull Request which was merged.

### Workflow: Add Label Hotfix - Releases

This action is not to be run by the developer but will run automatically and proceed when a pull request which name starts with either "Hotfix" or "Release" is created. The action will proceed to add the matching label (eiher "hotfix" or "release" to the pull request).