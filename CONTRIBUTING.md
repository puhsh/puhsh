## "It’s not fully shipped until it’s fast." - [@tmn](https://github.com/tnm), GitHub

We want puhsh to be fast. Extra fast. That requires a level of commitment from you, the contributor, to make sure puhsh stays fast. 

This is a guideline to help you contribute to puhsh. All open items that need to be worked on are managed through this repo's issue system. Milestones are used to group these work items together. Bugs and other tasks are also located within the issues.
## Rules for Contributing
1. It is not shipped / finished until it is fast. Period.
2. There should always be specs for your pull requests (exceptions can be made).
3. You cannot accept your own pull request.


## Contribution Process
Puhsh contributions follow the traditional open source process.

1. Create a branch (even if it is for small changes but exceptions can be made)
2. Make the code changes / write your specs. Make sure you tie all your commits to the issue / task you are working on. (You can use #IssueNumber if you are in the main repo or puhsh/puhsh #IssueNumber if you are in a different repo)
3. Submit a pull request once you have finished making changes. Minor changes do not need to have a pull request.
4. If there is a pull request, participate in the code review process / make changes / wait for someone else to merge your changes. You are not allowed to merge your own pull request.
5. Delete your branch once the merge occurs.

## Continuous Delivery

Puhsh is built upon a continuous delivery system using Jenkins. This requires you to always be thinking about what your code changes will do to production but, at the same time, allows you move quickly. There is no backlog of items, in master, waiting to be shipped.

The work flow is as follows

1. Pull request is merged into Master.
2. Jenkins pulls down the latest code and runs the tests.
3a. If the tests all pass, Jenkins deploys to production shortly after.
 b. If the tests fail, no further builds will be deployed to production till all the specs are green again.

## Development Best Practices
Here are some recommendations to effectively develop against the Rails App

* When generating a API controller, use `rails g controller_name --no-helper --no-assets`. These end points do not need assets or helpers.
* [Guard](https://github.com/guard/guard) is highly recommended. When you pull down the repo, init your guard file and make sure it is running. This will save you headaches when you make changes and deploys fail
* Sandbox can be used to create test data. Creating test data in Production is highly discouraged.
* When adding a gem to the Gemfile, be sure to include the version. This makes monthly audits easier.
