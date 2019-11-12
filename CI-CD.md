# Ci/CD


## CI
* Later elaborations of the concept introduced build servers, which 
  automatically ran the unit tests periodically or even after every commit and
  reported the results to the developers. The use of build servers (not 
  necessarily running unit tests) had already been practised by some teams 
  outside the XP community.
* In addition to automated unit tests, organisations using CI typically use a 
  build server to implement continuous processes of applying quality control in
  general — small pieces of effort, applied frequently. In addition to running
  the unit and integration tests, such processes run additional static and 
  dynamic tests, measure and profile performance, extract and format 
  documentation from the source code and facilitate manual QA processes.
* A complementary practice to CI is that before submitting work, each 
  programmer must do a complete build and run (and pass) all unit tests. 
  Integration tests are usually run automatically on a CI server when it 
  detects a new commit.
* Normal practice is to trigger these builds by every commit to a repository, 
  rather than a periodically scheduled build. The practicalities of doing this
  in a multi-developer environment of rapid commits are such that it is usual 
  to trigger a short time after each commit, then to start a build when either
  this timer expires, or after a rather longer interval since the last build.
* Although daily builds were considered a best practice of software development
  in the 1990s, they have now been superseded. Continuous integration is now 
  run on an almost continual basis, with a typical cycle time of around 20-30 
  minutes since the last change to the source code. Continuous integration 
  servers such as CruiseControl or Hudson continually monitor the source code 
  control system. When new changes are detected, a build tool such as Ant or 
  Maven is used to re-build the software. Good practice today is also to use 
  this as part of continuous testing, so that unit tests are re-run for each 
  build, and more extensive functional testing (which takes longer to perform 
  than the build) performed as frequently as its duration permits.

### principles which CI relies on

#### Maintain a code repository

All artifacts required to build the project should be placed in the repository.
The mainline (or trunk) should be the place for the working version of the 
software.

#### Automate the build

A single command should have the capability of building the system. Automation
of the build should include automating the integration, which often includes 
deployment into a production-like environment. In many cases, the build script
not only compiles binaries, but also generates documentation, website pages, 
statistics and distribution media (such as Debian DEB, Red Hat RPM)

#### Make the build self-testing

Once the code is built, all tests should run to confirm that it behaves as the
developers expect it to behave.

#### Everyone commits to the baseline every day

Ccommiting as soon as possible, at least once per day reduces conflicting hell.
Committing all changes at least once a day (once per feature built) is 
generally considered part of the definition of Continuous Integration. In 
addition performing a nightly build is generally recommended.

#### Every commit (to baseline) should be built

#### Keep the build fast

#### Test in a clone of the production environment

Building a replica of a production environment is cost prohibitive. Instead, 
the test environment, or a separate pre-production environment ("staging") 
should be built to be a scalable version of the production environment to 
alleviate costs while maintaining technology stack composition and nuances.

#### Make it easy to get the latest deliverables

Making builds readily available to stakeholders and testers can reduce the 
amount of rework necessary when rebuilding a feature that doesn't meet 
requirements. Additionally, early testing reduces the chances that defects 
survive until deployment. Finding errors earlier can reduce the amount of work
necessary to resolve them.

#### Everyone can see the results of the latest build

#### Automate deployment

### CI benefits and costs

* [View on Wikipedia](https://en.wikipedia.org/wiki/Continuous_integration#Costs_and_benefits)

## CD

![Principles](https://upload.wikimedia.org/wikipedia/commons/c/c3/Continuous_Delivery_process_diagram.svg)

Code is compiled if necessary and then packaged by a build server every time a
change is committed to a source control repository, then tested by a number of
different techniques (possibly including manual testing) before it can be 
marked as releasable.

> It is important to understand that any code commit may be released to 
> customers at any point. 

Other useful techniques for developing code in isolation such as code branching
are not obsolete in a CD world, but must be adapted to fit the principles of CD - 
for example, running multiple long-lived code branches can prove impractical,
as a releasable artifact must be built early in the CD process from a single 
code branch if it is to pass through all phases of the pipeline.

### Benefits and obstacles

* [Benefits and obstacles on Wikipedia](https://en.wikipedia.org/wiki/Continuous_delivery#Benefits_and_obstacles)

### Strategies to overcome adoption challenges

| Strategy | Description |
| -------- | ----------- |
| Selling CD as a painkiller | Identify each stakeholder's pain points that CD can solve, and sell CD as a painkiller to that stakeholder. This strategy helps to achieve buy-in from the wide range of stakeholders that a CD implementation requires. |
| Dedicated team with multi-disciplinary members | Without a dedicated team, it can be hard to progress because employees are often assigned to work on other value streams. A multi-disciplinary team not only provides the wide range of skills required for CD implementation but also smooths the communication with related teams. |
| Continuous delivery of continuous delivery | Organize the implementation of CD in a way that delivers value to the company as early as possible, onboarding more projects gradually, in small increments and eventually rolling out CD across the whole organization. This strategy helps justify the investment required by making concrete benefits visible along the way. Visible benefits, in turn, help to achieve the sustained company support and investment required to survive the long and tough journey to CD. |
| Starting with easy but important applications. | When selecting the first few applications to migrate to CD, choose the ones that are easy to migrate but that are important to the business. Being easy to migrate helps to demonstrate the benefits of CD quickly, which can prevent the implementation initiative from being killed. Being important to the business helps to secure the required resources, demonstrates clear and unarguable value, and raises the visibility of CD in the organization. |
| Visual CD pipeline skeleton | Give a team a visual CD pipeline skeleton that has the full CD pipeline view but with empty stages for those they cannot implement yet. This helps to build up a CD mindset and maintain the momentum for CD adoption. The pipeline skeleton is especially useful when the team's migration to CD requires a large effort and mindset changes over a long period of time. |
| Expert drop | Assign a CD expert to join tough projects as a senior member of the development team. Having the expert on the team helps to build the motivation and momentum to move to CD from inside the team. It also helps to maintain momentum when the migration requires a large effort and a long period of time. |

### List of build automation software

* Refer to the [Wikipedia](https://en.wikipedia.org/wiki/List_of_build_automation_software) 
article.

