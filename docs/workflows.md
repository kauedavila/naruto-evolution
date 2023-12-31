# GitHub Workflows

| Workflow                  | Jobs                   | Trigger                              | Trigger    |
| ------------------------- | ---------------------- | ------------------------------------ | :--------: |
| Build                     | Build                  | On Pull Request: *master*, *develop* | On Trigger |
| Manual Deployment         | Build, Deploy          | On Trigger                           | -          |
| Release (Alpha Server)    | Build, Deploy          | On Push: *develop*                   | -          |
| Release (Beta Server)     | Build, Deploy          | On Push: *master*                    | -          |
| Release (Official Server) | Build, Release, Deploy | On Trigger                           | -          |

## Workflow Inputs

### Manual Deployment

- **Branch** - The branch you want to run the workflow on.
- - **Options:** *\<branch>*

- **Server** - The server you want to deploy to.
- - **Options:** *official*, *beta*, or *alpha*.

- **Version** - The version  (tag) you want to deploy.*
- - **Options:** *\<tag>*

### Release (Official Server)

- **Branch** - The branch you want to base the release on.*
- - **Options:** *\<branch>*

- **Version** - The version (tag) you want to give this release.
- - **Options:** *\<tag>*

***Warning:** Do <u>not</u> use the master (or default) branch for releases as the changelog generator will generate a blank changelog.*