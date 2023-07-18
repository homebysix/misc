# AutoPkg in Depth: Understanding, Selecting, Creating, and Maintaining Recipes <!-- omit in toc -->

- [AutoPkg prerequisites and basics](#autopkg-prerequisites-and-basics)
- [Recipe reading and literacy](#recipe-reading-and-literacy)
    - [Recipes](#recipes)
    - [Processors](#processors)
    - [Choosing recipes](#choosing-recipes)
- [Running recipes via overrides](#running-recipes-via-overrides)
- [Specific recipe types](#specific-recipe-types)
- [Creating new recipes](#creating-new-recipes)
- [Testing your recipes](#testing-your-recipes)
- [Sharing your recipes](#sharing-your-recipes)
- [Advanced topics](#advanced-topics)
    - [Writing custom processors](#writing-custom-processors)
    - [Contributing to AutoPkg](#contributing-to-autopkg)
    - [Coming attractions](#coming-attractions)

**Elliot Jordan, Netflix**

- [Twitter](https://twitter.com/homebysix)
- MacAdmins Slack: elliotjordan
- [GitHub](https://github.com/homebysix)

**Anthony Reimer, University of Calgary**

- Mastodon: @AnthonyReimer@mastodon.social
- MacAdmins Slack: jazzace
- [GitHub](https://github.com/jazzace)

**General Links**

- [PSU Session Feedback](https://bit.ly/psumac2023-102)
- [Links and References](https://tinyurl.com/AutoPkgWorkshop) (this page)

## AutoPkg prerequisites and basics

- [AutoPkg Releases](https://github.com/autopkg/autopkg/releases)
- [AutoPkg Wiki](https://github.com/autopkg/autopkg/wiki)
- [Xcode Command Line Tools](https://developer.apple.com/download/)
- [AutoPkgSetup](https://github.com/grahampugh/AutoPkgSetup)
- [AutoPkgr](https://github.com/lindegroup/autopkgr/)

## Recipe reading and literacy

- [How (Not) To Do Bad Things With AutoPkg - PSU MacAdmins Conference 2017](https://youtube.com/watch?v=LnvQmLcDF8w)

### Recipes

- [grahampugh-recipes (Yaml)](https://github.com/autopkg/grahampugh-recipes)
- [AutoPkg GitHub organization](https://github.com/autopkg)
- [AutoPkg Wiki: Sharing Recipes - Repo Maintenance Expectations](https://github.com/autopkg/autopkg/wiki/Sharing-Recipes#repo-maintenance-expectations)
- [AutoPkg "core" recipes](https://github.com/autopkg/recipes)
- [homebysix-recipes](https://github.com/autopkg/homebysix-recipes)
- [jazzace-recipes](https://github.com/autopkg/jazzace-recipes)
- [arubdesu/office-recipes](https://github.com/arubdesu/office-recipes)
- [FindAndReplace stub recipe](https://github.com/autopkg/homebysix-recipes/blob/master/FindAndReplace/FindAndReplace.recipe)
- [JamfTemplates](https://github.com/autopkg/jazzace-recipes/tree/master/JamfTemplates/RecipeTemplates)
- [Anthony’s Mac Labs Blog | 📦 AutoPkg Input Variables](https://maclabs.jazzace.ca/2019/11/11/autopkg-input-variables.html)
- [jss-recipes/Comic Life/Comic Life 3.jss.recipe (`version` processed at runtime)](https://github.com/autopkg/jss-recipes/blob/97337da6fbc859b76e12d8b032174ee4b57ded35/Comic%20Life%203/Comic%20Life%203.jss.recipe#L27)
- [jazzace-recipes/GardenGnome/Pano2VR.download.recipe](https://github.com/autopkg/jazzace-recipes/blob/master/GardenGnome/Pano2VR.download.recipe)

### Processors

- [AutoPkg Wiki: Processors](https://github.com/autopkg/autopkg/wiki/Processors)
- [AutoPkg Wiki: SparkleUpdateInfoProvider](https://github.com/autopkg/autopkg/wiki/Processor-SparkleUpdateInfoProvider)
- [Pano2VR.download.recipe](https://github.com/autopkg/jazzace-recipes/blob/master/GardenGnome/Pano2VR.download.recipe)
- [AutoPkg core processors](https://github.com/autopkg/autopkg/tree/master/Code/autopkglib)
    - [AutoPkg Wiki: URLDownloader](https://github.com/autopkg/autopkg/wiki/Processor-URLDownloader)
    - [AutoPkg Wiki: Unarchiver](https://github.com/autopkg/autopkg/wiki/Processor-Unarchiver)
    - [AutoPkg Wiki: FlatPkgUnpacker](https://github.com/autopkg/autopkg/wiki/Processor-FlatPkgUnpacker)
    - [AutoPkg Wiki: PkgPayloadUnpacker](https://github.com/autopkg/autopkg/wiki/Processor-PkgPayloadUnpacker)
    - [AutoPkg Wiki: CodeSignatureVerifier](https://github.com/autopkg/autopkg/wiki/Processor-CodeSignatureVerifier)
    - [AutoPkg Wiki: FileMover](https://github.com/autopkg/autopkg/wiki/Processor-FileMover)
    - [AutoPkg Wiki: Copier](https://github.com/autopkg/autopkg/wiki/Processor-Copier)
    - [AutoPkg Wiki: PkgCopier](https://github.com/autopkg/autopkg/wiki/Processor-PkgCopier)
    - [AutoPkg Wiki: DmgCreator](https://github.com/autopkg/autopkg/wiki/Processor-DmgCreator)
    - [AutoPkg Wiki: PkgCreator](https://github.com/autopkg/autopkg/wiki/Processor-PkgCreator)
    - [AutoPkg Wiki: AppPkgCreator](https://github.com/autopkg/autopkg/wiki/Processor-AppPkgCreator)
    - [AutoPkg Wiki: FileCreator](https://github.com/autopkg/autopkg/wiki/Processor-FileCreator)
    - [AutoPkg Wiki: PathDeleter](https://github.com/autopkg/autopkg/wiki/Processor-PathDeleter)
    - [AutoPkg Wiki: URLTextSearcher](https://github.com/autopkg/autopkg/wiki/Processor-URLTextSearcher)
    - [AutoPkg Wiki: SparkleUpdateInfoProvider](https://github.com/autopkg/autopkg/wiki/Processor-SparkleUpdateInfoProvider)
    - [AutoPkg Wiki: GitHubReleasesInfoProvider](https://github.com/autopkg/autopkg/wiki/Processor-GitHubReleasesInfoProvider)
    - [AutoPkg Wiki: FileFinder](https://github.com/autopkg/autopkg/wiki/Processor-FileFinder)
    - [AutoPkg Wiki: AppDmgVersioner](https://github.com/autopkg/autopkg/wiki/Processor-AppDmgVersioner)
    - [AutoPkg Wiki: Versioner](https://github.com/autopkg/autopkg/wiki/Processor-Versioner)
    - [AutoPkg Wiki: PlistReader](https://github.com/autopkg/autopkg/wiki/Processor-PlistReader)
    - [AutoPkg Wiki: StopProcessingIf](https://github.com/autopkg/autopkg/wiki/Processor-StopProcessingIf)
    - [AutoPkg Wiki: PackageRequired](https://github.com/autopkg/autopkg/wiki/Processor-PackageRequired)
    - [AutoPkg Wiki: EndOfCheckPhase](https://github.com/autopkg/autopkg/wiki/Processor-EndOfCheckPhase)
    - [AutoPkg Wiki: DeprecationWarning](https://github.com/autopkg/autopkg/wiki/Processor-DeprecationWarning)
    - [AutoPkg Wiki: MunkiCatalogBuilder](https://github.com/autopkg/autopkg/wiki/Processor-MunkiCatalogBuilder)
    - [AutoPkg Wiki: MunkiImporter](https://github.com/autopkg/autopkg/wiki/Processor-MunkiImporter)
    - [AutoPkg Wiki: MunkiInfoCreator](https://github.com/autopkg/autopkg/wiki/Processor-MunkiInfoCreator)
    - [AutoPkg Wiki: MunkiInstallsItemsCreator](https://github.com/autopkg/autopkg/wiki/Processor-MunkiInstallsItemsCreator)
    - [AutoPkg Wiki: MunkiOptionalReceiptEditor](https://github.com/autopkg/autopkg/wiki/Processor-MunkiOptionalReceiptEditor)
    - [AutoPkg Wiki: MunkiPkginfoMerger](https://github.com/autopkg/autopkg/wiki/Processor-MunkiPkginfoMerger)
    - [AutoPkg Wiki: MunkiSetDefaultCatalog](https://github.com/autopkg/autopkg/wiki/Processor-MunkiSetDefaultCatalog)
    - [AutoPkg Wiki: PkgRootCreator](https://github.com/autopkg/autopkg/wiki/Processor-PkgRootCreator)
- [AutoPkg Wiki: Developing Custom Processors](https://github.com/autopkg/autopkg/wiki/Developing-Custom-Processors)
    - [VersionSplitter](https://github.com/autopkg/homebysix-recipes/tree/master/VersionSplitter)
    - [SourceForgeURLProvider](https://github.com/autopkg/jessepeterson-recipes/blob/master/GrandPerspective/SourceForgeURLProvider.py)
- [Anthony’s Mac Labs Blog | 📦 Core or Custom AutoPkg Processors?](https://maclabs.jazzace.ca/2019/09/14/core-or-custom-autopkg-processors.html)


### Choosing recipes

- URLs for searching recipes in AutoPkg org:
    - https://github.com/search?type=code&q=org%3Aautopkg+firefox
    - https://github.com/search?q=org%3Aautopkg+firefox+AND+.pkg.recipe&type=code
- Comparing recipes:
    - [autopkg/recipes/Mozilla/Firefox.pkg.recipe](https://github.com/autopkg/recipes/blob/master/Mozilla/Firefox.pkg.recipe)
    - [autopkg/rtrouton-recipes/Firefox/Firefox.pkg.recipe](https://github.com/autopkg/rtrouton-recipes/blob/master/Firefox/Firefox.pkg.recipe)
- [AutoPkg Dupe Tracker (experimental)](https://homebysix.github.io/autopkg-dupe-tracker/)

## Running recipes via overrides

- [AutoPkg Wiki: Recipe overrides](https://github.com/autopkg/autopkg/wiki/Recipe-Overrides)
- [AutoPkg Wiki: Parent recipe trust information](https://github.com/autopkg/autopkg/wiki/AutoPkg-and-recipe-parent-trust-info)
- [Anthony’s Mac Labs Blog | 📦 Multiple AutoPkg Recipes or Just Override?](https://maclabs.jazzace.ca/2019/08/31/multiple-recipes-or-just-override.html)
- [homebysix-recipes/GitHub/GitHubDesktop.munki.recipe](https://github.com/autopkg/homebysix-recipes/blob/master/GitHub/GitHubDesktop.munki.recipe)
- [AutoPkgr Wiki: Scheduling and Notifications](https://github.com/lindegroup/autopkgr/wiki/Scheduling-and-Notifications)
- [Running AutoPkg in Github Actions](https://engineering.gusto.com/running-autopkg-in-github-actions/)

## Specific recipe types

- [AutoPkg Wiki: Recipe Naming Conventions](https://github.com/autopkg/autopkg/wiki/Recipe-Naming-Conventions)

## Creating new recipes

- [Anthony’s Mac Labs Blog | 📦 Generic App-Packaging Recipes for AutoPkg](https://maclabs.jazzace.ca/2018/11/17/generic-packaging-recipes-for-autopkg.html)
- [Recipe Robot](https://github.com/homebysix/recipe-robot)
    - [Video tutorial: Intro to Recipe Robot](https://www.youtube.com/watch?v=E531jJLovhc&list=PLK1ZziC_XFWoDnSYU3__WRQCRpXA2fhXq&index=2)
    - [Using Recipe Robot to create child recipes for existing parent recipes](https://youtu.be/5VKDzY8bBxI?t=2829)
- William Smith: An Introduction to RegEx
    - [GitHub repo](https://github.com/talkingmoose/introduction-to-regex)
    - [Video](https://youtu.be/Wc8Kpw0nEww)
- [AutoPkg Wiki: Using Code Signature Verification](https://github.com/autopkg/autopkg/wiki/Using-CodeSignatureVerification/)
- [Anthony’s Mac Labs Blog | 📦 Text Searching in AutoPkg](https://maclabs.jazzace.ca/2022/08/17/text-searching-in-autopkg.html)
- [Patterns.app](https://krillapps.com/patterns/)
- [regex101: build, test, and debug regex](https://regex101.com/)
- [Ben Toms: Digging for download URLs for AutoPkg recipes](https://macmule.com/2021/06/14/macdevopsyvr-2021-digging-for-download-urls-for-autopkg-recipes/)
- Text editors:
    - [BBEdit](https://www.barebones.com/products/bbedit/)
    - [Visual Studio Code](https://code.visualstudio.com/)
    - [Sublime Text](https://www.sublimetext.com/)
    - [Nova](https://nova.app/)
- [BBEdit AutoPkg Clippings](https://github.com/jazzace/BBEdit-AutoPkg-Clippings)
- [Code Spell Checker - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [Pre-Commit Hooks for Mac Admins](https://github.com/homebysix/pre-commit-macadmin)
- [Elliot Jordan - Using pre-commit to validate AutoPkg recipes](https://www.elliotjordan.com/posts/pre-commit-02-autopkg/)
- [Python Black](https://pypi.org/project/black/)
- [Elliot Jordan: Linters, Hooks, and Pipelines – Automation to Save Your Bacon](https://www.youtube.com/watch?v=mYKEM9Gplks&feature=youtu.be)
- [EndOfCheckPhase convention](https://github.com/autopkg/n8felton-recipes/pull/109)
- [FossHub and AutoPkg](https://macmule.com/2019/03/17/fosshub-autopkg/)
- [Giving feedback to devs about SSL](https://twitter.com/homebysix/status/714508127228403712)
- [`%NAME%` convention](https://github.com/autopkg/zachtarr-recipes/pull/1)
- [AutoPkg Wiki: Recipe Writing Guidelines](https://github.com/autopkg/autopkg/wiki/Recipe-Writing-Guidelines)
- [Product Hunt: Mac apps](https://www.producthunt.com/topics/mac)

## Testing your recipes

- [homebysix-recipes `nose` tests](https://github.com/autopkg/homebysix-recipes/tree/master/test)

## Sharing your recipes

- [AutoPkg Wiki: Sharing recipes](https://github.com/autopkg/autopkg/wiki/Sharing-Recipes)
    - [AutoPkg Wiki: Recipe maintainer expectations](https://github.com/autopkg/autopkg/wiki/Sharing-Recipes#repo-maintenance-expectations)

## Advanced topics

### Writing custom processors

- The amazing flexibility of URLTextSearcher:
    - [Use URLTextSearcher instead of custom Deluge provider: autopkg/thenikola-recipes](https://github.com/autopkg/thenikola-recipes/pull/29)
    - [Use URLTextSearcher instead of custom processor for Composer: autopkg/ygini-recipes](https://github.com/autopkg/ygini-recipes/pull/21)
    - [Use URLTextSearcher instead of custom processor for Cura: autopkg/jps3-recipes](https://github.com/autopkg/jps3-recipes/pull/72)
    - [Use URLTextSearcher instead of custom URL provider for Jin: autopkg/sheagcraig-recipes](https://github.com/autopkg/sheagcraig-recipes/pull/56)
    - [Use URLTextSearcher instead of custom Praat URL provider: autopkg/recipes](https://github.com/autopkg/recipes/pull/330)
- [Substitute Node release into URL instead of using custom processor: autopkg/gerardkok-recipes](https://github.com/autopkg/gerardkok-recipes/pull/127)
- [Anthony’s Mac Labs Blog | 📦 Office AutoPkg Recipes — Update](https://maclabs.jazzace.ca/2019/05/18/office-autopkg-recipes-update.html)
- [rtrouton-recipes/MicrosoftExcel365/MicrosoftExcel365.pkg.recipe](https://github.com/autopkg/rtrouton-recipes/blob/master/MicrosoftExcel365/MicrosoftExcel365.pkg.recipe)
- [MozillaURLProvider](https://github.com/autopkg/recipes/blob/master/Mozilla/MozillaURLProvider.py)
- [autopkg/recipes/SampleSharedProcessor/SampleSharedProcessor.py](https://github.com/autopkg/recipes/blob/master/SampleSharedProcessor/SampleSharedProcessor.py)
- [AutoPkg Wiki: Downloading from the Internet in Custom Processors](https://github.com/autopkg/autopkg/wiki/Downloading-from-the-Internet-in-Custom-Processors)

### Contributing to AutoPkg

- [Contributing documentation](https://github.com/autopkg/autopkg/blob/master/CONTRIBUTING.md)
- [Example PR: Add verbs list-repos and processor-list](https://github.com/autopkg/autopkg/pull/628)

### Coming attractions

- [AutoPkg pull requests](https://github.com/autopkg/autopkg/pulls)
